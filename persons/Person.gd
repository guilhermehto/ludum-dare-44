extends KinematicBody2D
class_name Person

onready var animation_player : AnimationPlayer = $AnimationPlayer


func hit(direction: Vector2, force: float) -> void:
	move_and_slide(direction * force)
	animation_player.play("hit")
