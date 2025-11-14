extends Node2D
class_name Arena

@export var player: Player
#伤害浮动文本的样式
@export var normal_color: Color #默认文本颜色
@export var block_color: Color #格挡成功文本颜色
@export var critical_color: Color #暴击了文本颜色
@export var hp_color: Color # 治疗文本颜色

func _ready() -> void:
	Globat.player = player
	#为什么对敌人或者玩家攻击的效果会放在竞技场里面，因为可以根据不同的竞技场配置不同的样式
	Globat.on_create_block_text.connect(_on_create_block_text)
	Globat.on_create_damage_text.connect(_on_create_damage_text)
	Globat.on_create_not_accuracy_text.connect(on_create_not_accuracy_text)

#创建一个悬浮文本节点用来显示被攻击的效果
#unit表示显示的节点附近，比如敌人或者玩家附近
func create_floating_text(unit: Node2D) -> FloatingText:
	var instance := Globat.FLOATING_TEXT.instantiate() as FloatingText
	get_tree().root.add_child(instance)
	#获取玩家 360 * 35 的范围随机一个位置
	var random_pos := randf_range(0,TAU) * 35
	#根据位置做一个正确的旋转
	var spawn_pos := unit.global_position + Vector2.RIGHT.rotated(random_pos)
	instance.global_position = spawn_pos
	return instance

#格挡成功
func _on_create_block_text(node: Node2D) -> void:
	var float_text := create_floating_text(node)
	float_text.setup("格挡!", block_color)
	
#造成伤害
func _on_create_damage_text(node: Node2D, hitbox: HitboxComponent) -> void:
	var float_text := create_floating_text(node)
	float_text.setup(str(hitbox.damage), normal_color if not hitbox.critical else critical_color, hitbox.critical)

func on_create_not_accuracy_text(node: Node2D) -> void:
	print("未命中!")
	var float_text := create_floating_text(node)
	float_text.setup("未命中!", block_color)
