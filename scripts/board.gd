extends Node2D

#region Definition

@export var COLLISION_MASK_CARD : int
@export var COLLISION_MASK_CARD_SLOT : int
@export var FIRST_PLAYER : int


signal player_turn
signal partner_turn
signal right_turn
signal left_turn

signal round_over
signal player_raise_stakes
signal confirmation_signal

var currentStakes = 1

var confirmID = "Refuse"

var screen_size

var paused = false
var cardOrderShown = false

var cardConfigs
var card_being_dragged
var is_hovering_on_card
var deck

var players = {}
var current_player = FIRST_PLAYER

var winnerList = []
var currentRound = 0

var previousHands = []

var familyList = []

#endregion

#region Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	deck = $"../Deck"
	cardConfigs = preload("res://config/cards.gd")

	players.set("player", Player.new(150, "bottom", true))
	players.set("left", Player.new(150, "left", false))
	players.set("partner", Player.new(150, "top", false))
	players.set("right", Player.new(150, "right", false))

	for p in players:
		players[p].name = p
		$"..".add_child.call_deferred(players[p])
		connect_player_signals(players[p])
	
	self.call_deferred("_on_turn_ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !paused:
		if event.pressed:
			var card = raycast_check_for_card()
			if card and card.is_draggable:
				start_drag(card)
		else:
			finish_drag()
	
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

#region Drag
func start_drag(card):
	card_being_dragged = card
	if card_being_dragged.slot:
		card_being_dragged.slot.card_in_slot = false
		card_being_dragged.slot = null
	card_being_dragged.scale = Vector2(1, 1)
	card_being_dragged.rotation = 0

func finish_drag():
	if card_being_dragged:
		card_being_dragged.scale = Vector2(1.05, 1.05)
		
		var card_slot_found = raycast_check_for_card_slot()
		if card_slot_found: # and not card_slot_found.card_in_slot:
			players.player.remove_card_from_hand(card_being_dragged)
			card_slot_found.card_in_slot = true
			
			var positionTween = get_tree().create_tween()
			var rotationTween = get_tree().create_tween()
			positionTween.tween_property(card_being_dragged, "position", card_slot_found.position, 0.1)
			rotationTween.tween_property(card_being_dragged, "rotation", randi() % 360, 0.1)
			
			card_being_dragged.slot = card_slot_found
			card_being_dragged.is_draggable = false
			players.player.emit_signal("turn_ready")
		else:
			players.player.add_card_to_hand(card_being_dragged)
		
		card_being_dragged = null

#endregion

#region Signals

func connect_card_signals(card):
	card.connect("hovered", _on_hovered_over_card)
	card.connect("hovered_off", _on_hovered_off_card)

func connect_player_signals(player):
	match player.name:
		"player":
			self.player_turn.connect(player._on_turn)
		"partner":
			self.partner_turn.connect(player._on_turn)
		"left":
			self.left_turn.connect(player._on_turn)
		"right":
			self.right_turn.connect(player._on_turn)

	player.turn_ready.connect(_on_turn_ready)

func _on_deck_depleted() -> void:
	$"../UI/BottomRightButtons/ChangeCards".disabled = true

func _on_deck_shuffled() -> void:
	$"../UI/BottomRightButtons/ChangeCards".disabled = false

func _on_confirm_button_pressed(id):
	confirmID = id
	$"../UI/AcceptStakes".visible = false
	emit_signal("confirmation_signal")

#endregion

#region Highlights
func _on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

func _on_hovered_off_card(card):
	highlight_card(card, false)
	
	# Check if hovering from one card into another and act accordingly
	var new_card_hovered = raycast_check_for_card()
	if new_card_hovered:
		highlight_card(new_card_hovered, true)
	else:
		is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered and card.is_draggable and !paused:
		card.scale = Vector2(1.05, 1.05)
	else:
		card.scale = Vector2(1, 1)
#endregion

#region Raycasts
func raycast_check_for_card_slot() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null 

func raycast_check_for_pile(pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = pos
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var new_result = []
		for i in range(result.size()):
			new_result.append(result[i].collider.get_parent())
		return result
	return null 

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	
	return highest_z_card

func sort_cards_by_z_index(cards):
	cards.sort_custom(func (a, b):
		var current_card = a.collider.get_parent().z_index
		var next_card = b.collider.get_parent()	.z_index

		if current_card > next_card:
			return false
		else:
			return true
	)

	var return_array = []
	for col in cards:
		return_array.append(col.collider.get_parent())

	return return_array
	
func sort_z_indexes():
	var sorted_cards = {}
	for card in self.get_children():
		var i = cardConfigs.CARD_ORDER.find(card.name)
		sorted_cards[card] = i
	
	for card in sorted_cards:
		card.z_index = sorted_cards[card]
#endregion

#region Game Logic
#region State Machine

func _on_turn_ready() -> void:
	await get_tree().create_timer(0.5).timeout
	sort_z_indexes()

	match current_player:
		0:
			current_player += 1
			emit_signal("player_turn")
		1:
			current_player += 1
			emit_signal("left_turn")
		2:
			current_player += 1
			emit_signal("partner_turn")
		3:
			current_player += 1
			emit_signal("right_turn")
		_:
			current_player = 0
			emit_signal("round_over")

func _on_round_over() -> void:
	currentRound += 1

	var pile = raycast_check_for_pile(Vector2(screen_size.x/2, screen_size.y/2))
	var card_array = sort_cards_by_z_index(pile)
	var high_card = card_array[0]

	if high_card.name == "4C" and card_array[-1].name == "Backstab":
		winnerList.append(card_array[-1].player)
	else:
		winnerList.append(high_card.player)

	await get_tree().create_timer(0.5).timeout
	clearPile(pile, high_card.player.EDGE)

	if currentRound == 3:
		currentRound = 0
		checkAnteWinner()
		redistributeCards()
	
	if currentRound != 0:
		if randi() % 100 + 1 > 70:
			raiseStakes()

	_on_turn_ready()

#endregion

#region Game Rules
func _on_change_cards():
	var cardDict = {"player": players.player, "cards": []}	

	for card in range(players.player.hand.size()):
		cardDict.cards.append(players.player.hand[card])

	await players.player.clearHand()
	
	familyList.append(cardDict)

	for i in range(players.player.HAND_SIZE):
		players.player.add_card_to_hand(deck.generate_random_card(), true)

#region Stakes
## For other players to raise the stakes
func raiseStakes():
	$"../UI/AcceptStakes".visible = true
	await confirmation_signal
	var acceptedRaise
	if confirmID == "Accept":
		acceptedRaise = true
	else:
		acceptedRaise = false

	if !acceptedRaise:
		refusedStakes("other")
		return
	
	acceptStakes()

## For the player to raise the stakes
func _on_raise_stakes() -> void:
	var acceptChance = randi() % 100 + 1

	if acceptChance > 50:
		acceptStakes()
		print("stakes accepted")
	else:
		refusedStakes("player")
		print("stakes refused")

func refusedStakes(winner : String):
	for i in range(currentStakes):
		previousHands.append(winner)

	currentRound = 0
	currentStakes = 1
	$"../UI/InfoHUD/Stakes".text = "Stakes: " + str(currentStakes)
	$"../UI/InfoHUD/HandsLabel".text = "Player: " + str(previousHands.count("player")) + \
		"; Other: " + str(previousHands.count("other"))

	var cardsToFree = []
	for p in players:
		for card in players[p].hand:
			cardsToFree.append(card)
		await players[p].clearHand()
	for card in cardsToFree:
		card.queue_free()
		cardsToFree.erase(card)

	await get_tree().create_timer(0.1).timeout

	redistributeCards()

func acceptStakes():
	match currentStakes:
		1:
			currentStakes = 3
		3:
			currentStakes = 6
		6:
			currentStakes = 12
	
	$"../UI/InfoHUD/Stakes".text = "Stakes: " + str(currentStakes)

#endregion
#endregion

#region Helper Functions
func checkAnteWinner():
	var playerPair = 0
	var otherPair = 0

	for r in range(winnerList.size()):
		if winnerList[r] == players.player or winnerList[r] == players.partner:
			playerPair += 1
		elif winnerList[r] == players.left or winnerList[r] == players.right:
			otherPair += 1
	
	for i in range(currentStakes):
		if playerPair > otherPair:
			previousHands.append("player")
		elif otherPair > playerPair:
			previousHands.append("other")
	
	currentStakes = 1
	$"../UI/InfoHUD/Stakes".text = "Stakes: " + str(currentStakes)

	$"../UI/InfoHUD/HandsLabel".text = "Player: " + str(previousHands.count("player")) + \
		"; Other: " + str(previousHands.count("other"))
	
	print(previousHands)

func redistributeCards():
	if familyList.size() > 0:
		for family in range(familyList.size()):
			for card in range(familyList[family].cards.size()):
				familyList[family].cards[card].queue_free()
		familyList = []

	deck.shuffleDeck()

	for p in players:
		for i in range(players[p].HAND_SIZE):
			players[p].add_card_to_hand(deck.generate_random_card(), true)

func clearPile(pile, direction="bottom"):
	if pile != null:
		for i in pile:
			var card = i.collider.get_parent()
			var posTween = get_tree().create_tween()

			var finalPos
			match direction:
				"bottom":
					finalPos = Vector2(screen_size.x/2, screen_size.y * 1.3)
				"top":
					finalPos = Vector2(screen_size.x/2, -(screen_size.y * 0.4))
				"left":
					finalPos = Vector2(-(screen_size.x * 0.4), screen_size.y/2)
				"right":
					finalPos = Vector2(screen_size.x * 1.3, screen_size.y/2)

			posTween.tween_property(card, "position", finalPos, 0.1)
			await posTween.finished
			card.queue_free()
#endregion

#endregion

#region Menus and Popups
func pauseMenu():
	if paused:
		$"../UI/PauseMenu".hide()
		Engine.time_scale = 1
	else:
		$"../UI/PauseMenu".show()
		Engine.time_scale = 0
	
	paused = !paused

func cardOrder():
	if cardOrderShown:
		$"../UI/CardOrder".hide()
	else:
		$"../UI/CardOrder".show()
	
	cardOrderShown = !cardOrderShown
#endregion

#endregion
