extends Line2D
class_name Trail

#这是冲刺功能的光带特效，实现方式是冲刺时一直添加玩家当前的位置，最终由这些坐标连城一条线

@onready var trail_timer: Timer = %TrailTimer

@export var player :Player
@export var trail_length := 15 #光带长度
@export var trail_duration := 0.8 #光带特效持续时间

var points_array: Array[Vector2] = [] #存储玩家位置的数组
var is_active := false #是否存在
	
func _process(_delta: float) -> void:
	if not is_active:
		return
	
	points_array.append(player.global_position) #保存玩家当前位置
	
	if points_array.size() > trail_length: 
		points_array.pop_front() #如果超过了最大长度就删除最初保存的位置
	
	points = points_array
	
func start_trail() -> void:
	is_active = true
	clear_points() #清除保存的所有标记点
	points_array.clear() 
	trail_timer.start(trail_duration)

func _on_trail_timer_timeout() -> void:
	is_active = false
	clear_points()
	points_array.clear()
