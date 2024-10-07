extends Node2D

var currentopenness = 0

func move_doors_to_stage(openness: int):
	if openness < 0 or openness > 3:
		return
	if openness == currentopenness:
		return
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(get_child(0),"offset",Vector2(openness*-530.0/3,0),.66)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(get_child(1),"offset",Vector2(openness*530.0/3,0),.66)
	# play a sound effect
	
	if currentopenness == 0 && openness != 0:
		get_tree().get_root().get_node("GameView/sfx/elevatoropen").play()
	elif currentopenness != 0 && openness == 0:
		get_tree().get_root().get_node("GameView/sfx/elevatorshut").play()
	
	currentopenness = openness

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
