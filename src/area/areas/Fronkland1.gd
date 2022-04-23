extends "res://src/area/Area.gd"

func _ready():
	music = load("res://music/fronkland.mp3")
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)

# TODO: This will show every time the room is entered for some reason...
#	var dialogue = [
#		["standard", "Waits'th a minoot! QOOFFEE?!"],
#		["standard", "Thine ground isT CQoffeEE!!!"]
#	]
	
# $"/root/Main".show_dialogue(dialogue, true)
