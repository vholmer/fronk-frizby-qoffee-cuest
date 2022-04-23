extends Node2D

func _ready():
	$ExtraCheese.stream = load("res://sfx/extra_cheese_dark.wav")
	$ExtraCheese.play()
