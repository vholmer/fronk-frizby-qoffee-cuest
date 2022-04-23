extends "res://src/area/Area.gd"

signal fountain_cutscene

func _ready():
	music = load("res://music/forest.wav")
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)
