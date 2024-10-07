extends Button

@export var actionid : int
var isitem : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isitem = actionid > 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isitem:
		var itemid = actionid-4
		if get_tree().get_root().get_node("GameView/singleton/playerstate").itemstocks[itemid] == 0:
			visible = false
		else:
			visible = true
			get_child(0).text = "x" + str(get_tree().get_root().get_node("GameView/singleton/playerstate").itemstocks[itemid])

func _on_pressed() -> void:
	get_tree().get_root().get_node("GameView/singleton").take_action(actionid)
	
