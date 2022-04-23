extends KinematicBody2D

signal dialogue_spawned
signal dialogue_finished

signal combat_spawned
signal combat_finished

var screen_size
var speed
var collision

var can_move
var in_dialogue
var seen_fountain_dialogue

var TILE_SIZE = 28

func _ready():
	seen_fountain_dialogue = false
	screen_size = get_viewport_rect().size
	speed = TILE_SIZE * 2.5 # Move TILE_SIZE * x per second
	can_move = true
	self.set_name("Player")

func _on_Dialogue_spawned():
	can_move = false
	in_dialogue = true
	
func _on_Dialogue_finished():
	can_move = true
	in_dialogue = false
	
	if collision != null:
		var col = collision.collider
		if "enemy_name" in col and col.enemy_name != null:
			col.spawn_combat(col.kill_after_combat)
	
func _on_Combat_spawned():
	can_move = false
	in_dialogue = true
	
func _on_Combat_finished():
	can_move = true
	in_dialogue = false

func _process(delta):
	var velocity = Vector2.ZERO
	
	if can_move:
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			$Sprite.flip_h = false
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			$Sprite.flip_h = true
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("quit"):
			get_tree().quit()
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed

		collision = move_and_collide(velocity * delta)
		
		if collision != null:
			var col = collision.collider
			
			if Input.is_action_just_pressed("ui_accept"):
				if col.has_method("spawn_dialog") and not in_dialogue:
					col.spawn_dialog()
				elif col.get_parent().name == "Fountain":
					if not seen_fountain_dialogue:
						seen_fountain_dialogue = true
						var dialogue_node = load("res://src/dialogue/Dialogue.tscn").instance()
						# TODO: Add fountain & fronk voice clip
						dialogue_node._init([
							["fountain", "Fronk..."],
							["fronk", "Whuzzat? Didst somebody beckon minsth name?"],
							["fountain", "Fronk... lean closer..."],
							["fronk", "Why, slap my knees and call me a pig."],
							["fronk", "A cup of coffee! Clear as day!"],
							["fronk", "Mine prayers have been answered! Joy!"],
							["fountain", "Take a sip... of darkness..."],
							["fronk", "Upon closer inspection... This cup is mighty ominous..."]
						])
						add_child(dialogue_node)
						can_move = false
						in_dialogue = true
						yield(dialogue_node, "dialogue_finished")
						$"/root/Main".fountain_cutscene()
						queue_free()
		
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
