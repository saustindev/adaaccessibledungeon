extends Node2D

var winscene = preload("res://credits.tscn").instantiate()
var losescene = preload("res://gameover.tscn").instantiate()

# here be game state
var enemylist = null
var floormanager = null
var elevatorgod = null

var turncounter = 0

var lastopenedturn = 9999
var doorclosedness = 133
var openness_stage = 0

var currentenemyid = -1
var enemyproximity = 0.0
var currentenemyhp = -1

var doorclosingvelocity = 0

var interactable = true
var ready_time = -1000

const default_wait_time = 1;

func arrive_at_floor():
	get_tree().get_root().get_node("GameView/messageboxparent/text").set_scrolling_text("You arrive at floor " + str(elevatorgod.current_floor))
	
	# get the enemyid from the floormanager
	currentenemyid = floormanager.monster_id_of_floor(elevatorgod.current_floor)
	
	# and set it
	
	# then set their hp
	currentenemyhp = enemylist.get_enemy_hp(currentenemyid)
	
	# reposition them
	enemyproximity = 0.0
	
	# also get the background and set that
	get_tree().get_root().get_node("GameView/farbg").texture = floormanager.get_floor_bg(elevatorgod.current_floor)
	
	# make the door start opening
	doorclosingvelocity = -34
	
	get_tree().get_root().get_node("GameView/sfx/elevatorwhirr").stop()
	get_tree().get_root().get_node("GameView/sfx/elevatorwinddown").play()

func wait_for_time(length: float):
	interactable = false;
	ready_time = Time.get_ticks_msec() + length*1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemylist = get_tree().get_root().get_node("GameView/singleton/enemylibrary")
	floormanager = get_tree().get_root().get_node("GameView/singleton/floormanager")
	elevatorgod = get_tree().get_root().get_node("GameView/elevatorgod")
	arrive_at_floor()


func set_bgm_volumes(closedness: int):
	var elevatormusiclvl = 1.0 - float(100 - closedness)/100.0
	var outsidemusiclvl = 1.0 - elevatormusiclvl
	
	# actually set the volumes

var wasjustopen = false
var was_just_closed = false
var wasinbetween = false

func door_is_closed():
	return doorclosedness >= 100

var waitingtoarrive = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemylist == null:
		enemylist = get_tree().get_root().get_node("GameView/singleton/enemylibrary")
	
	if !interactable:
		if ready_time > Time.get_ticks_msec():
			#print("Not ready for another " + str(ready_time - Time.get_ticks_msec()) + " ms")
			return
		else:
			ready_time = 0
			interactable = true
	
	if gamewon:
		get_tree().get_root().get_node("GameView/bgm").stop()
		get_tree().root.add_child(winscene);
		get_tree().get_root().remove_child(get_tree().get_root().get_node("GameView"))
	elif get_child(2).is_dead():
		get_tree().get_root().get_node("GameView/bgm").stop()
		get_tree().root.add_child(losescene);
		get_tree().get_root().remove_child(get_tree().get_root().get_node("GameView"))
	
	if waitingtoarrive:
		waitingtoarrive = false
		arrive_at_floor()



func change_floor():
	# play sound effects, go non interactive for a bit, do arrive at floor
	get_tree().get_root().get_node("GameView/messageboxparent/text").set_scrolling_text("The elevator begins to move.")
	wait_for_time(4)
	waitingtoarrive = true
	get_tree().get_root().get_node("GameView/sfx/elevatorwhirr").play()

func damage_player(dmg: int):
	var result = "You take " + str(dmg) + " damage\n"
	get_child(2).hr += dmg
	if get_child(2).is_dead():
		result += "You lose!"
	return result

func perform_enemy_turn():
	var result = ""
	var actions = Array()
	match currentenemyid:
		-1:
			return result
			
	if enemyproximity >= 2:
		actions.append(0)
	
	print("Ability count is " + str(enemylist.get_enemy_ability_count(currentenemyid)))
	if enemylist.get_enemy_ability_count(currentenemyid) > 0:
		actions.append(enemylist.get_enemy_ability(currentenemyid))
	if actions.size() == 0:
		return result
	var chosenattack = actions.pick_random()
	print("Chose ability #" + str(chosenattack))
	# perform the attack
	if enemyproximity >= enemylist.get_ability_min_proximity(chosenattack):
		result = enemylist.get_ability_string(chosenattack).replace("$", enemylist.get_enemy_name(currentenemyid)) + "\n"
		if enemylist.get_ability_damage(chosenattack) > 0:
			result += damage_player(float(enemylist.get_enemy_attack(currentenemyid)) * enemylist.get_ability_damage(chosenattack) / float(get_child(2).get_def()))
	else:
		print("Out of range of min proximity " + str(enemylist.get_ability_min_proximity(chosenattack)))
	return result

