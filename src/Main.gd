extends Node

signal game_over
signal game_completed
signal main_dialogue_finished

signal teleport(to_area, to_x, to_y, flip_h)

var areas = {
	"beginning": load("res://src/area/areas/Beginning.tscn"),
	"fountain": load("res://src/area/areas/Fountain.tscn"),
	"fronkland1": load("res://src/area/areas/Fronkland1.tscn"),
	"fronkland2": load("res://src/area/areas/Fronkland2.tscn"),
	"fronkland3": load("res://src/area/areas/Fronkland3.tscn"),
	"fronkland4": load("res://src/area/areas/Fronkland4.tscn"),
	"carnival": load("res://src/area/areas/Carnival.tscn"),
	"palace": load("res://src/area/areas/Palace.tscn")
}

var defeated_enemies

var current_area

var just_teleported

func _ready():
	defeated_enemies = []
	just_teleported = false
	start_game()

func start_game():
	var title = load("res://src/title/Title.tscn").instance()
	add_child(title)

	yield(title, "title_done")
	title.queue_free()

	var intro = [
		["standard", "LEGENDS FORETELL OF A MORTAL THAT WILL SUCCUMB TO TEMPTATION"],
		["standard", "AND FALL VICTIM TO A TRAP PLACED BY AN ANCIENT EVIL."],
		["standard", "OVERPOWERED BY HIS EXTREME LOVE FOR COFFEE, HE WILL CONSUME"],
		["standard", "EVERYTHING IN HIS PATH AND RECREATE REALITY IN ITS DARK,"],
		["standard", "BITTER, IMAGE. THE HEAVENS WILL INTERVENE TO PUT A STOP"],
		["standard", "TO THE SCALDING HOT SCOURGE THAT WILL BE RELEASED UPON THE EARTH."],
		["standard", "A DEMIGOD WILL DESCEND TO QUELL HIS EVIL AMBITIONS AND RESTORE"],
		["standard", "BALANCE TO A WORLD THAT WAS ONCE PEACEFUL. HE WILL FAIL."],
		["standard", "ALL WILL BE IN VAIN."]
	]
	$Music.stream = load("res://music/legend.mp3")
	$Music.play()
	$Music.set_volume_db(-10)
	show_dialogue(intro)
	yield(self, "main_dialogue_finished")

	current_area = areas["beginning"].instance()
	add_child(current_area)

func _on_Game_Over():
	get_tree().change_scene("res://src/game-over/GameOver.tscn")

func _on_Teleport(to_area, to_x, to_y, flip_h):
#	$DarknessTween.interpolate_property(current_area.get_node("Background"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$DarknessTween.connect("tween_completed", self, "_Black", [to_area, to_x, to_y, flip_h])
#	$DarknessTween.start()
	var new_area = areas[to_area].instance()
	current_area.queue_free()
	call_deferred("add_child", new_area)
	new_area.move_player(to_x, to_y, flip_h)
	current_area = new_area
	just_teleported = true
	
func _on_GameCompleted():
	get_tree().change_scene("res://src/title/TheEnd.tscn")

func fountain_cutscene():
	$Music.stop()
	var new_area = areas["carnival"].instance()
	current_area.queue_free()
	
	var fountain_cutscene = load("res://src/cutscenes/Fountain.tscn").instance()
	add_child(fountain_cutscene)
	
	yield(fountain_cutscene, "fountain_cutscene_done")
	
	var to_x = 114
	var to_y = 118
	var flip_h = false
	
	call_deferred("add_child", new_area)
	new_area.move_player(to_x, to_y, flip_h)
	current_area = new_area
	
func show_dialogue(lines=[["standard", "Test"]]):
	var player = get_tree().get_root().find_node("Player", true, false)
	
	if player != null:
		player.can_move = false
		player.in_dialogue = true
	
	var dialogue_node = load("res://src/dialogue/Dialogue.tscn").instance()
	dialogue_node._init(lines)
	add_child(dialogue_node)
	yield(dialogue_node, "dialogue_finished")
	emit_signal("main_dialogue_finished")
	
	player = get_tree().get_root().find_node("Player", true, false)
	
	if player != null:
		player.can_move = true
		player.in_dialogue = false

func _Black(object, key, to_area, to_x, to_y, flip_h):
	var new_area = areas[to_area].instance()
	current_area.queue_free()
	call_deferred("add_child", new_area)
	new_area.move_player(to_x, to_y, flip_h)
	current_area = new_area
	current_area.get_node("Background").modulate = Color(1, 1, 1, 1)
	
	$BrightnessTween.interpolate_property(current_area.get_node("Background"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$BrightnessTween.start()
