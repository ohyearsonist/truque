extends Node2D

var CARD_CONFIGS
var remaining_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CARD_CONFIGS = preload("res://config/cards.gd")
	shuffleDeck()

func generate_random_card():
	var card = remaining_deck.pick_random()
	remaining_deck.erase(card)
	var return_dict = CARD_CONFIGS.CARDS[card].duplicate(true)
	return_dict["name"] = card
	return return_dict

func shuffleDeck():
	remaining_deck = []
	for card in CARD_CONFIGS.CARDS:
		remaining_deck.push_front(card)
	remaining_deck.shuffle()