extends Button

var newscene = preload("res://game_view.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_scene():
	get_tree().root.add_child(newscene.instantiate());



func _on_pressed() -> void:
	if get_tree().get_root().get_node("MainMenu/bgm") != null:
		get_tree().get_root().get_node("MainMenu/bgm").stop()
	change_scene()
	if get_tree().get_root().get_node("MainMenu") != null:
		get_tree().get_root().remove_child(get_tree().get_root().get_node("MainMenu"))
	if get_tree().get_root().get_node("Tutorial") != null:
		get_tree().get_root().remove_child(get_tree().get_root().get_node("Tutorial"))
	else:
		get_tree().get_root().remove_child(get_tree().get_root().get_node("GameOver"))
