extends Node2D
#悬浮伤害数值特效
class_name  FloatingText

@onready var value_label: Label = $ValueLabel

func setup(value: String, color: Color, is_critical: bool = false) -> void:
	value_label.text = value
	modulate = color
	scale = Vector2.ZERO
	
	#设置一个-10~10角度变化的旋转
	rotation = deg_to_rad(randf_range(-10,10))
	
	#设置一个随机的缩放
	var random_scale := randf_range(0.8,1.6) if not is_critical else 2.0
	
	#初始化动画组件
	var tween = create_tween()
	
	#设置缩放动画，应用在x和y轴（random_scale * Vector2.ONE），时间400
	#parallel()：让下一个 Tweener 与上一个并行执行
	tween.parallel().tween_property(self, "scale", random_scale * Vector2.ONE, 0.4)
	#设置节点的位置
	tween.parallel().tween_property(self, "global_position", global_position + Vector2.UP * 15, 0.4)
	
	#上面动画完成后做一个延迟
	tween.tween_interval(0.5)
	
	#缩小隐藏
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	
	#等待动画执行完毕释放节点
	await  tween.finished
	queue_free()
	