var gamewon = false
# kill the enemy and reward the player. return the string
func kill_enemy():
	if currentenemyid == -1:
		return ""
	
	# communicate with floormanager and make the floor stay dead
	floormanager.remove_monster_from_floor(elevatorgod.current_floor)
	
	var result = "You slay the " + enemylist.get_enemy_name(currentenemyid)
	result += "\nYou receive " + str(enemylist.get_enemy_xp(currentenemyid)) + " xp\n"
	result += get_child(2).add_xp(enemylist.get_enemy_xp(currentenemyid))
	var itemdrop = enemylist.get_enemy_itemdrop(currentenemyid)
	if itemdrop != "":
		result += "\nThe enemy drops a " + itemdrop + "\n"
		# also add it to player inventory
	
	if currentenemyid == 9:
		gamewon = true
	
	currentenemyid = -1
	return result

func enemy_proximity_stuff():
	print("Enemy proximity: " + str(enemyproximity))
	# adjust the enemy sprite based on its proximity
	if currentenemyid == -1:
		get_tree().get_root().get_node("GameView/enemysprite").visible = false
	else:
		get_tree().get_root().get_node("GameView/enemysprite").visible = true
		get_tree().get_root().get_node("GameView/enemysprite").set_texture(get_child(0).get_enemy_sprite(currentenemyid,(3-int(enemyproximity))))

func openness_proximity_stuff():
	get_tree().get_root().get_node("GameView/doormanager").move_doors_to_stage(openness_stage);
	# check how closed the door is
	if doorclosedness >= 100:
		# update the door positions
		openness_stage = 0
		
		doorclosedness = 133
		
		# adjust bgm volumes
		set_bgm_volumes(100)
		# the door is closed and the elevator moves on
		# set the text to say the doors closed
		# consult the elevatorgod for a new floor
		if !was_just_closed:
			was_just_closed = true
		else:
			
			get_tree().get_root().get_node("GameView/elevatorgod").get_next_floor()
			
		# pause for a few seconds and move there
		wasinbetween = false
		wasjustopen = false
	elif doorclosedness >= 66:
		# update the door positions
		openness_stage = 1
		# adjust bgm volumes
		set_bgm_volumes(66)
		

		wasjustopen = false
		was_just_closed = false
	elif doorclosedness >= 33:
		# update the door positions
		openness_stage = 2
		# adjust bgm volumes
		set_bgm_volumes(33)

		wasjustopen = false
		was_just_closed = false
	else:
		# update the door positions
		openness_stage = 3
		
		if doorclosingvelocity < 0:
			doorclosingvelocity = 0
		if !wasjustopen:
			lastopenedturn = turncounter
			wasjustopen = true
		
		# check floor for items
		
		
		was_just_closed = false
		# adjust bgm volumes
		set_bgm_volumes(0)

func shake_enemy():
	get_tree().get_root().get_node("GameView/hitanimation").play()
	get_tree().get_root().get_node("GameView/sfx/hitsound").play()
	var tween1 = get_tree().create_tween()
	tween1.tween_property(get_tree().get_root().get_node("GameView/enemysprite"),"offset",Vector2(40,0),.05)
	tween1.tween_property(get_tree().get_root().get_node("GameView/enemysprite"),"offset",Vector2(-40,0),.05)
	tween1.tween_property(get_tree().get_root().get_node("GameView/enemysprite"),"offset",Vector2(0,0),.05)

var crossturn = -999
var crossduration = 4
const potionpotency = 50

