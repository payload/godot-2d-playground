extends Node2D

onready var player = $Player
onready var wallsFloor = $TileMapWallsFloor
onready var overlay = $TileMapOverlay
onready var darkness = $TileMapDarkness

func _ready():
	var screen = OS.get_screen_size()
	var window = screen * 0.8
	OS.set_window_size(window)
	OS.set_window_position(screen*0.5 - window*0.5)

func _input(event):
	if !event.is_pressed():
		return

	if Input.is_action_just_pressed("player_left"):
		move_player(-1, 0)
	if Input.is_action_just_pressed("player_right"):
		move_player(1, 0)
	if Input.is_action_just_pressed("player_up"):
		move_player(0, -1)
	if Input.is_action_just_pressed("player_down"):
		move_player(0, 1)

func move_player(x, y):
	if x < 0: player.flip_h = true
	if x > 0: player.flip_h = false
	
	var v = Vector2(x * 16, y * 16)
	var worldPos = player.transform.get_origin() + v
	var mapPos = wallsFloor.world_to_map(worldPos)
	var tileIndex = wallsFloor.get_cellv(mapPos)
	var overlayTileIndex = overlay.get_cellv(mapPos)
	
	var name = wallsFloor.tile_set.tile_get_name(tileIndex)

	var overlayName = overlay.tile_set.tile_get_name(overlayTileIndex)
	
	if tileIndex != 0:
		player.translate(v)
	
	update_darkness(mapPos, worldPos)

func update_darkness(mapPos, worldPos):
	var space = get_world_2d().direct_space_state
	
	$DebugLine.clear_points()
	$DebugLine2.clear_points()
	for x in range(100):
		for y in range(100):
			var dark = 8
			if mapPos.distance_squared_to(Vector2(x, y)) <= 25:
				var from = worldPos + Vector2(8, 8)
				var xDir = 1 if x < mapPos.x else -1
				var yDir = 1 if y < mapPos.y else -1
				var to = Vector2(8, 8) + darkness.map_to_world(Vector2(x, y)) + Vector2(xDir, yDir) * 8
				var occlusion = space.intersect_ray(from, to)
				$DebugLine.add_point(from)
				$DebugLine.add_point(to)
				if !occlusion || (occlusion.position - to).length() < 1:
					dark = -1
				else:
					$DebugLine2.add_point(to)
			darkness.set_cell(x, y, dark)
