extends Node2D

func _physics_process(delta):
	var input_y = 0
	var input_x = 0
	if Input.is_key_pressed(KEY_W): input_y -= 1
	if Input.is_key_pressed(KEY_S): input_y += 1
	if Input.is_key_pressed(KEY_A): input_x -= 1
	if Input.is_key_pressed(KEY_D): input_x += 1

	var offset = Vector2(input_x, input_y) * 60	
	$KingPig.move_and_slide(offset)

func _on_Area2D_body_entered(body):
	if body == $KingPig:
		$Area2D/Polygon2D.color = Color.aliceblue
		$KingPig/Sprite.modulate = Color.blue if $KingPig/Sprite.modulate == Color.red else Color.red

func _on_Area2D_body_exited(body):
	if body == $KingPig:
		$Area2D/Polygon2D.color = Color.gray
