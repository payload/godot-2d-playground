extends KinematicBody2D

enum State { IDLE, WALK, PUNCHING }

export var speed = 60
export var state = State.IDLE

func _ready():
	set_physics_process(true)
	assert(!$Area2D.connect("area_shape_entered", self, "item_entered"))

func _unhandled_key_input(event: InputEventKey):
	if not event.pressed: return
	match event.scancode:
		KEY_F3:
			debug_cycle_animation()

func _physics_process(_delta):
	match state:
		State.IDLE:
			if trigger_punching(): enter_punching()
			elif trigger_walk(): enter_walk()
		State.WALK:
			if trigger_punching(): enter_punching()
			elif not trigger_walk(): enter_idle()
		State.PUNCHING:
			if trigger_punshed():
				if trigger_punching(): enter_punching()
				elif trigger_walk(): enter_walk()
				else: enter_idle()
	match state:
		State.IDLE: pass
		State.WALK: handle_walk()
		State.PUNCHING: pass
		
###

func enter_idle():
	state = State.IDLE
	$AnimationPlayer.play("idle")

###

func trigger_punching():
	return Input.is_key_pressed(KEY_SPACE)

func trigger_punshed():
	return not $AnimationPlayer.is_playing()

func enter_punching():
	state = State.PUNCHING
	$AnimationPlayer.play("punch")

###

func trigger_walk():
	for key in [KEY_W, KEY_A, KEY_S, KEY_D]:
		if Input.is_key_pressed(key):
			return true

func enter_walk():
	state = State.WALK
	$AnimationPlayer.play("walk")

func handle_walk():
	var input_dir : Vector2 = get_movement_input()
	move_on_input(input_dir)
	look_in_walk_direction(input_dir)

###

func item_entered(_area_id: int, area: Area2D, area_shape: int, _self_shape: int):
	var trans = Physics2DServer.area_get_shape_transform(area.get_rid(), area_shape)
	var tilemap = area.get_node("Items") as TileMap
	var offset = 2 * tilemap.cell_size if tilemap.centered_textures else Vector2.ZERO
	var orig = trans.xform(offset)
	var pos = tilemap.world_to_map(orig)
	if tilemap.get_cellv(pos) > -1:
		tilemap.set_cellv(pos, -1)

func get_movement_input() -> Vector2:
	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	return input_dir.normalized()

func move_on_input(input_dir: Vector2):
	var vel = input_dir * speed
	var _movement = move_and_slide(vel)

func look_in_walk_direction(input_dir: Vector2):
	if input_dir.x < 0:
		$Sprite.flip_h = true
	elif input_dir.x > 0:
		$Sprite.flip_h = false

func debug_cycle_animation():
	var player = $AnimationPlayer
	var anims = Array(player.get_animation_list())
	var index = anims.find(player.assigned_animation)
	var next = (index + 1) % anims.size()
	player.play(anims[next])
