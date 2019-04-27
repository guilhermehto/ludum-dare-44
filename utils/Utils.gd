extends Node


func _ready() -> void:
	randomize()

func vec2_biggest_between_x_y(vector: Vector2) -> Vector2:
	if abs(vector.x) > abs(vector.y):
		vector.y = 0
	else:
		vector.x = 0
	return vector

func get_random_vec2() -> Vector2:
	return Vector2(randf() * 2 - 1, randf() * 2 - 1)
