extends Unit

## 敌人
class_name Enemy

@export var flock_push := 20.0 #避让同类的范围，只要不重合就行

@onready var vision_area: Area2D = $VisionArea
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@onready var knockback_timer: Timer = $KnockbackTimer

var can_move := true

var knockback_dir: Vector2
var knockback_power: float

func _process(delta: float) -> void:
	if not can_move:
		return
		
	# 1. 计算基础移动方向 (寻路/躲避同类)
	var movement_direction: Vector2 = Vector2.ZERO
	
	if knockback_power <= 0.0:
		if can_move_towards_player():
			# 只有满足距离条件时才追踪玩家
			movement_direction = get_move_direction()
			
	position += (movement_direction + knockback_dir * knockback_power) * stats.speed * delta
	update_rotation()

## 获取移动的方向，避免碰撞同类
func get_move_direction() -> Vector2:
	if not is_instance_valid(Globat.player):
		return Vector2.ZERO
	#计算从当前节点到玩家（Globat.player）的归一化向量。
	var direction := global_position.direction_to(Globat.player.global_position)
	#遍历所有与当前（VisionArea）的视觉区域
	for area: Node2D in vision_area.get_overlapping_areas():
		#确保我们正在处理的邻居不是自己，并且它仍然在场景树中（有效）。
		if area != self and area.is_inside_tree():
			#计算从邻居节点指向当前节点的向量。这个向量的方向就是排斥的方向。
			var vector := global_position - area.global_position
			#将计算出的排斥力添加到初始的 direction 上，从而调整最终的移动方向。
			direction += flock_push * vector.normalized() / vector.length()
	return direction

## 敌人面朝玩家
func update_rotation() -> void:
	if not is_instance_valid(Globat.player):
		return
	
	var move_right = Globat.player.global_position.x > global_position.x
	visuals.scale.x = -0.5 if move_right else 0.5
	
## 是否检测玩家并追踪
func can_move_towards_player() -> bool:
	return is_instance_valid(Globat.player) and\
	global_position.distance_to(Globat.player.global_position) > 60 ## 如果敌人和玩家距离小于60就不再继续移动

## 击退
func apply_knockback(knock_dir: Vector2, knock_power: float) -> void:
	knockback_dir = knock_dir
	knockback_power = knock_power
	if not knockback_timer.is_stopped():
		knockback_timer.stop()
		reset_knockback()
		
	knockback_timer.start()

## 重置击退	
func reset_knockback() -> void:
	knockback_dir = Vector2.ZERO
	knockback_power = 0.0
	
#func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	#if not super.on_accuracy(hitbox.accuracy):
		#return
	#super._on_hurtbox_component_on_damaged(hitbox)
	#if hitbox.knockback_power > 0 :
		#var dir := hitbox.source.global_position.direction_to(global_position)
		#apply_knockback(dir,hitbox.knockback_power)
	
## 受到伤害信号
func _on_health_component_on_unit_hit() -> void:
	super._on_health_component_on_unit_hit()
	print("攻击目标")

## 击退倒计时 
func _on_knockback_timer_timeout() -> void:
	reset_knockback()
