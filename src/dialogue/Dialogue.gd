extends CanvasLayer

signal dialogue_finished

# Props
var lines
var screen_size
var text_font
var char_idx
var line_idx
var text_speed
var print_timer = Timer.new()
var text_sfx
var pitch_low
var pitch_high

var init_pos

# Bools
var moving
var line_waiting
var closing

# Constants
var SCREEN_HEIGHT = 140
var DIALOGUE_MOVE_SPEED = 140

var sfx_dict = {
	# Array contains:
	# sfx, pitch_low, pitch_high, speed
	"standard": [load("res://sfx/standard.mp3"), 1, 1, 0.05],
	"tutorialo": [load("res://sfx/tutorialo.wav"), 0.3, 0.6, 0.05],
	"boscagglio": [load("res://sfx/clown.wav"), 0.9, 1.4, 0],
	"fronk": [load("res://sfx/fronk.wav"), 0.7, 1.0, 0.05],
	"fountain": [load("res://sfx/fountain.wav"), 0.3, 1.1, 0],
	"milburt": [load("res://sfx/milburt.mp3"), 0.9, 1.1, 0.05],
	"fronkasc": [load("res://sfx/fronk-ascended.mp3"), 0.9, 1.4, 0.05]
}

func _init(
	arr = [
		["standard", "Test hehe I'm testing the dialogue system!"],
		["standard", "Here's another separate line of text!"]
	],
	speed = 0.05,
	sfx = "res://sfx/standard.mp3",
	pitch_l = 0.7,
	pitch_h = 1.3
):
	lines = arr
	text_speed = speed
	
	text_sfx = sfx
	
	pitch_low = pitch_l
	pitch_high = pitch_h

func _ready():
	var init_pos = $Texture.rect_position
	
	moving = true
	
	print_timer.wait_time = text_speed
	print_timer.connect("timeout", self, "_on_PrintTimer")
	add_child(print_timer)
	
	char_idx = 0
	line_idx = 0
	$Texture/Text.text = ""
	
	text_font = $Texture/Text.get_font("normal_font")
	text_font.size = 16
	text_font.use_filter = false
	text_font.use_mipmaps = false
	
	$Texture/Arrow.visible = false
	
	$Click.stream = load(text_sfx)
	
	var player = get_tree().get_root().find_node("Player", true, false)
	self.connect("dialogue_finished", player, "_on_Dialogue_finished")
	
func goto_next_line():
	if line_idx == len(lines) - 1:
		closing = true
		return
	
	line_waiting = false
	$Texture/Arrow.visible = false
	$Texture/Text.text = ""
	line_idx += 1
	char_idx = 0
	print_timer.start()
	
func _on_PrintTimer():
	var sfx_dict_entry = sfx_dict[lines[line_idx][0]]
	var sfx = sfx_dict_entry[0]
	var pitch_low = sfx_dict_entry[1]
	var pitch_high = sfx_dict_entry[2]
	var speed = sfx_dict_entry[3]
	
	if $Click.stream != sfx:
		$Click.stream = sfx
	
	if char_idx < len(lines[line_idx][1]):
		if lines[line_idx][1][char_idx] != " ":
			$Click.pitch_scale = rand_range(pitch_low, pitch_high)
			if not $Click.playing or ($Click.playing and $Click.get_playback_position() / $Click.stream.get_length() > 0.7):
				$Click.play()
		$Texture/Text.text += lines[line_idx][1][char_idx]
		char_idx += 1
		print_timer.start()
	elif line_idx <= len(lines) - 1:
		line_waiting = true
		$Texture/Arrow.visible = true

func _process(delta):
	var speed = DIALOGUE_MOVE_SPEED * delta
	
	if closing:
		if $Texture.rect_position.y < SCREEN_HEIGHT:
			$Texture.rect_position.y += speed
		else:
			# I think we can inject which signal to emit in _init() from rooms that spawn dialogue objects.
			emit_signal("dialogue_finished")
			queue_free()
		return
	
	if moving:
		if $Texture.rect_position.y > SCREEN_HEIGHT - 34:
			$Texture.rect_position.y -= speed
		else:
			moving = false
			print_timer.start()
	elif line_waiting and Input.is_action_just_pressed("ui_accept"):
		goto_next_line()
	elif Input.is_action_just_pressed("ui_accept"):
		print_timer.stop()
		char_idx = len(lines[line_idx][1]) - 1
		$Texture/Text.text = lines[line_idx][1]
		$Texture/Arrow.visible = true
		line_waiting = true
