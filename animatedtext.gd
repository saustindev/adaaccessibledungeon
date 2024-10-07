extends Label

var done = true
var targetstring = ""
var currentindex = -1
var timeperchar = 16
var lasttime = -999

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !done:
		if Time.get_ticks_msec() >= lasttime + timeperchar:
			lasttime = Time.get_ticks_msec()
			currentindex += 1
			if currentindex > targetstring.length():
				done = true
			else:
				# play beep sound
				text = targetstring.substr(0,currentindex)
				get_tree().get_root().get_node("GameView/sfx/textbeep").play()

func set_scrolling_text(newtext: String):
	done = false
	currentindex = 0
	targetstring = newtext
