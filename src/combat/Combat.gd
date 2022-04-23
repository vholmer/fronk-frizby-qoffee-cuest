extends Node2D

signal combat_finished
signal kill
signal disappear
signal game_over
signal game_completed
signal teleport(to_area, to_x, to_y, flip_h)

var cur_choice
var cur_dialogue
var print_timer
var death_timer
var text_font
var char_idx
var line_idx
var line_waiting
var text_player
var is_phase_two

var in_action
var in_flavor
var in_attack
var in_end

var death_animate
var just_started
var death_timed_out

var lives
var life_sprites
var redraw_lives

var catt_lines

var arrow_pos
var arrow_points = [
	[50, 93],  # Option1
	[199, 93], # Option2
	[50, 133], # Option3
	[199, 133] # Option4
]

var sfx_dict = {
	# Array contains:
	# sfx, pitch_low, pitch_high, speed
	"standard": [load("res://sfx/standard.mp3"), 1, 1, 0.05],
	"tutorialo": [load("res://sfx/tutorialo.wav"), 0.3, 0.6, 0.05],
	"boscagglio": [load("res://sfx/clown.wav"), 0.9, 1.25, 0],
	"fronk": [load("res://sfx/fronk.wav"), 0.7, 1.0, 0.05],
	"fountain": [load("res://sfx/fountain.wav"), 0.3, 1.1, 0],
	"milburt": [load("res://sfx/milburt.mp3"), 0.9, 1.1, 0.05],
	"fronkasc": [load("res://sfx/fronk-ascended.mp3"), 0.9, 1.4, 0.05]
}

var attack_lines

var enemy_node

func initialize(enemy_name, spawning_node):
	just_started = true
	enemy_node = load("res://src/enemy/enemies/%s.tscn" % enemy_name).instance()
	add_child(enemy_node)
	
	if spawning_node != null:
		self.connect("kill", spawning_node, "_on_Kill")
		self.connect("disappear", spawning_node, "_on_Disappear")

func _ready():
	is_phase_two = false
	
	var life1 = load("res://gfx/combat/1life.png")
	var life2 = load("res://gfx/combat/2life.png")
	var life3 = load("res://gfx/combat/3life.png")
	var life4 = load("res://gfx/combat/4life.png")
	
	life_sprites = [life1, life2, life3, life4]
	
	self.set_global_position(Vector2(0, 0))
	$Dialogue.text = ""
	$Arrow.visible = false
	$Background.z_index = -1
	cur_choice = 0 # Default to option 1
	
	$Actions/Option1.bbcode_text = enemy_node.actions[0][1]
	$Actions/Option2.bbcode_text = "[right]" + enemy_node.actions[1][1] + "[/right]"
	$Actions/Option3.bbcode_text = enemy_node.actions[2][1]
	$Actions/Option4.bbcode_text = "[right]" + enemy_node.actions[3][1] + "[/right]"
	
	text_player = AudioStreamPlayer.new()
	add_child(text_player)

	var player = $"../../Player"
	self.connect("combat_finished", player, "_on_Combat_finished")
	
	var main = $"/root/Main"
	self.connect("game_over", main, "_on_Game_Over")
	self.connect("teleport", main, "_on_Teleport")
	self.connect("game_completed", main, "_on_GameCompleted")
	
	print_timer = Timer.new()
	print_timer.wait_time = sfx_dict["standard"][3]
	print_timer.connect("timeout", self, "_on_PrintTimer")
	add_child(print_timer)
	
	death_timer = Timer.new()
	death_timer.wait_time = 1
	death_timer.connect("timeout", self, "_on_DeathTimer")
	add_child(death_timer)
	
	in_action = enemy_node.start_in_action
	in_flavor = false
	in_attack = false
	in_end = false
	death_animate = false
	death_timed_out = false
	
	lives = 4
	redraw_lives = true
	
	char_idx = 0
	line_idx = 0
	
	cur_dialogue = 0

func _on_DeathTimer():
	death_timed_out = true

