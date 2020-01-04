extends Node2D

func _ready():
	print('LayerZoomExperiment._ready')

func _unhandled_key_input(event: InputEventKey):
	match event.scancode:
		KEY_W:
			$AnimationPlayer.play("ZoomLayerAway")
		KEY_S:
			$AnimationPlayer.play_backwards("ZoomLayerAway")
