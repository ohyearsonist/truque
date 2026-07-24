extends Node2D

@export var HAND_SIZE = 3
@export var CARD_WIDTH = 250
@export var DISTANCE_FROM_THE_BOTTOM = 200
const CARD_SCENE_PATH = "res://scenes/Card.tscn"
var CARD_CONFIGS
var center_screen_x

var remaining_deck = []
var player_hand = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	
	CARD_CONFIGS = preload("res://config/cards.gd")
	for card in CARD_CONFIGS.CARDS:
		remaining_deck.push_front(card)
	
	remaining_deck.shuffle()
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_SIZE):
		var card_data = generate_random_card()
		var new_card = card_scene.instantiate()
		$"../Board".add_child(new_card)
		new_card.name = card_data.keys()[0]
		new_card.get_node("CardImage").texture = load(card_data.imagePath)
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

func generate_random_card():
	var card = remaining_deck.pick_random()
	remaining_deck.remove_at(remaining_deck.find(card))
	return CARD_CONFIGS.CARDS[card]

func update_hand_positions():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), get_viewport_rect().size.y - DISTANCE_FROM_THE_BOTTOM)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	var hand_visual_size = (player_hand.size() - 1) * CARD_WIDTH
	return center_screen_x + (index * CARD_WIDTH) - (hand_visual_size / 2)

func animate_card_to_position(card, position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", position, 0.1)