func _on_PrintTimer():
	var lines = get_lines()
	
	var sfx_dict_entry = sfx_dict[lines[line_idx][0]]
	var sfx = sfx_dict_entry[0]
	var pitch_low = sfx_dict_entry[1]
	var pitch_high = sfx_dict_entry[2]
	var speed = sfx_dict_entry[3]
	
	if text_player.stream != sfx:
		text_player.stream = sfx
	
	if char_idx < len(lines[line_idx][1]):
		if lines[line_idx][1][char_idx] != " ":
			text_player.pitch_scale = rand_range(pitch_low, pitch_high)
			if not text_player.playing or (text_player.playing and text_player.get_playback_position() / text_player.stream.get_length() > 0.7):
				text_player.play()
		$Dialogue.text += lines[line_idx][1][char_idx]
		char_idx += 1
		print_timer.start()
	else:
		line_waiting = true
		$Arrow.visible = true

func update_state(lines):
	var final_char = char_idx >= len(lines[line_idx][1]) - 1 and line_idx >= len(lines) - 1
	
	# If last flavor, transition to attack
	if in_flavor and final_char:
		in_flavor = false
		in_action = false
		in_attack = true
		line_waiting = false
		$Dialogue.text = ""
		char_idx = 0
		line_idx = 0
		$Arrow.visible = false
		if enemy_node.actions[cur_choice][3] != null:
			enemy_node.actions[cur_choice][3].call_func()
			counter_attack()
		print_timer.start()
		return true
	# If last attack, transition to dialogue
	elif in_attack and final_char:
		if enemy_node.health <= 0:
			in_end = true
			emit_signal("disappear")
		elif enemy_node.name == "Fronk Ascended" and enemy_node.health <= 50 and not is_phase_two:
			enemy_node.get_node("Sprite").texture = load("res://gfx/characters/combat/fronk-ascended-2.png")
			is_phase_two = true
		in_flavor = false
		in_action = false
		in_attack = false
		line_waiting = false
		$Dialogue.text = ""
		char_idx = 0
		line_idx = 0
		redraw_lives = true
		attack_lines = null
		catt_lines = null
		$Arrow.visible = false
		print_timer.start()
		return true
	# If last line of any other state, transition to action selection
	elif line_idx == len(lines) - 1:
		# Return to action choosing
		print_timer.stop()
		in_flavor = false
		in_action = true
		in_attack = false
		line_waiting = false
		line_idx = 0
		char_idx = 0
		$Arrow.visible = false
		if not in_flavor and cur_dialogue < len(enemy_node.dialogue) - 1:
			cur_dialogue += 1
		return true
		
	return false

func goto_next_line():
	var lines = get_lines()
	
	if update_state(lines):
		return
	
	line_waiting = false
	$Arrow.visible = false
	$Dialogue.text = ""
	line_idx += 1
	char_idx = 0
	print_timer.start()

func strike():
	var damage = 2 + randi() % 10
	
	# TODO: See if hit or not, based on enemy's dodge value
	enemy_node.health -= damage
	var enemy_health = enemy_node.health
	
	attack_lines = [
		["standard", enemy_node.enemy_name + " takes " + str(damage) + " damage!"],
		["standard", enemy_node.enemy_name + " has " + str("no" if enemy_health <= 0 else enemy_health) + " health left!"]
	]
	
	if enemy_node.name == "Fronk Ascended" and enemy_health <= 50 and not is_phase_two:
		attack_lines += [
			["fronkasc", "ENOUGH! I grow tired of this futile charade. It is time I unleash my full power."],
			["standard", "FRONK ASCENDED produces a cup and takes a big *GULP*."],
			["fronkasc", "...ah, come now, Fronk. Won't you have a sip?"]
		]

func counter_attack():
	if enemy_node.enemy_name == "Milburt":
		catt_lines = null
		return
	
	if enemy_node.health > 0:
		var percent_to_be_hit
		
		if lives == 4:
			percent_to_be_hit = 0.5
		elif lives == 3:
			percent_to_be_hit = 0.5
		elif lives == 2:
			percent_to_be_hit = 0.5
		else:
			percent_to_be_hit = 0.01
		
		var damage = 1 if randf() > 1 - percent_to_be_hit else 0
		
		catt_lines = [
			["standard", "You have " + ("luckily " if damage == 0 else "") + "taken " + (str(damage) if damage > 0 else "no") + " damage!"]
		]
		
		lives -= damage

