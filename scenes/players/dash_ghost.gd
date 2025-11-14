extends Node2D

## 冲刺幻影特效
class_name DashGhost

@export var fade_time: float = 0.3 # 幻影渐隐持续时间
@export var start_alpha: float = 0.5 # 幻影开始时的透明度

const fade_curve = preload("uid://u4cr2dut0tms")

var _sprite: Sprite2D
var _current_time: float = 0.0

func _ready():
	_sprite = $Sprite2D
	# 初始化透明度
	_sprite.modulate.a = start_alpha
	# 设置 Process Mode 为物理帧，确保渐隐与物理世界同步（如果需要）
	set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	
func update_rotation(data: Vector2) -> void:
	if data == Vector2.ZERO :
		return
	if(data.x != 0):
		self.scale.x = -0.5 if data.x > 0 else 0.5
		
# 设置幻影的纹理和翻转状态
func setup_ghost(data: Vector2,texture: Texture2D) -> void:
	_sprite.texture = texture
	update_rotation(data)

func _physics_process(delta: float):
	_current_time += delta

	var progress = _current_time / fade_time
	if fade_curve:
		progress = fade_curve.sample(progress) # 使用曲线采样
	
	_sprite.modulate.a = lerp(start_alpha, 0.0, progress) # 线性插值渐隐

	if _current_time >= fade_time:
		queue_free() # 幻影消失，从场景中移除
