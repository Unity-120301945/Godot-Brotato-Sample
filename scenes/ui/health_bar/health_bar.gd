extends Control

#生命条
class_name HealthBar

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_amount: Label = $HealthAmount

@export var back_color: Color
@export var fill_color: Color

func _ready() -> void:
	#获取血量条的背景副本
	var back_style = progress_bar.get_theme_stylebox("background").duplicate()
	back_style.bg_color = back_color
	#获取血量条的颜色副本
	var fill_style = progress_bar.get_theme_stylebox("fill").duplicate()
	fill_style.bg_color = fill_color
	
	#设置配置好的进度条样式
	progress_bar.add_theme_stylebox_override("background",back_style)
	progress_bar.add_theme_stylebox_override("fill",fill_style)
	
#更新进度条
func update_bar(value: float,health: float) -> void:
	progress_bar.value = value
	health_amount.text = str(health)

#生命值变化信号
func _on_health_component_on_health_changed(cur_health: float, max_health: float) -> void:
	var value = cur_health / max_health
	update_bar(value,cur_health)