func get_lines():
	var lines
	
	if in_end:
		if enemy_node.death_dialogue != null:
			lines = enemy_node.death_dialogue
			if enemy_node.name == "Fronk Ascended":
				lines += [["standard", "Your bloodstream turned into coffee!"]]
			else:
				lines += [["standard", "You have defeated " + enemy_node.enemy_name + "!"]]
		else:
			lines = [["standard", "You have defeated " + enemy_node.enemy_name + "!"]]
		return lines
	
	if not in_action and not in_flavor and not in_attack:
		lines = enemy_node.dialogue[cur_dialogue]
	elif in_attack:
		# If no attack lines, transition back to dialogue
		if attack_lines == null:
			in_attack = false
			lines = enemy_node.dialogue[cur_dialogue]
		else:
			lines = attack_lines
		if catt_lines != null and len(catt_lines) > 0:
			lines += catt_lines
	elif in_flavor:
		lines = [[enemy_node.actions[cur_choice][0], enemy_node.actions[cur_choice][2]]]
		
	return lines

func _process(delta):
	if redraw_lives:
		$Life.texture = life_sprites[lives - 1]
		redraw_lives = false
		
		if lives <= 0:
			emit_signal("game_over")
	
	if death_animate:
		$Arrow.visible = false
			
		if death_timed_out:
			if enemy_node.name == "Boscagglio":
				# teleport(to_area, to_x, to_y, flip_h)
				emit_signal("teleport", "fronkland1", 99, 52, true)
				$"/root/Main".show_dialogue([["fronk", "What'sdh the.. The ground... it's COFFEE!!=!="]])
				queue_free()
			elif enemy_node.name == "Fronk Ascended":
				emit_signal("game_completed")
			
			$".".modulate.a -= 2 * delta
			
			if $".".modulate.a <= 0:
				if $"/root/Main/Music".stream != enemy_node.org_music and enemy_node.org_music != null:
					$"/root/Main/Music".stream = enemy_node.org_music
					$"/root/Main/Music".play()
				emit_signal("combat_finished")
				emit_signal("kill")
				queue_free()
		return
		
	if in_end and line_waiting:
		var lines = get_lines()
		var final_char = char_idx >= len(lines[line_idx][1]) - 1 and line_idx >= len(lines) - 1
		if final_char:
			death_animate = true
			death_timer.start()
	
	if in_action:
		$Actions.visible = true
		$Dialogue.visible = false
		
		if Input.is_action_just_pressed("move_down"):
			if cur_choice != 2 and cur_choice != 3:
				cur_choice = (cur_choice + 2) % 4
		elif Input.is_action_just_pressed("move_up"):
			if cur_choice != 0 and cur_choice != 1:
				cur_choice = (cur_choice - 2) % 4
		elif Input.is_action_just_pressed("move_left"):
			if cur_choice != 0 and cur_choice != 2:
				cur_choice = (cur_choice - 1) % 4
		elif Input.is_action_just_pressed("move_right"):
			if cur_choice != 1 and cur_choice != 3:
				cur_choice = (cur_choice + 1) % 4
		elif line_waiting and Input.is_action_just_pressed("ui_accept"):
			in_action = false
			goto_next_line()
		elif Input.is_action_just_pressed("ui_accept"):
			in_action = false
			in_attack = false
			in_flavor = true
			char_idx = 0
			line_idx = 0
			$Dialogue.text = ""
			print_timer.start()
	else:
		$Actions.visible = false
		$Dialogue.visible = true
		
		if just_started:
			just_started = false
			print_timer.start()
		elif line_waiting and Input.is_action_just_pressed("ui_accept"):
			goto_next_line()
		elif Input.is_action_just_pressed("ui_accept"):
			print_timer.stop()
			
			var lines = get_lines()
				
			char_idx = len(lines[line_idx][1]) - 1
			$Dialogue.text = lines[line_idx][1]
			$Arrow.visible = true
			line_waiting = true
	
	$Actions/Choice.flip_v = cur_choice == 2 or cur_choice == 3
	
	arrow_pos = arrow_points[cur_choice]

	$Actions/Choice.position.x = arrow_pos[0]
	$Actions/Choice.position.y = arrow_pos[1]
