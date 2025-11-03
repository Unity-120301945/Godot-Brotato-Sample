extends Node

#生命值组件
class_name HealthComponent

signal on_unit_hit #伤害信号
signal on_unit_died #死亡信号
signal on_health_changed(cur_health: float,max_health: float) #生命状态变化信号

var max_health := 1.0 #最大生命值
var current_health := 1.0 #当前生命值

#设置生命状态
func setup(stats: UnitStats) -> void:
	max_health = stats.health
	current_health = max_health
	on_health_changed.emit(current_health,max_health)

#伤害改变当前生命状态	
func take_damage(value: float) -> void:
	if current_health <= 0:
		return
	current_health -= value
	current_health = max(current_health,0)
	#发送受伤信号
	on_unit_hit.emit()
	#发送生命变化信号
	on_health_changed.emit(current_health,max_health)
	print("名称 -> %s , 当前生命值 -> %s , 最大生命值 -> %s" % [owner.name,current_health,max_health])
	check_died()

#检查死亡状态
func check_died() -> void:
	if current_health > 0:
		return
	current_health = 0
	#发送死亡信号
	on_unit_died.emit()
	print("死亡")
	owner.queue_free()	

#治疗	
func heal(amount: float) -> void:
	if current_health <= 0:
		return
	current_health += amount
	current_health = min(current_health,max_health)
	on_health_changed.emit(current_health,max_health)
