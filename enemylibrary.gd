extends Node2D



# interfaces with some csv or something to get info about enemies
var monster_stats = Array()
var monster_images = Array()
var ability_stats = Array()

# every turn they gain this % boost to all stats
const percent_increase_per_turn = 0.5

var rng = RandomNumberGenerator.new()

func match_image(path:String, hardcodedimages):
	print("trying to match " + path)
	for i in hardcodedimages:
		if i[0] == path:
			return i[1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	# i would rather hardcode this than learn any more
	var monster_count = 10
	#read the csv here and fill an array
	var file = FileAccess.open("./monster_stats.csv", FileAccess.READ)
	for i in range(monster_count):
		monster_stats.append(file.get_csv_line())
		print(monster_stats[i])
		monster_images.append(Array())
		for j in range(4):
			#var newimg = Image.new()
			#newimg.load(get_enemy_sprite_location(i,j))
			#var newimg = match_image(get_enemy_sprite_location(i,j), hardcodedimages)
			var newimg = Image.load_from_file(get_enemy_sprite_location(i,j))
			
			
			var newtexture = ImageTexture.create_from_image(newimg)
			
			monster_images[i].append(newtexture)
			
	var ability_count = 4
	file = FileAccess.open("./ability_stats.csv", FileAccess.READ)
	for i in range(ability_count):
		ability_stats.append(file.get_csv_line())



func get_ability_min_proximity(id:int):
	return int(ability_stats[id][2])
	
func get_ability_damage(id:int):
	return float(ability_stats[id][3])
	
func get_ability_string(id:int):
	return ability_stats[id][4]

func get_enemy_sprite(id:int, distance:int):
	return monster_images[id][distance]

func get_enemy_sprite_location(id:int, distance:int):
	#return "res://enemies/" + monster_stats[id][7] + str(distance) + ".png";
	return "./enemies/" + monster_stats[id][7] + str(distance) + ".png";

func get_enemy_attack(id: int):
	return float(monster_stats[id][1]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0))

func get_enemy_defense(id: int):
	return float(monster_stats[id][2]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0))

func get_enemy_mdefense(id: int):
	return float(monster_stats[id][3]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0))

func get_enemy_hp(id: int):
	return float(monster_stats[id][4]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0))

func get_enemy_speed(id: int):
	return float(monster_stats[id][5]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0))

func get_enemy_callprobability(id: int):
	return float(monster_stats[id][6]) * ( 1.0 + percent_increase_per_turn*(float(get_parent().turncounter)/100.0)) / 4

func get_enemy_ability(id:int):
	return int(monster_stats[id][10])

func get_enemy_ability_count(id:int):
	return int(monster_stats[id][9])

func get_enemy_xp(id:int):
	return int(get_enemy_attack(id) + get_enemy_defense(id) + get_enemy_hp(id)/3)/3

func get_enemy_droprate(id:int):
	return 0.3

const itemnames = ["Lasso","Dart","Cross","Potion"]

func get_enemy_itemdrop(id:int):
	var roll = rng.randf_range(0.0,1.0)
	if roll <= get_enemy_droprate(id):
		return ""
	var itemid = range(0,4).pick_random()
	get_parent().get_child(2).itemstocks[itemid] += 1
	return itemnames[itemid]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func get_enemy_name(id: int):
	if id == -1:
		return "air"
	return monster_stats[id][0]
	
# etc for other enemy attributes
