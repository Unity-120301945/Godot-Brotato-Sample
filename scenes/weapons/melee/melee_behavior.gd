extends WeaponBehavior

## 近战武器行为
class_name MeleeBehavior

@export var hitbox: HitboxComponent

func execute_attack() -> void:
	weapon.is_attacking = true
	
	var tween := create_tween()
	
	var recoil_pos = Vector2(weapon.atk_start_pos.x - weapon.data.stats.recoil, weapon.atk_start_pos.y)
	
	tween.tween_property(weapon.sprite, "position", recoil_pos, weapon.data.stats.recoil_duration)
	
	hitbox.enable()
	hitbox.setup(get_damage(), critical, weapon.data.stats.knockback,weapon.data.stats.accuracy, weapon.get_parent())
	
	#tween.tween_callback(func():
		#weapon.is_attacking = false
		#hitbox.disable()
		#critical = false
	#)
	
	var attack_pos := Vector2(weapon.atk_start_pos.x + weapon.data.stats.max_range, weapon.atk_start_pos.y)
	
	tween.tween_property(weapon.sprite, "position", attack_pos, weapon.data.stats.attack_duration)
	
	tween.tween_property(weapon.sprite, "position", weapon.atk_start_pos, weapon.data.stats.back_duration)
	
	tween.finished.connect(func():
		weapon.is_attacking = false
		hitbox.disable()
		critical = false
	)
	
