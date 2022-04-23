extends "res://src/enemy/Enemy.gd"

func _ready():
	$Sprite.texture = load("res://gfx/characters/combat/milburt.png")

	music = load("res://music/milburt.mp3")
	
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)

	enemy_name = "Milburt"

	health = 20

	wait_time = $"..".sfx_dict["milburt"][3]
	start_in_action = false

	# Every dialogue line must start with sound identifier (see sfx_dict in Combat.gd)
	dialogue = [
		[
			["milburt", "Fronk... please..."],
			["standard", "Milburt is trembling in fear."]
		]
	]
	
	death_dialogue = null
	
	actions = [
		# Sound identifier
		# Name,
		# Flavor text,
		# Function pointer to call after flavor / perhaps signal to emit and then yield for attack done signal,
		["standard", "ANNIHILATE", "Milburt will be destroyed.", funcref($"..", "strike")],
		["standard", "ANNIHILATE", "Milburt will be eliminated.", funcref($"..", "strike")],
		["standard", "ANNIHILATE", "Milburt will be vaporized.", funcref($"..", "strike")],
		["standard", "ANNIHILATE", "Milburt will be no longer.", funcref($"..", "strike")],
	]
	
	assert(len(actions) == 4)
