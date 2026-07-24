class_name Player extends Node2D

#region Configuration
var HAND_SIZE = 3
var CARD_WIDTH = 250
var DISTANCE_FROM_EDGE
var EDGE # bottom (default) | top | left | right
var IS_PLAYER

const CARD_SCENE_PATH = "res://scenes/Card.tscn"
#endregion

#region Declarations
var center_screen_x
var center_screen_y
var deck_reference

var hand = []

signal turn_ready
#endregion

#region Methods
# Constructor
func _init(dist=150, edge="bottom", isPlayer=false) -> void:
	DISTANCE_FROM_EDGE = dist
	EDGE = edge
	IS_PLAYER = isPlayer

func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	center_screen_y = get_viewport_rect().size.y / 2
	deck_reference = $"../Deck"

	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_SIZE):
		var card_data = deck_reference.generate_random_card()

		var new_card = card_scene.instantiate()
		$"../Board".add_child(new_card)

		new_card.name = card_data.name
		new_card.player = self
		new_card.get_node("CardImage").texture = load(card_data.imagePath)

		if IS_PLAYER:
			new_card.get_node("CoverImage").visible = false
			new_card.is_draggable = true

		if EDGE == "left":
			new_card.rotation = PI/2
		elif EDGE == "right":
			new_card.rotation = -(PI/2)

		add_card_to_hand(new_card)
	
	ready()

func ready() -> void:
	pass # To be overwritten

#region Hand management
func add_card_to_hand(card):
	if card not in hand:
		hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)

func remove_card_from_hand(card):
	if card in hand:
		hand.erase(card)
		update_hand_positions()
#endregion

func play_card(card):
	remove_card_from_hand(card)
	card.get_node("CoverImage").visible = false
	animate_card_to_position(card, $"../CardSlot".position)
	
	var rotationTween = get_tree().create_tween()
	rotationTween.tween_property(card, "rotation", randi() % 360, 0.1)
	
#region Position
func update_hand_positions():
	for i in range(hand.size()):
		var new_position

		if self.EDGE == "bottom":
			new_position = Vector2(calculate_card_position(i), get_viewport_rect().size.y - DISTANCE_FROM_EDGE)
		elif self.EDGE == "top":
			new_position = Vector2(calculate_card_position(i), DISTANCE_FROM_EDGE)
		elif self.EDGE == "right":
			new_position = Vector2(get_viewport_rect().size.x - DISTANCE_FROM_EDGE, calculate_card_position(i))
		elif self.EDGE == "left":
			new_position = Vector2(DISTANCE_FROM_EDGE, calculate_card_position(i))

		var card = hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)

func calculate_card_position(index):
	if self.EDGE == "top" or self.EDGE == "bottom":
		var hand_visual_size = (hand.size() - 1) * CARD_WIDTH
		return center_screen_x + (index * CARD_WIDTH) - (hand_visual_size / 2.)
	else:
		var hand_visual_size = (hand.size() - 1) * CARD_WIDTH
		return center_screen_y + (index * CARD_WIDTH) - (hand_visual_size / 2.)

func animate_card_to_position(card, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", pos, 0.12)
#endregion

func _on_turn() -> void:
	if not IS_PLAYER:
		play_card(hand.pick_random())
		emit_signal("turn_ready")
	else:
		for card in hand:
			card.get_node("CoverImage").visible = false
			card.is_draggable = true
#endregion