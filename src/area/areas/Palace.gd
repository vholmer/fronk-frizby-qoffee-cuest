extends "res://src/area/Area.gd"

func _ready():
	music = load("res://music/dark-fronk-1.mp3")
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".set_volume_db(-10)
		$"/root/Main/Music".play()

func _process(delta):
	var ratio = $"/root/Main/Music".get_playback_position() / $"/root/Main/Music".stream.get_length()
	if ratio > 0.999:
		music = load("res://music/dark-fronk-2.mp3")
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".set_volume_db(-10)
		$"/root/Main/Music".play()
