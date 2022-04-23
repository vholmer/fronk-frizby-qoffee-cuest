extends "res://src/enemy/Enemy.gd"

func _ready():
	$Sprite.texture = load("res://gfx/characters/combat/tutorialo.png")

	enemy_name = "THE GREAT TUTORIALO"

	health = 1

	wait_time = $"..".sfx_dict["tutorialo"][3]
	start_in_action = false

	dialogue = [
		[
			["tutorialo", "Welcome, rookie, to what we call... COMBAT!"],
			["fronk", "Co.. com... coffee??!+???!+3 Do you know where I can find some?!"],
			["tutorialo", "Er.. No, what I meant was..-"],
			["fronk", "Read my lips, old man: If it ain't brown, get outta town!"],
			["tutorialo", "Listen, Fronk. In order to efficiently destroy the enemy,"],
			["tutorialo", "you must learn how to fight. Heed my advice!"],
			["tutorialo", "See that big heart to the left? That's your HEALTH."],
			["fronk", "...my hooflth?"],
			["tutorialo", "...uh, sure. If it goes to zero, you DIE."],
			["tutorialo", "Now, I won't fight you, so don't worry, it won't decrease."],
			["tutorialo", "But if this was a real fight I'd have put your maggot ass"],
			["tutorialo", "straight into the god damn ground before you even had the chance to"],
			["tutorialo", "play with that stupid propeller on your ha- HEY! Are you listening?!"],
			["fronk", "Look, Mr. Tutorengo. May I call you Tutorialo?"],
			["tutorialo", "..."],
			["fronk", "I'm no soldier, I don't have a single fighting body in my bones!"],
			["tutorialo", "Worry not, child. Navigate your options with the ARROW KEYS."],
			["tutorialo", "Select an option with Z."],
			["tutorialo", "Go ahead, select any option, except for 'Strike'."],
			["fountain", "FRONK... STRIKE... STRIKE HIM DOWN..."]
		],
		[
			["tutorialo", "Once more... select any option, except for 'Strike'."]
		]
	]
	
	death_dialogue = [
		["tutorialo", "AArrrARRRrrghgghhhllllfm..."],
		["fronk", "Mister Tutogorgo... I'm sorry... I-... I don't even know where the bat came from..."],
		["tutorialo", "I-it's OK my boy... go forth... remember what I taught you..."],
		["tutorialo", "A-always... stretch... after.. a meal... grgRGLFlfll..."]
	]

	actions = [
		# Sound identifier
		# Name,
		# Flavor text,
		# Function pointer to call after flavor / perhaps signal to emit and then yield for attack done signal,
		["standard", "Strike", "You hit THE GREAT TUTORIALO in the face with a baseball bat. Jesus Christ! Calm down, man...", funcref($"..", "strike")],
		["tutorialo", "Salute", "Atta boy!", null],
		["standard", "Escape", "You attempt escape, but THE GREAT TUTORIALO catches you.", null],
		["standard", "Smoke cigar", "You smoke a cigar with the Sergeant. Very reluctantly.", null],
	]
	
	assert(len(actions) == 4)
