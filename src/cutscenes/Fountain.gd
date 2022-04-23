extends Node2D

signal fountain_cutscene_done

var light_timer
var darkness_timer
var time_one_way

func _ready():
	time_one_way = 3
	
	$Splash.modulate.a = 0
	
	darkness_timer = Timer.new()
	darkness_timer.one_shot = true
	darkness_timer.wait_time = time_one_way
	darkness_timer.connect("timeout", self, "_on_Darkness_timeout")
	add_child(darkness_timer)
	
	light_timer = Timer.new()
	light_timer.one_shot = true
	light_timer.wait_time = time_one_way
	light_timer.connect("timeout", self, "_on_Light_timeout")
	add_child(light_timer)
	
	darkness_timer.start()
	
	$Tween.interpolate_property($Splash, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_one_way, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Darkness_timeout():
	$"/root/Main".show_dialogue([
		["fronk", "There's SOMETHING about the dark, purple smoke that is billowing"],
		["fronk", "from its surface and forming into clouds shaped like human skulls"],
		["fronk", "that is giving me an evil vibe."],
		["fronk", "I'd better not risk it..."],
		["fronk", "Ooooh, but I could REALLY go for some coffee right now."],
		["fronk", "Eh, what the heck. *GULP*"],
		["fountain", "Yesss... YES!! At last... a worthy vessel!"],
		["fountain", "Foolish child, you have no idea of the terror you have unleashed"],
		["fountain", "upon this world."],
		["fronk", "Vessel? Terror? World? What on earth are you yapping about?"],
		["fronk", "Of all the talking cups of coffee I've drunk from, you have to be"],
		["fronk", "the strangest. Anyway I've gotta go bake some bread or"],
		["fronk", "something. Fare well! Adios!"]
	])
	yield($"/root/Main", "main_dialogue_finished")
	light_timer.start()

func _on_Light_timeout():
	$Tween.interpolate_property($Splash, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), time_one_way, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("fountain_cutscene_done")
