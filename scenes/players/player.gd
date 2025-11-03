extends Unit
class_name Player

@onready var dash_timer: Timer = $DashTimer
@onready var dash_coold_down_timer: Timer = $DashCooldDownTimer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trail: Trail = $Visuals/Trail
@onready var flash_timer: Timer = $FlashTimer

var is_dashing:bool = false # 是否在冲刺中
var dash_available:bool = true # 冲刺

var move_dir:Vector2

func _ready() -> void:
	super._ready()
	# 初始化冲刺计时器
	if stats.can_dash:
		dash_timer.wait_time = stats.dash_duration
		dash_coold_down_timer.wait_time = stats.dash_coold_down
	
func _process(delta: float) -> void:
	move_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	var current_velocity = move_dir * stats.speed
	
	if is_dashing:
		current_velocity *= stats.dash_speed_multi
	
	position += current_velocity * delta
	position.x = clamp(position.x,-1000,1000)
	position.y = clamp(position.y,-470,500)
	
	if can_dash():
		start_dash()
	
	update_animations()

# 更新玩家行为动画
func update_animations() -> void:
	if move_dir == Vector2.ZERO :
		ani_player.play("idle")
	else:
		ani_player.play("move")
		update_rotation()

# 更新玩家移动时左右朝向
func update_rotation() -> void:
	if move_dir == Vector2.ZERO :
		return
	if(move_dir.x != 0):
		visuals.scale.x = -0.5 if move_dir.x > 0 else 0.5
		
# 开始冲刺
func start_dash() -> void:
	is_dashing = true
	trail.start_trail()
	dash_timer.start()
	visuals.modulate.a = 0.5 #冲刺时玩家透明度修改
	collision.set_deferred("disabled",true) #冲刺结束玩家关闭碰撞
	
# 是否可以冲刺
func can_dash() -> bool:
	# 是否冲刺中 and 冲刺冷却定时器处于停止状态 and 玩家处于移动中 and 按下冲刺按钮
	return not is_dashing and\
	dash_coold_down_timer.is_stopped() and\
	move_dir != Vector2.ZERO and\
	Input.is_action_just_pressed("dash") and\
	stats.can_dash

func set_flash_material() -> void:
	sprite.material = Globat.FLASH_MATERIAL
	#if flash_timer.is_stopped():
	flash_timer.start()
		
# 冲刺计时器结束信号
func _on_dash_timer_timeout() -> void:
	dash_coold_down_timer.start() # 启动冲刺冷却定时器
	move_dir = Vector2.ZERO
	collision.set_deferred("disabled",false) #冲刺结束玩家开启碰撞
	is_dashing = false
	visuals.modulate.a = 1.0 #冲刺结束玩家透明度重置

# 受到伤害时改变玩家材质倒计时
func _on_flash_timer_timeout() -> void:
	sprite.material = null

# 受伤信号
func _on_health_component_on_unit_hit() -> void:
	super._on_health_component_on_unit_hit()
	set_flash_material()
