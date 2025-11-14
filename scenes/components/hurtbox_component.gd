extends Area2D

#受伤检测组件
class_name HurtboxComponent
@onready var collision: CollisionShape2D = $CollisionShape2D

signal on_damaged(hitbox:HitboxComponent)

func task_damage(area: Area2D) -> void:
	if area is HitboxComponent:
		on_damaged.emit(area)

func setup_deferred(deferred: bool) -> void:
	collision.set_deferred("disabled",deferred)
	
