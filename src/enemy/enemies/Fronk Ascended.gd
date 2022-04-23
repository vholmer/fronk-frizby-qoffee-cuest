extends "res://src/enemy/Enemy.gd"

func _ready():
	$Sprite.texture = load("res://gfx/characters/combat/fronk-ascended-1.png")
	
	music = load("res://music/dark-fronk-2.mp3")
	
	if $"/root/Main/Music".stream != music:
		$"/root/Main/Music".stream = music
		$"/root/Main/Music".play()
		$"/root/Main/Music".set_volume_db(-10)

	enemy_name = "Fronk Ascended"

	health = 70

	wait_time = $"..".sfx_dict["fronkasc"][3]
	start_in_action = false

	# Every dialogue line must start with sound identifier (see sfx_dict in Combat.gd)
	dialogue = [
		[
			["standard", "FRONK ASCENDED APPROACHES YOU WITH EARTH-TREMBLING STEPS."],
			["fronkasc", "Take a good, look at me Fronk."],
			["fronkasc", "I am your caffeine addiction made flesh."],
		],
		[
			["fronkasc", "To defeat me is to defeat your DEPENDENCE."],
			["fronkasc", "And we both know..."],
			["fronkasc", "...that's NEVER going to happen."],
			["fronk", "..."]
		],
		[
			["fronkasc", "The deep fragrance of a fresh brew."],
			["fronkasc", "The frothy foam of a cappucino."],
			["fronkasc", "A freshly pressed cup of bean juice!"]
		],
		[
			["fronkasc", "Come, Fronk! Have a cup! Have two!"],
			["fronkasc", "After all, I've made them just for you!"]
		],
		[
			["fronkasc", "The lands of espresso."],
			["fronkasc", "The Gardens of Frappucino."],
			["fronk", "HNnNnNnggg..."]
		],
		[
			["fronkasc", "Can captains cruise carribean coves..."],
			["fronkasc", "...ceasing complete coffee consumption?"]
		],
		[
			["fronkasc", "Fronk, my dear! It is futile! Give in!"],
			["fronkasc", "Have a sip from my chalice!"],
			["fronkasc", "I offer it not in malice."]
		],
		[
			["fronkasc", "Us ORBIGODS must not give in to mortal temptations. But..."],
			["fronkasc", "*SIP* ...ah, this drink...it is glorious."],
			["fronk", "I willsn't consume it, I refuse!"]
		],
		[
			["fronkasc", "FRONK ASCENDED sips his sizzling cup."]
		],
		[
			["fronkasc", "Consider the darkest of roasts!"],
			["fronkasc", "Ponder the depths of a macchiato lungo"],
			["fronkasc", "trenti iced coffee with skinny mocha,"],
			["fronkasc", "a dash of soy, ice, double-blended!"]
		],
		[
			["fronkasc", "Relish replenishing roasts..."],
			["fronkasc", "Return rampant response!"]
		],
		[
			["fronkasc", "Fighting futilely for fallacies!"],
			["fronkasc", "Fronk...find fate's Frappé!"]
		],
		[
			["standard", "FRONK ASCENDED flexes his humongous ABS."]
		]
	]
	
	# Unused right now, but should be what Boscagglio says upon death
	death_dialogue = [
		["fronkasc", "Come ooon! Just have a sip."],
		["fronkasc", "It's the best d*ng joe you'll ever taste."],
		["fronkasc", "Scout's honor!"],
		["fronk", "Mnngh... can'tst... resist... urge... to drink... *sip*"],
		["fronk", "Hee, you know what? This is actually really good!"],
		["fronk", "I'm totally on board now!"],
		["fronk", "Friendship... laughter... love..."],
		["fronk", "All of these things fade in comparison to"],
		["fronk", "the perfect, disgusting taste of the hot sewage we call coffee."],
		["fronk", "This is truly the GOOD ENDING I have been yearning for ever since"],
		["fronk", "I was a little Fronkoflorp."],
		["fronk", "You have truly shown me the way. Thank you! I love you!"],
		["fronkasc", "... Fronk... that is literal sewage."],
		["fronkasc", "...here, let me TRANSMOGRIFY it for y-"],
		["fronk", "One man's sewage, another man's joe! WOO! *GULP*"],
		["fronkasc", "Dear God, what have I done..."],
	]
	
	actions = [
		# Sound identifier
		# Name,
		# Flavor text,
		# Function pointer to call after flavor / perhaps signal to emit and then yield for attack done signal,
		["standard", "Strike", "You strike FRONK ASCENDED!", funcref($"..", "strike")],
		["standard", "Pray", "You fall to your knees and clasp your hands in prayer.", null],
		["standard", "Regret", "You feel remorse for your actions. F.A. laughs.", null],
		["standard", "Fetal Position", "You rock back and forth, crying.", null]
	]
	
	assert(len(actions) == 4)
