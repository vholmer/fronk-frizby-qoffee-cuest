extends "res://src/area/Area.gd"

func _ready():
	music = load("res://music/fronkland.mp3")
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)
