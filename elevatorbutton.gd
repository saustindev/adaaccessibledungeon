extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = name.substr(6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_button_appear_pressed():
	get_child(0).visible = true;

func make_button_appear_unpressed():
	get_child(0).visible = false;


# not to be confused with

func press_button():
	if !get_tree().get_root().get_node("GameView/singleton").interactable:
		return
	# what floor is the button
	var currentfloor = int(float(text))
	
	# in any case play a ding (prioritized player experience)
	get_parent().get_child(0).play()
	# tell the elevator god to set the elevator button
	get_tree().get_root().get_node("GameView/elevatorgod").press_button(currentfloor)


func _on_pressed() -> void:
	press_button()
