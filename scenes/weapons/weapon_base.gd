extends Node2D

## 武器脚本
class_name Weapon

@onready var sprite: Sprite2D = $Sprite2D ## 武器
@onready var cooldown_timer: Timer = $CooldownTimer ## 攻击冷却时间
@onready var collision: CollisionShape2D = %CollisionShape2D ## 武器攻击范围
@onready var weapon_behavior: WeaponBehavior = $WeaponBehavior

var data: ItemWeapon ## 当前武器信息
var is_attacking := false ## 是否正在攻击
var atk_start_pos: Vector2 ## 武器起始位置
var targets: Array[Enemy] ## 感应范围所有的敌人
var clossest_target: Enemy ## 最近的敌人
var weapon_spread: float

func _ready() -> void:
	# 初始化武器位置
	self.atk_start_pos = sprite.position
	
func _process(delta: float) -> void:
	if not is_attacking:
		if targets.is_empty():
			clossest_target = null
		else:
			update_closest_target()
	rotate_to_target(delta)
	update_visuals()
	if can_use_weapon():
		use_weapon()
	
## 设置武器
func setup_weapon(weapon: ItemWeapon) -> void:
	self.data = weapon
	# 设置武器最大攻击范围
	collision.shape.radius = weapon.stats.max_range

##  是否可以攻击	
func can_use_weapon() -> bool:
	return cooldown_timer.is_stopped() and clossest_target

func use_weapon() -> void:
	calculate_spread()
	weapon_behavior.execute_attack()
	cooldown_timer.wait_time = data.stats.cooldown
	cooldown_timer.start()
	
## 计算一个命中率，如果未命中需要做一个弹道偏离
func calculate_spread() -> void:
	const MAX_SPREAD_RADIAN = deg_to_rad(10.0) # 假设最大误差是 10 度
	var inaccuracy_factor = 1.0 - data.stats.accuracy # 精度越高，这个因子越接近 0
	# 计算当前的误差幅度
	var current_max_spread = MAX_SPREAD_RADIAN * inaccuracy_factor
	# 重新计算 weapon_spread
	weapon_spread = randf_range(-current_max_spread, current_max_spread)
	rotation += weapon_spread
	
## 旋转指向目标
func rotate_to_target(delta: float) -> void:
	var target_rotation: float = rotation
	if is_attacking:
		target_rotation = get_custom_rotation_to_target()
	else:
		target_rotation = get_rotation_to_target()
		
	# 做一个平滑过渡的旋转 平滑过渡旋转会导致武器还没有指向敌人就启动攻击了
	#rotation = lerp_angle(rotation, target_rotation, 10 * delta)
	rotation = target_rotation

## 旋转指向目标
func get_custom_rotation_to_target() -> float:
	if not clossest_target or not is_instance_valid(clossest_target):
		return rotation
	# 获取武器位置到目标位置的夹角
	var rot := global_position.direction_to(clossest_target.global_position).angle()
	return rot + weapon_spread

func get_rotation_to_target() -> float:
	if targets.is_empty():
		return get_idle_rotation()
	return get_custom_rotation_to_target()
	
## 获取空闲时旋转的位置
func get_idle_rotation() -> float:
	if Globat.player.is_facing_right():
		return 0
	else: 
		return PI
		
## 更新武器的旋转
func update_visuals() -> void:
	# 1. 规范化旋转角度到 [-PI, PI] (即 [-180度, 180度]) 范围内
	var wrapped_rotation: float = wrapf(rotation, -PI, PI)
	# 2. 根据规范化后的角度判断朝向
	# 检查角度的绝对值是否大于 90 度 (PI / 2)
	# 如果 wrapped_rotation 位于 [-PI, -PI/2] U [PI/2, PI] 范围内，则朝左
	if abs(wrapped_rotation) > PI / 2:
		# 旋转到左边（后半圈）
		sprite.scale.y = -0.5
	else:
		# 旋转到右边（前半圈）
		sprite.scale.y = 0.5	
	
## 更新最近的敌人
func update_closest_target() -> void:
	clossest_target = get_closest_target()
	
## 锁定最近的敌人
func get_closest_target() -> Node2D:
	if targets.is_empty():
		return
	
	# 1. 初始化最近变量
	var nearest_enemy: Node2D
	# 使用一个足够大的初始值来保证第一次比较能成功
	var min_distance_sq: float = INF # Godot 提供的常量，表示无限大
	
	for enemy in targets:
		# 确保敌人对象有效，防止引用到已释放的节点
		if not is_instance_valid(enemy):
			continue
		#在计算距离时，我们通常使用 distance_squared_to() 而不是 distance_to()，因为前者可以避免昂贵的开方运算（sqrt()），同时不影响比较结果的正确性，从而提高性能。
		#获取当前武器到敌人中间的距离
		var current_distance = global_position.distance_squared_to(enemy.global_position)
		
		#设置最近敌人的信息
		if current_distance < min_distance_sq:
			nearest_enemy = enemy
			min_distance_sq = current_distance
	# 4. 返回找到的最近敌人（如果数组为空则返回 null）
	return nearest_enemy
	
## 感知敌人进入攻击范围
func _on_range_area_area_entered(area: Area2D) -> void:
	targets.push_back(area)

## 感知敌人离开攻击范围
func _on_range_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
	if targets.size() == 0:
		clossest_target = null
