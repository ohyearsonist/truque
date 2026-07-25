const CARDS = {
	"JH": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=Jack.png",
		"isSpecial": false,
		"isHigh": false
	},
	"QH": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=Queen.png",
		"isSpecial": false,
		"isHigh": false
	},
	"KH": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=King.png",
		"isSpecial": false,
		"isHigh": false
	},
	"2H": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=2.png",
		"isSpecial": false,
		"isHigh": false
	},
	"3H": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=3.png",
		"isSpecial": false,
		"isHigh": false
	},
	"AH": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=Ace.png",
		"isSpecial": false,
		"isHigh": false
	},
	"JC": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=Jack.png",
		"isSpecial": false,
		"isHigh": false
	},
	"QC": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=Queen.png",
		"isSpecial": false,
		"isHigh": false
	},
	"KC": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=King.png",
		"isSpecial": false,
		"isHigh": false
	},
	"2C": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=2.png",
		"isSpecial": false,
		"isHigh": false
	},
	"3C": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=3.png",
		"isSpecial": false,
		"isHigh": false
	},
	"AC": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=Ace.png",
		"isSpecial": false,
		"isHigh": false
	},
	"JD": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=Jack.png",
		"isSpecial": false,
		"isHigh": false
	},
	"QD": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=Queen.png",
		"isSpecial": false,
		"isHigh": false
	},
	"KD": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=King.png",
		"isSpecial": false,
		"isHigh": false
	},
	"2D": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=2.png",
		"isSpecial": false,
		"isHigh": false
	},
	"3D": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=3.png",
		"isSpecial": false,
		"isHigh": false
	},
	"AD": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=Ace.png",
		"isSpecial": false,
		"isHigh": false
	},
	"JS": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=Jack.png",
		"isSpecial": false,
		"isHigh": false
	},
	"QS": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=Queen.png",
		"isSpecial": false,
		"isHigh": false
	},
	"KS": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=King.png",
		"isSpecial": false,
		"isHigh": false
	},
	"2S": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=2.png",
		"isSpecial": false,
		"isHigh": false
	},
	"3S": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=3.png",
		"isSpecial": false,
		"isHigh": false
	},
	"AS": {
		"imagePath": "res://assets/cards/Suit=Spades, Number=Ace.png",
		"isSpecial": false,
		"isHigh": true
	},
	"7H": {
		"imagePath": "res://assets/cards/Suit=Hearts, Number=7.png",
		"isSpecial": false,
		"isHigh": true
	},
	"7D": {
		"imagePath": "res://assets/cards/Suit=Diamonds, Number=7.png",
		"isSpecial": false,
		"isHigh": true
	},
	"4C": {
		"imagePath": "res://assets/cards/Suit=Clubs, Number=4.png",
		"isSpecial": false,
		"isHigh": true
	},
	"JO": {
		"imagePath": "res://assets/cards/Suit=Other, Number=Joker.png",
		"isSpecial": false,
		"isHigh": true
	},

	"XRay": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Polymorph": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Backstab": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Switcher": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Pocket": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Big Hand": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Gimme": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Signal": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	},
	"Reset": {
		"imagePath": "res://assets/cards/card_empty.png",
		"isSpecial": true,
		"isHigh": false
	}
}

const CARD_ORDER = [
	"Backstab",

	"JC", "JH", "JD", "JS",
	"QC", "QH", "QD", "QS",
	"KC", "KH", "KD", "KS",
	"AC", "AH", "AD",
	"2C", "2H", "2D", "2S",
	"3C", "3H", "3D", "3S",

	"XRay", "Polymorph", "Switcher",
	"Pocket", "Big Hand", "Gimme",
	"Signal", "Reset",

	"JO", "7D", "AS", "7H", "4C"
]

const SPECIAL_CARD_LIST = [
	"Signal", "Reset", "Backstab",
	"XRay", "Polymorph", "Switcher",
	"Pocket", "Big Hand", "Gimme"
]