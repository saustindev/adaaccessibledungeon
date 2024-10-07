extends Sprite2D

const locations = ["./player/stress0.png","./player/stress1.png","./player/stress2.png","./player/stress3.png","./player/stress4.png","./player/stress5.png"]

var sprites = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		var newimg = Image.load_from_file(locations[i])
		var newtexture = ImageTexture.create_from_image(newimg)
		sprites.append(newtexture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture = sprites[get_tree().get_root().get_node("GameView/singleton/playerstate").get_panic_lvl()]
