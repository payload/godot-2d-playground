extends StaticBody2D
tool

export onready var highlight : bool setget set_highlight

export var material_no_highlight : Material
export var material_highlight : Material

func set_highlight(h: bool):
	highlight = h
	$AnimatedSprite.material = material_highlight if highlight else material_no_highlight
