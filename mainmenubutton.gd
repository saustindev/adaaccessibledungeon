extends Button

var newscene = preload("res://tutorial.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_scene():
	get_tree().root.add_child(newscene);



func _on_pressed() -> void:
	change_scene()
