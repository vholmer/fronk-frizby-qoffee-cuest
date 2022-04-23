extends "res://src/actor/Actor.gd"

func _ready():
	enemy_name = "Boscagglio"
	
	free_if_killed()
	
	dialogue = [
		["boscagglio", "*HONK* *HONK* WELCOME TO THE CARNIVAL, FRONK!"]
	]
