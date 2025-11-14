extends Resource

## 工具类通用资源
class_name UnitStats

## 工具类型，玩家、敌人
enum UnitType{
	PLAYER,
	ENEMY
}

## 玩家或者敌人默认属性
@export var name :String 
@export var type :UnitType
@export var icon :Texture2D
@export var health := 1 ## 血量
@export var health_increase_per_wave := 1.0 ## 每波血量最大增长
@export var damage := 1.0 ## 伤害值
@export var damage_increase_per_wave := 1.0 ## 每波伤害增长
@export var speed := 300 ## 移动速度
@export var luck := 1.0 ## 幸运
@export var block_chance := 0.0 ## 伤害格挡几率
@export var gold_drop := 1.0 ## 金币额外掉落几率
@export var dash_speed_multi := 4.0 ## 冲刺速度
@export var dash_coold_down:float  = 3.0 ## 冲刺冷却时间
@export var dash_duration:float = 0.5 ## 持续时间
@export var can_dash:bool = false ## 是否有冲刺能力
@export var can_dash_trail: bool = false ## 冲刺有光带特效
@export var can_dash_ghost: bool = false ## 冲刺有鬼影特效
@export var bullet_number := 1 ## 子弹发射数量
@export var bullet_coold_down :float  = 3.0 ## 子弹发射冷却时间
@export var bullet_speed := 1.0 ## 子弹发射速度
@export var can_ranged_attack:bool = false ## 是否有远程攻击能力
@export var alert_range := 60.0 ## 敌人警戒范围
