extends Node2D

## 武器容器
class_name WeaponContainer

@onready var one: Node2D = $One
@onready var two: Node2D = $Two
@onready var three: Node2D = $Three
@onready var four: Node2D = $Four
@onready var five: Node2D = $Five
@onready var six: Node2D = $Six

## 更新每一个武器的位置
func update_weapon_position(weapons: Array[Weapon]) -> void:
	var count := weapons.size()
	var reference_node: Node2D
	
	match count:
		1: reference_node = one
		2: reference_node = two
		3: reference_node = three
		4: reference_node = four
		5: reference_node = five
		6: reference_node = six
		
	if reference_node == null:
		return
		
	var markers := reference_node.get_children()
	if markers.size() != count:
		return
	
	for i in count:
		weapons[i].global_position = markers[i].global_position
		
