extends Area2D

## 伤害检测组件
class_name HitboxComponent

signal on_hit_hurtbox(hurtbox: HurtboxComponent)

@onready var timer: Timer = $Timer

var damage := 1.0 ## 伤害值
var critical := false ## 是否暴击
var knockback_power := 0.0 ## 击退力度
var source: Node2D ## 来源
var target_hurtbox: HurtboxComponent  ## 存储当前的受击目标
var is_DOT := true ## 是否是持续攻击
var accuracy := 1.0 ## 命中率

func enable() -> void:
	set_deferred("monitoring",true)
	set_deferred("monitorable",true)
	
func disable() -> void:
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)

func setup(dam: float, cri: bool, knockback: float, accuracy: float, s: Node2D) -> void:
	self.damage = dam
	self.critical = cri
	self.knockback_power = knockback
	self.accuracy = accuracy
	self.source = s

## 封装发送信号的逻辑
func _emit_hit_signal() -> void:
	if is_instance_valid(target_hurtbox):
		# 1. 发送信号给外部监听者
		on_hit_hurtbox.emit(target_hurtbox)
		target_hurtbox.task_damage(self)
		# 2. 启动定时器，等待下一次触发
		if timer.is_stopped() and is_DOT:
			timer.start()
		#print(str(Time.get_unix_time_from_system()) + " -> 周期性伤害信号发送！")
	else:
		# 如果目标无效，停止计时器并清理
		timer.stop()
		target_hurtbox = null
		
func _on_area_entered(area: Area2D) -> void:
	# 1. 碰撞检测，只处理 HurtboxComponent
	if area is HurtboxComponent:
		# 检查是否重复进入
		if target_hurtbox == area:
			return
		if target_hurtbox != area:
			target_hurtbox = area
		#print("_on_area_entered")
		# 2. [关键] 立即发送第一次信号
		_emit_hit_signal()
		
func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent:
		# 如果离开的是当前目标
		if target_hurtbox == area:
			# 停止定时器，不再发送信号
			timer.stop()
			target_hurtbox = null
			#print("_on_area_exited")

func _on_timer_timeout() -> void:
	# 当定时器到时间时，再次发送信号
	# 因为 timer.one_shot = false，定时器会继续运行
	_emit_hit_signal()
