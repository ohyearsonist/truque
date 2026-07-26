extends Node2D

signal deck_depleted
signal deck_shuffled

var CARD_CONFIGS
var remaining_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CARD_CONFIGS = preload("res://config/cards.gd")
	shuffleDeck()

func _process(_delta: float) -> void:
	if remaining_deck.size() < 3:
		emit_signal("deck_depleted")

func generate_random_card():
	var card = remaining_deck.pick_random()
	remaining_deck.erase(card)
	var return_dict = CARD_CONFIGS.CARDS[card].duplicate(true)
	return_dict["name"] = card
	return return_dict

func generate_specific_card(n):
	var card = n
	remaining_deck.erase(card)
	var return_dict = CARD_CONFIGS.CARDS[card].duplicate(true)
	return_dict["name"] = card
	return return_dict

func shuffleDeck():
	remaining_deck = []
	for card in CARD_CONFIGS.CARDS:
		remaining_deck.push_front(card)
	remaining_deck.shuffle()
	emit_signal("deck_shuffled")
