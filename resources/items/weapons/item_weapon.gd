extends ItemBase

## 武器
class_name ItemWeapon

enum WeaponType{
	MELEE,## 近战
	RANGE,## 远程
}


@export var type: WeaponType ## 武器类型
@export var scene: PackedScene ## 武器场景
@export var stats: WeaponStats ## 武器属性
@export var upgrade_to: ItemWeapon ## 下一挡位武器
