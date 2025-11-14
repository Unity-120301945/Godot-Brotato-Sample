extends Node2D
class_name Unit

# 这是玩家和怪物的基础属性工具类
@export var stats: UnitStats

@onready var visuals: Node2D = %Visuals
@onready var sprite: Sprite2D = %Sprite
@onready var ani_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	#初始化生命状态
	health_component.setup(stats)

## 受伤害效果
func set_flash_material() -> void:
	sprite.material = Globat.FLASH_MATERIAL
	#if flash_timer.is_stopped():
	flash_timer.start()

func on_accuracy(accuracy: float) -> bool:
	var isAccuracy = Globat.get_accuracy_success(accuracy)
	if not isAccuracy:
		Globat.on_create_not_accuracy_text.emit(self)
	return isAccuracy
			
## 击退
func apply_knockback(knock_dir: Vector2, knock_power: float) -> void:
	pass
	
# 受到攻击信号
func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	if health_component.current_health <= 0:
		return
	if not on_accuracy(hitbox.accuracy):
		return
	var isBlocked = Globat.get_chance_success(stats.block_chance / 100)
	if isBlocked:
		#print("格挡成功 -> %s" % [stats.block_chance  / 100])
		Globat.on_create_block_text.emit(self)
		return
	#触发伤害
	health_component.take_damage(hitbox.damage)
	Globat.on_create_damage_text.emit(self,hitbox)
	if stats.type == stats.UnitType.ENEMY:
		if hitbox.knockback_power > 0 :
			var dir := hitbox.source.global_position.direction_to(global_position)
			apply_knockback(dir,hitbox.knockback_power)

# 受到伤害信号
func _on_health_component_on_unit_hit() -> void:
	set_flash_material()

##  受到伤害时改变玩家材质倒计时
func _on_flash_timer_timeout() -> void:
	sprite.material = null
