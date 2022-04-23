extends Node

signal dialogue_spawned
signal combat_spawned
signal kill
signal disappear

var dialogue
var enemy_name # If enemy_name is set, then combat will happen!
var kill_after_combat # If true the actor will be deleted after beaten in combat

func _ready():
	var player = $"../Player"
	kill_after_combat = false
	self.connect("dialogue_spawned", player, "_on_Dialogue_spawned")
	self.connect("combat_spawned", player, "_on_Combat_spawned")

func free_if_killed():
	var defeated_arr = $"/root/Main".defeated_enemies
	
	if defeated_arr.has(enemy_name):
		queue_free()

func spawn_dialog():
	if dialogue != null:
		var dialogue_node = load("res://src/dialogue/Dialogue.tscn").instance()
		dialogue_node._init(dialogue)
		add_child(dialogue_node)
		emit_signal("dialogue_spawned")

func spawn_combat(kill=false):
	var combat_node = load("res://src/combat/Combat.tscn").instance()
	combat_node.initialize(enemy_name, get_node(".") if kill else null)
	add_child(combat_node)
	emit_signal("combat_spawned")

func _on_Kill():
	var defeated_arr = $"/root/Main".defeated_enemies
	
	if not defeated_arr.has(enemy_name):
		defeated_arr.append(enemy_name)
	queue_free()

func _on_Disappear():
	$Sprite.visible = false
