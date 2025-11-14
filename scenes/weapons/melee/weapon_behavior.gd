extends Node2D

## 武器行为基类
class_name WeaponBehavior

## 当前武器
@export var weapon: Weapon

## 是否暴击
var critical := false

## 执行攻击
func execute_attack() -> void:
	pass
	
## 获取单次造成伤害数值
func get_damage() -> float:
	# 基础伤害 = 武器伤害 + 人物伤害
	var damage = weapon.data.stats.damage + Globat.player.stats.damage
	# 获取武器暴击率
	var crit_chance := weapon.data.stats.crit_chance
	# 计算是否暴击了
	if Globat.get_chance_success(crit_chance):
		critical = true
		# 暴击成功后，伤害计算要 乘以 暴击伤害率 向上取整一次
		damage = ceilf(damage * weapon.data.stats.crit_damage)
	return damage
