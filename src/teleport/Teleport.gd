extends Node2D

signal teleport(to_area, to_x, to_y, flip_h)

export(String) var to_area
export(float) var to_x
export(float) var to_y
export(bool) var flip_h

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_Body_entered")
	self.connect("teleport", $"/root/Main", "_on_Teleport")

func _on_Body_entered(body):
	emit_signal("teleport", to_area, to_x, to_y, flip_h)
