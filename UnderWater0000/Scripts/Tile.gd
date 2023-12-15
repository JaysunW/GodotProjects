extends StaticBody2D

@export var max_health = 100
var tile_position = Vector2(0,0)

var health = 0
var hardness = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# Mine tile by a certain amount of damage
func mine(damage):
	health -= damage
	if health <= 0:
		destroy_tile()
		
	# Sets destruction texture of the tile
	var destruction_sprite = $Destruction
	var frame_count = destruction_sprite.sprite_frames.get_frame_count("default")
	destruction_sprite.frame = frame_count - int (float(health)/float(max_health) * frame_count)
	
func get_tile_position():
	return tile_position

func set_tile_position(input):
	tile_position = input
	
# Destroy tile and remove it from the main tile dictionary
func destroy_tile():
	queue_free()
	pass
