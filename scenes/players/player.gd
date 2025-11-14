extends Unit
class_name Player

@onready var dash_timer: Timer = $DashTimer
@onready var dash_coold_down_timer: Timer = $DashCooldDownTimer
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var trail: Trail = $Visuals/Trail
@onready var weapon_container: WeaponContainer = $WeaponContainer
const dash_ghost_scene = preload("uid://iedgofu0oavf")

var current_weapons: Array[Weapon]

var is_dashing:bool = false # 是否在冲刺中
var dash_available:bool = true # 冲刺
@export var dash_ghost_interval = 0.01 # 幻影生成间隔时间
var ghost_timer = 0.0

var move_dir: Vector2

func _ready() -> void:
	super._ready()
	# 初始化冲刺计时器
	if stats.can_dash:
		dash_timer.wait_time = stats.dash_duration
		dash_coold_down_timer.wait_time = stats.dash_coold_down
	
	add_weapon(preload("uid://cnjr7t5rc1bx8"))
	
func _process(delta: float) -> void:
	move_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	var current_velocity = move_dir * stats.speed
	
	if is_dashing:
		current_velocity *= stats.dash_speed_multi
		if stats.can_dash_ghost:
			ghost_timer += delta
			if ghost_timer >= dash_ghost_interval:
				spawn_dash_ghost()
				ghost_timer = 0.0
	
	position += current_velocity * delta
	position.x = clamp(position.x,-1000,1000)
	position.y = clamp(position.y,-470,500)
	
	if can_dash():
		start_dash()
	
	update_animations()

## 添加武器
func add_weapon(data: ItemWeapon) -> void:
	var weapon := data.scene.instantiate() as Weapon
	add_child(weapon)
	weapon.setup_weapon(data)
	current_weapons.append(weapon)
	weapon_container.update_weapon_position(current_weapons)
	
## 更新玩家行为动画
func update_animations() -> void:
	if move_dir == Vector2.ZERO :
		ani_player.play("idle")
	else:
		ani_player.play("move")
		update_rotation()

## 更新玩家移动时左右朝向
func update_rotation() -> void:
	if move_dir == Vector2.ZERO :
		return
	if(move_dir.x != 0):
		visuals.scale.x = -0.5 if move_dir.x > 0 else 0.5
		
## 开始冲刺
func start_dash() -> void:
	is_dashing = true
	if stats.can_dash_trail :
		trail.start_trail()
	elif stats.can_dash_ghost:
		spawn_dash_ghost() # 开始冲刺时立即生成一个幻影
	dash_timer.start()
	visuals.modulate.a = 0.5 #冲刺时玩家透明度修改
	hurtbox.setup_deferred(true) #冲刺结束玩家关闭碰撞
	ghost_timer = dash_ghost_interval # 立即生成第一个幻影
	
	
## 是否可以冲刺
func can_dash() -> bool:
	# 是否冲刺中 and 冲刺冷却定时器处于停止状态 and 玩家处于移动中 and 按下冲刺按钮
	return not is_dashing and\
	dash_coold_down_timer.is_stopped() and\
	move_dir != Vector2.ZERO and\
	Input.is_action_just_pressed("dash") and\
	stats.can_dash

## 冲刺带鬼影特效
func spawn_dash_ghost() -> void:
	var ghost_instance = dash_ghost_scene.instantiate() as DashGhost
	get_parent().add_child(ghost_instance) # 添加到 Player 的父节点，避免随 Player 移动
	ghost_instance.global_position = sprite.global_position # 设置幻影位置与玩家当前位置相同
	#ghost_instance.global_rotation = sprite.global_rotation # 如果玩家有旋转，也保持一致
	
	# 设置幻影的纹理和翻转状态与玩家当前精灵一致
	if sprite.texture:
		ghost_instance.setup_ghost(move_dir, sprite.texture)
	else:
		# 如果 sprite.texture 为空，可能需要设置一个默认的或者跳过生成
		ghost_instance.queue_free() # 没有纹理则不生成
		

## 玩家是否面朝右边
func is_facing_right() -> bool:
	return visuals.scale.x == -0.5
		
## 冲刺计时器结束信号
func _on_dash_timer_timeout() -> void:
	dash_coold_down_timer.start() # 启动冲刺冷却定时器
	move_dir = Vector2.ZERO
	hurtbox.setup_deferred(false) #冲刺结束玩家开启碰撞
	is_dashing = false
	visuals.modulate.a = 1.0 #冲刺结束玩家透明度重置
	
#func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	#if not super.on_accuracy(hitbox.accuracy):
		#return
	#super._on_hurtbox_component_on_damaged(hitbox)