# player control buttons will be coded to call this function and pass their ID
func take_action(id: int):
	if !interactable:
		return
		
	var startofturnclosedness = doorclosedness
	var playeractiontext = ""
	match id:
		# 0 = basic attack
		0:
			playeractiontext = "You swing at the " + enemylist.get_enemy_name(currentenemyid)
		# 1 = guard
		1:
			playeractiontext = "You raise your shield--"
			pass
		# 2 = open button
		2:
			playeractiontext = "You press the open button."
			# immediately cause the door to begin to open
			doorclosingvelocity = -34
		# 3 = close button
		3:
			playeractiontext = "You press the close button."
			if doorclosedness < 100:
				# keep a counter for how many times the player has pressed it
				# and change flavor text ie. 3rd time = "YOU MASH THE CLOSE BUTTON!" etc.
				var rng = RandomNumberGenerator.new()
				doorclosingvelocity += rng.randi_range(22, 44)
		4:
			if doorclosedness < 100:
				playeractiontext = "You lasso the " + enemylist.get_enemy_name(currentenemyid)
				enemyproximity = 3
				get_child(2).itemstocks[0] -= 1
			else:
				playeractiontext = "You try to use the lasso, but the door is in the way."
		5:
			if doorclosedness < 100:
				playeractiontext = "You throw a dart at the " + enemylist.get_enemy_name(currentenemyid)
				get_child(2).itemstocks[1] -= 1
			else:
				playeractiontext = "You try to use the dart, but the door is in the way."
		6:
			get_child(2).itemstocks[2] -= 1
			playeractiontext = "You brandish the cross."
			enemyproximity = 0
			crossturn = turncounter
		7:
			get_child(2).itemstocks[3] -= 1
			playeractiontext = "You chug a potion."
			get_child(2).heal(50)
		
	#print("velocity: " + str(doorclosingvelocity))
	#print("closedness: " + str(doorclosedness))
	#print("lastopenedturn: " + str(lastopenedturn))
	# once the player's action is taken care of, calculate the effect on the enemy
	var playerresulttext = ""
	
	if id == 1:
		get_child(2).is_guarding = true
	else:
		get_child(2).is_guarding = false
	
	if (id == 0 || id == 5) and doorclosedness < 100:
		if currentenemyid != -1:
			
			if id == 0 && enemyproximity < 2:
				playerresulttext = "You miss-- they're too far away"
			else:
				var dmg = get_child(2).get_atk() * 10 / get_child(0).get_enemy_defense(currentenemyid)
				shake_enemy()
				playerresulttext = "You deal " + str(int(dmg)) + " damage\n"
				currentenemyhp -= dmg
				if currentenemyhp <= 0:
					playerresulttext +=kill_enemy()
	
	# then decide an action for the enemy to take
	var enemyactiontext = ""
	
	if startofturnclosedness <= 99 && currentenemyid != -1:
		enemyactiontext += perform_enemy_turn()
		
		if startofturnclosedness <= 66:
			if enemyproximity < 3:
				if turncounter - crossturn <= crossduration:
					enemyactiontext += "The power of Christ compels the " + enemylist.get_enemy_name(currentenemyid) + "!"
					
				else:
					enemyproximity += float(enemylist.get_enemy_speed(currentenemyid))/25.0
					if enemyproximity > 3:
						enemyproximity = 3
					if enemylist.get_enemy_speed(currentenemyid) != 0:
						enemyactiontext += "The " + enemylist.get_enemy_name(currentenemyid) + " advances."
	if turncounter - crossturn == crossduration:
		enemyactiontext += "\nThe cross wore off."
	# then calculate the effect on player
	var enemyresulttext = ""
	
	# manage the openness of the doors
	if turncounter - lastopenedturn > 4 and doorclosingvelocity == 0:
		doorclosingvelocity = 34
	
	if doorclosingvelocity < 0:
		doorclosedness += doorclosingvelocity
		if doorclosedness < 0:
			doorclosedness = 0
	else:
		# door can't close if there's an enemy up close
		if doorclosedness < 66 or currentenemyid == -1 or enemyproximity < 3:
			doorclosedness += doorclosingvelocity
	
	

	enemy_proximity_stuff()
	
	# instantiate an animation for the attacks
	
	if gamewon:
		enemyactiontext = "You have won the game!!!"
	
	# set the text box contents
	get_tree().get_root().get_node("GameView/messageboxparent/text").set_scrolling_text(playeractiontext + "\n" + playerresulttext + "\n" + enemyactiontext + "\n" + enemyresulttext)
	
	# increment the counter
	turncounter += 1
	
	# wait
	wait_for_time(default_wait_time)
	
	# heal if no enemies
	if currentenemyid == -1:
		get_child(2).heal(1)
	
	openness_proximity_stuff()
	
	
