extends Control

var cardsToLoop = []
var images = {
	"3X": [
		"res://assets/cards/Suit=Clubs, Number=3.png",
		"res://assets/cards/Suit=Diamonds, Number=3.png",
		"res://assets/cards/Suit=Hearts, Number=3.png",
		"res://assets/cards/Suit=Spades, Number=3.png"
	],
	"2X": [
		"res://assets/cards/Suit=Clubs, Number=2.png",
		"res://assets/cards/Suit=Diamonds, Number=2.png",
		"res://assets/cards/Suit=Hearts, Number=2.png",
		"res://assets/cards/Suit=Spades, Number=2.png"
	],
	"AX": [
		"res://assets/cards/Suit=Clubs, Number=Ace.png",
		"res://assets/cards/Suit=Diamonds, Number=Ace.png",
		"res://assets/cards/Suit=Hearts, Number=Ace.png",
		"res://assets/cards/Suit=Diamonds, Number=Ace.png"
	],
	"KX": [
		"res://assets/cards/Suit=Clubs, Number=King.png",
		"res://assets/cards/Suit=Diamonds, Number=King.png",
		"res://assets/cards/Suit=Hearts, Number=King.png",
		"res://assets/cards/Suit=Spades, Number=King.png"
	],
	"QX": [
		"res://assets/cards/Suit=Clubs, Number=Queen.png",
		"res://assets/cards/Suit=Diamonds, Number=Queen.png",
		"res://assets/cards/Suit=Hearts, Number=Queen.png",
		"res://assets/cards/Suit=Spades, Number=Queen.png"
	],
	"JX": [
		"res://assets/cards/Suit=Clubs, Number=Jack.png",
		"res://assets/cards/Suit=Diamonds, Number=Jack.png",
		"res://assets/cards/Suit=Hearts, Number=Jack.png",
		"res://assets/cards/Suit=Spades, Number=Jack.png"
	]
}

var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer2/3X")
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer2/2X")
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer2/AX")
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer3/KX")
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer3/QX")
	cardsToLoop.append($"./VBoxContainer/VBoxContainer/HBoxContainer3/JX")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout():
	if counter == 4:
		counter = 0

	for card in cardsToLoop:
		card.texture = load(images[card.name][counter])

	counter += 1	