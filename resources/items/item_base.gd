extends Resource

## 物品基础属性
class_name ItemBase

#物品类型
enum ItemType{
	WEAPON,## 武器
	UPGRADE,## 升级
	PASSIVE,## 被动	
}

@export var item_name: String ## 物品名称
@export var item_icon: Texture2D ## 物品图片
@export var item_tier: Globat.UpgradeTier ## 物品等级
@export var item_type: ItemType ## 物品类型
@export var item_cost: int ## 物品价值

## 物品描述
func get_description() -> String:
	return ""
