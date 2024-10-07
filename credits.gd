extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween1 = get_tree().create_tween()
	tween1.tween_property(get_child(0),"transform",Transform2D(0.0, Vector2(0,-4920)),40)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
