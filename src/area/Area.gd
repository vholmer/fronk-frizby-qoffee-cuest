extends Node2D

signal teleport(to_area, to_x, to_y, flip_h)

var music

func move_player(to_x, to_y, flip_h):
	$Player.position.x = to_x
	$Player.position.y = to_y
	$Player/Sprite.flip_h = flip_h

func _ready():
	self.z_index = 100
