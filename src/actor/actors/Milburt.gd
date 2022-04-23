extends "res://src/actor/Actor.gd"

func _ready():
	enemy_name = "Milburt"
	
	free_if_killed()
	
	kill_after_combat = true
	
	dialogue = [
		["milburt", "Hm? Oh, Fronk. It's you. Haven't seen you in a while."],
		["milburt", "You look... different, did you get a new hat or something?"],
		["fronk", "..."],
		["milburt", "Fronk?"],
		["fronk", "I grow stronger every second, Milburt."],
		["milburt", "...Riiiight."],
		["fronk", "I am tethered to humanity by the meresth'd thread."],
		["fronk", "That thread is you, Milburt. It has to be severed."],
		["fronk", "Or my true power will never blossom'sthd."],
		["milburt", "Fronk, please... You don't have to do this. We're friends!"],
		["milburt", "Remember high school? Remember the time I pushed you"],
		["milburt", "into the river and your eye got infected? We go way back!"],
		["milburt", "You can't do this to me, man! I have a wife, a kid, a dog..."],
		["milburt", "I own a house!"],
		["fronk", "Milburt... I am sorry."]
	]
