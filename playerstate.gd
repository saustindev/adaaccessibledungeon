extends Node2D

var hr = 50

var lvl = 1
var xp = 0
var xptonextlvl = 20

var itemstocks = [0,0,0,0]

const baseattack = 20

const basedef = 20

var statincrease = .3

var is_guarding = false

func heal(qty:int):
	hr -= qty
	if hr < 50:
		hr = 50

func add_xp(qty:int):
	var result = ""
	xp += qty
	if xp >= xptonextlvl:
		xp -= xptonextlvl
		xptonextlvl *= 1.1
		lvl += 1
		result = "Your level is elevated to " + str(lvl)
	return result

func get_atk():
	return baseattack *(1+ (statincrease * (lvl-1))) * (1.0 + float(hr-50.0)/150.0)
	
func get_def():
	return ( 2 if is_guarding else 1 ) * basedef * (1+ (statincrease * (lvl-1))) * (1.0 + float(hr-50.0)/150.0)

func get_panic_lvl():
	if hr < 70:
		return 0
	elif hr < 100:
		return 1
	elif hr < 135:
		return 2
	elif hr < 170:
		return 3
	elif hr < 190:
		return 4
	elif hr < 200:
		return 5
	else:
		return -1
		
func is_dead():
	return get_panic_lvl() == -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_gui():
	get_tree().get_root().get_node("GameView/playerui/heartrate").text = str(hr) + " bpm"
	get_tree().get_root().get_node("GameView/playerui/heartbeat").speed_scale = (float(hr))/60.0
	
	# change live reaction sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# update gui indicators
	update_gui()
	# hr
	
	# profile
	
	# inventory
	
	pass
