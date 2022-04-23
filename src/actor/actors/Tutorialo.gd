extends "res://src/actor/Actor.gd"

func _ready():
	enemy_name = "THE GREAT TUTORIALO"
	
	free_if_killed()
	
	kill_after_combat = true
	
	dialogue = [
		["tutorialo", "Greetings! Welcome, to the Forest (tm)!"],
		["tutorialo", "I'm THE GREAT TUTORIALO! And before I let you pass..."],
		["tutorialo", "I gotta put you through, uh, a... a tutorial!"],
		["tutorialo", "For the forest is a place of GREAT DANGER."]
	]
