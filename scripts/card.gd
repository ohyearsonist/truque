extends Node2D

signal hovered
signal hovered_off

var is_draggable = false
var slot = null
var hand_position
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# OBS: WILL CRASH GAME IF CARD IS NOT CHILD OF BOARD
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	
func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
