extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	$DetectShelf.look_at(to_global(position + direction))
	move_and_slide()