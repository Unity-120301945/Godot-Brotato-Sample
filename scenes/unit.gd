extends Node2D
class_name Unit

# 这是玩家和怪物的基础属性工具类
@export var stats: UnitStats

@onready var visuals: Node2D = %Visuals
@onready var sprite: Sprite2D = %Sprite
@onready var ani_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	#初始化生命状态
	health_component.setup(stats)

# 受到攻击信号
func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	if health_component.current_health <= 0:
		return
	var isBlocked = Globat.get_chance_success(stats.block_chance / 100)
	if isBlocked:
		print("格挡成功 -> %s" % [stats.block_chance  / 100])
		Globat.on_create_block_text.emit(self)
		return
	#触发伤害
	health_component.take_damage(hitbox.damage)
	Globat.on_create_damage_text.emit(self,hitbox)

# 受到伤害信号
func _on_health_component_on_unit_hit() -> void:
	pass
