extends Spatial

func _ready():
	# Get the viewport and clear it
	var viewport = get_node("Viewport")
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	# Let two frames pass to make sure the vieport's is captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the texture and set it to the viewport quad
	$MeshInstance.material_override.albedo_texture = viewport.get_texture()

func _process(delta):
	var dir := Vector3.ZERO
	if Input.is_key_pressed(KEY_W): dir += Vector3.FORWARD
	if Input.is_key_pressed(KEY_S): dir += Vector3.BACK
	if Input.is_key_pressed(KEY_A): dir += Vector3.LEFT
	if Input.is_key_pressed(KEY_D): dir += Vector3.RIGHT
	dir = dir.normalized()
	var vel := dir * 3
	$KinematicBody.move_and_slide(vel)
