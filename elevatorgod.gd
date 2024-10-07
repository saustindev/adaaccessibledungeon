extends Node2D

const floorqty = 51;

var floors = Array()

var current_floor = 0

func get_next_floor():
	# look at all the buttons that are pressed.
	# pick the closest one and trace a path to it
	# for each floor on the way that has an enemy, roll a die to see if he pressed the call button
	# if so, that is the target
	# if not, use the closest pressed floor.
	var rng = RandomNumberGenerator.new()
	#placeholder algorithm
	for i in floorqty:
		if floors[i]:
			if i == current_floor:
				floors[i] = false
			else:
				current_floor = i
				get_tree().get_root().get_node("GameView/singleton").change_floor()
				
				floors[i] = false
				return
		elif i > current_floor:
			# if passing a floor with a monster
			if get_tree().get_root().get_node("GameView/singleton/floormanager").floors[i] in range(0,99):
				var randnum = rng.randf_range(0.0, 1.0)
				var probability = get_tree().get_root().get_node("GameView/singleton/enemylibrary").get_enemy_callprobability(get_tree().get_root().get_node("GameView/singleton/floormanager").floors[i])
				# and the monster pressed the call button
				if randnum < probability:
					current_floor = i
					get_tree().get_root().get_node("GameView/singleton").change_floor()
					floors[i] = false
					return 
	
	# or, if the player did not press a button, check every floor outwards in both directions likewise
	# the top floor has a 100% chance of summoning the player, so if no other enemy calls them, the final boss will
	# return 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floors.resize(floorqty)
	floors.fill(false)

func press_button(num: int):
	floors[num - 1] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# enforce upon each button the correct lighting 
	
	for currentfloor in floors.size():
		if self.get_children().size() <= currentfloor + 1:
			break
		if floors[currentfloor]:
			# get the corresponding button (it's a child of this obj) and then change it's background (call the appropriate method)
			
			var thisbutton = self.get_child(currentfloor+1)
			thisbutton.make_button_appear_pressed()
		else:
			# do the opposite
			var thisbutton = self.get_child(currentfloor+1)
			thisbutton.make_button_appear_unpressed()
			pass
