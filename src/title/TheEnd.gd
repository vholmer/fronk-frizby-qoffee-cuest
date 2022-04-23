extends Node2D

func _ready():
	var music = load("res://music/end.mp3")
	$Music.stream = music
	$Music.play()
	$Music.set_volume_db(-10)
