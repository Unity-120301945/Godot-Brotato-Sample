extends Resource

## 武器属性
class_name WeaponStats

@export var damage := 1.0 ## 伤害
@export_range(0.0, 1.0) var accuracy := 0.9 ## 命中率
@export_range(0.3, 30) var cooldown := 1.0 ## 冷却时间
@export_range(0.0, 1.0) var crit_chance := 0.05 ## 暴击率
@export var crit_damage := 1.5 ## 暴击伤害倍率
@export var max_range := 150.0 ## 最大攻击范围
@export var knockback := 0.0 ## 击退距离
@export_range(0.0, 1.0) var lift_steal := 0.0 ## 生命偷取
@export var recoil := 25.0 ## 武器后座力距离
@export_range(0.1, 3.0) var recoil_duration := 0.1 ## 武器后座力距离的时间
@export_range(0.1, 3.0) var attack_duration := 0.2 ## 攻击到达最大攻击范围的时间
@export_range(0.1, 3.0) var back_duration := 0.15 ## 武器返回起始位置的时间
@export var projectile_scene: PackedScene ## 子弹场景
@export var projectile_speed := 1600.0 ## 子弹速度
