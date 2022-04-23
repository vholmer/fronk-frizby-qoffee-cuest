extends Node2D

var health
var damage_scale

var dialogue
var death_dialogue
var wait_time
var start_in_action
var enemy_name
var org_music
var music

# Actions contains a list of 'action arrays' which contain this:
# Name,
# Flavor text,
# Function pointer to call after flavor text,
# True if progress to next dialogue after action & then reprompt
var actions

func _ready():
	health = 999
	
	position.x = 126
	position.y = 49

	org_music = $"/root/Main/Music".stream
