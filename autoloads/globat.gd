extends Node

signal on_create_block_text(node: Node2D)
signal on_create_damage_text(node: Node2D,hitbox: HitboxComponent)

#受到伤害特效
const FLASH_MATERIAL = preload("uid://caabuwwobhcf2")
#受到伤害显示特效
const FLOATING_TEXT = preload("uid://cvun2awgrbo4")

var player: Player

#判断是否格挡成功
func get_chance_success(chance:float) -> bool:
	var random := randf_range(0,1.0)
	if random < chance:
		return true
	return false
