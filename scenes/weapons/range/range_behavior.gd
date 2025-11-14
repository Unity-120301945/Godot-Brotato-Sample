extends WeaponBehavior

## 远程武器行为
class_name RangeBehavior

@onready var muzzle: Marker2D = %Muzzle

## 执行攻击
func execute_attack() -> void:
	weapon.is_attacking = true
	
	create_projectile()
	
	var tween := create_tween()
	
	var recoil_pos = Vector2(weapon.atk_start_pos.x - weapon.data.stats.recoil, weapon.atk_start_pos.y)
	tween.tween_property(weapon.sprite, "position", recoil_pos, weapon.data.stats.recoil_duration)
	tween.tween_property(weapon.sprite, "position", weapon.atk_start_pos, weapon.data.stats.back_duration)
	
	await tween.finished
	weapon.is_attacking = false
	critical = false

func create_projectile() -> void:
	var instance := weapon.data.stats.projectile_scene.instantiate() as Projectile
	get_tree().root.add_child(instance)
	instance.global_position = muzzle.global_position

	var velocity := Vector2.RIGHT.rotated(weapon.rotation) * weapon.data.stats.projectile_speed
	
	instance.set_projectile(velocity,get_damage(),critical,weapon.data.stats.knockback,weapon.data.stats.accuracy,weapon.get_parent())
	
	
	
