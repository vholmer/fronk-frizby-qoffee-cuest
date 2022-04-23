extends "res://src/enemy/Enemy.gd"

func _ready():
	$Sprite.texture = load("res://gfx/characters/combat/boscagglio.png")
	
	music = load("res://music/boscagglio.mp3")
	
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)

	enemy_name = "Boscagglio"

	health = 60

	wait_time = $"..".sfx_dict["boscagglio"][3]
	start_in_action = false

	# Every dialogue line must start with sound identifier (see sfx_dict in Combat.gd)
	dialogue = [
		[
			["standard", "Boscagglio Q. Lown draws near!"],
			["standard", "Diagnosis: multiple organ failure, radiation poisoning, tricycle overdose"],
			["standard", "and GFS (Ginormous Feet Syndrome)."]
		],
		[
			["boscagglio", "HEE HEE, HOO HOO, IT IS I, BOSCAGGLIO!"],
			["standard", "His arm passes through your chest and honks your heart like a horn."]
		],
		[
			["boscagglio", "I WAS SENT BY THE GODS TO PUT AN END TO YOUR QUEST"],
			["boscagglio", "I MAY LOOK A FOOL, BUT THIS IS HARDLY A JEST!"],
			["standard", "Boscagglio laughs hysterically while juggling chainsaws"],
			["standard", "on a unicycle on top of a rope between two poles mounted"],
			["standard", "on a giant turtle on top of an elephant."]
		],
		[
			["boscagglio", "YOU FLEW CLOSE TO THE SUN, THE DAMAGE IS DONE"],
			["boscagglio", "I WON'T LET YOU RUN, SO LET'S HAVE SOME FUN!"],
			["standard", "Boscagglio injects you with trombosis."]
		],
		[
			["boscagglio", "ZIPPITY DEE, ZIPPITY DOO"],
			["boscagglio", "BE VERY AFRAID, I'M COMING FOR YOU!"],
			["standard", "Boscagglio ties a balloon animal in the shape of your father's ghost."]
		],
		[
			["boscagglio", "THE ANCIENT DARK LIQUID WILL SHATTER YOUR SANITY"],
			["boscagglio", "LAY WASTE TO THIS EARTH AND UNLEASH CALAMITY!"],
			["standard", "Boscagglio stares into the distance with a vacant, empty smile."]
		],
		[
			["boscagglio", "THIS EVIL BROWN DRINK IS POSSESSING YOUR HEART"],
			["boscagglio", "IT WAS BREWED BY A DEMON MOST CUNNING AND SMART!"],
			["standard", "Boscagglio is humming a tune your mother used to sing for you as a child."]
		],
		[
			["boscagglio", "RING-A-DING-DING, I CAN DO ANYTHING! (tm)"],
			["standard", "Boscagglio puts a hose in his mouth, rapidly inflates himself"],
			["standard", "until he pops, and magically reappears behind you."]
		]
	]
	
	# Unused right now, but should be what Boscagglio says upon death
	death_dialogue = [
		["boscagglio", "WHAT HAVE YOU DONE, CAN IT REALLY BE TRUE?"],
		["boscagglio", "HAVE I BEEN DEFEATED, BY A MORTAL LIKE YOU?"],
		["standard", "Boscagglio is helplessly gasping for air."],
		["boscagglio", "THE COUNCIL WAS WRONG, THE COFFEE'S TOO STRONG!"],
		["boscagglio", "NOW THE BELLS TOLL FOR ME, BING BONG BING BONG!"],
		["standard", "Boscagglio explodes into a mushroom cloud of confetti."]
	]
	
	actions = [
		# Sound identifier
		# Name,
		# Flavor text,
		# Function pointer to call after flavor / perhaps signal to emit and then yield for attack done signal,
		["standard", "Strike", "You strike the 'clown'!", funcref($"..", "strike")],
		["standard", "Honk", "*HONK* *HONK*! The clown is not amused.", null],
		["standard", "Coffee", "You take a swig. Your ATTACK increases with -0 points.", null],
		["standard", "Vibrate", "You intimidate the clown by shaking in place rapidly.", null]
	]
	
	assert(len(actions) == 4)
