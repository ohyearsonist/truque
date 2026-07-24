extends Node2D

signal turn_ready

@export var HAND_SIZE = 3
@export var CARD_WIDTH = 250
@export var DISTANCE_FROM_TOP = 150
const CARD_SCENE_PATH = "res://scenes/Card.tscn"
var center_screen_x
var deck_reference

var partner_hand = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	deck_reference = $"../Deck"
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_SIZE):
		var card_data = deck_reference.generate_random_card()
		var new_card = card_scene.instantiate()
		$"../Board".add_child(new_card)
		new_card.name = card_data.name
		new_card.player = self
		new_card.get_node("CardImage").texture = load(card_data.imagePath)
		add_card_to_hand(new_card)

func play_card(card):
	partner_hand.erase(card)
	card.get_node("CoverImage").visible = false
	animate_card_to_position(card, $"../CardSlot".position)
	
	var rotationTween = get_tree().create_tween()
	rotationTween.tween_property(card, "rotation", randi() % 360, 0.1)
	
	update_hand_positions()

func add_card_to_hand(card):
	if card not in partner_hand:
		partner_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)

func remove_card_from_hand(card):
	if card in partner_hand:
		partner_hand.erase(card)
		update_hand_positions()

func update_hand_positions():
	for i in range(partner_hand.size()):
		var new_position = Vector2(calculate_card_position(i), DISTANCE_FROM_TOP)
		var card = partner_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	var hand_visual_size = (partner_hand.size() - 1) * CARD_WIDTH
	return center_screen_x + (index * CARD_WIDTH) - (hand_visual_size / 2)

func animate_card_to_position(card, position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", position, 0.12)

func _on_turn() -> void:
	play_card(partner_hand.pick_random())
	print("Partner played")
	emit_signal("turn_ready")
