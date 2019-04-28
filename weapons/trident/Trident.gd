extends Position2D


export var knock_back_force := 15.0
export var hit_delay := 0.15


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("move_up") and rotation_degrees != 0:
		rotation_degrees = 0
	elif event.is_action_pressed("move_down") and rotation_degrees != -180:
		rotation_degrees = -180
	elif event.is_action_pressed("move_left") and rotation_degrees != -90:
		rotation_degrees = -90
	elif event.is_action_pressed("move_right") and rotation_degrees != -270:
		rotation_degrees = -270


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body is Person and body.active:
		var direction := (body.global_position - global_position).normalized().round()
		direction = Utils.vec2_biggest_between_x_y(direction)
		body.hit(direction, knock_back_force)
	
