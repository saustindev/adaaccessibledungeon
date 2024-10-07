extends Node2D
const floorqty = 50;

var floors = Array()
var floorbgs = Array()

const valid_monsters = [ 0, 1, 2, 3,4,5,6,7 ]
const valid_emptys = [ 1, 2, 3, 4 ]
const valid_bgs = ["empty","full","blood","mold","spider","poster","lasertag","fancy","fancyempty","fancyposter","fancyroomba"]

const bosslocation = "./bgs/throneroom.png"

func is_floor_called(floor: int):
	if floors[floor] >= 100:
		return false
	else:
		var rng = RandomNumberGenerator.new()
		var roll = rng.randf_range(0.0, 1.0)
		if roll < get_tree().get_root().get_node("GameView/singleton/enemylibrary").get_enemy_callprobability(floors[floor]):
			return true
		return false

func get_random_bg_location():
	var result = "./bgs/" + valid_bgs.pick_random() + ".png"
	return result

var alreadyready = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if alreadyready:
		return
	# generate however many floors worth of encounters
	var rng = RandomNumberGenerator.new()
	for i in floorqty:
		
		var newimg = Image.load_from_file(get_random_bg_location())
		var newtexture = ImageTexture.create_from_image(newimg)
		floorbgs.append(newtexture)
		
		
		# each floor will have an int value.
		# 0-99 will be enemies with the corresponding id
		# multiples of 100 will be variants of safe floors
		# multiples of 1000 will be variants of safe floors, with items
		
		var enemy_chance = 0.7
		var item_chance = 0.1
		var empty_chance = 0.2
		var roll = rng.randf_range(0.0, 1.0)
		if roll < enemy_chance:
			# get a random enemy id
			floors.append(valid_monsters.pick_random())
		elif roll < enemy_chance+item_chance:
			# get a random empty floor variety and multiply it by 1000
			floors.append(valid_emptys.pick_random() * 1000)
		else:
			# get a random empty floor variety and multiply it by 100
			floors.append(valid_emptys.pick_random() * 100)
	
	# lastly add the boss floor
	var newimg1 = Image.load_from_file(bosslocation)
	var newtexture1 = ImageTexture.create_from_image(newimg1)
	floorbgs.append(newtexture1)
	
	floors.append(9)
	
	print(floors)
	alreadyready=true

func monster_id_of_floor(floorid:int):
	if !alreadyready:
		_ready()
	if floors[floorid] == -1 or floors[floorid] > 99:
		return -1
	else:
		return floors[floorid]

func remove_monster_from_floor(floorid:int):
	floors[floorid] = -1

func get_floor_bg(floornum:int):
	return floorbgs[floornum]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
