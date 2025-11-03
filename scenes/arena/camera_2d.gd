extends Camera2D
class_name Camera

func _process(delta: float) -> void:
	if is_instance_valid(Globat.player):
		global_position = Globat.player.global_position
