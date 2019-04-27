extends KinematicBody2D
class_name Person

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var raycast : RayCast2D = $RayCast2D

enum States { IDLE, RUNNING, DEAD }

export var move_speed := 30.0
export var hits_to_die := 2
export var danger_distance_to_player := 20.0

var player : Player
var state = States.IDLE setget set_state
var direction := Vector2()
var target := Vector2()
var look_for_target := false


func _ready() -> void:
	player = $"../Player"
	randomize()
#	target = _get_new_target()
	target = yield(get_new_target(), "completed")
	


func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	direction = (target - position).normalized()
	match state:
		States.IDLE:
			move_and_slide(move_speed * 0.75 * direction)
			if player.global_position.distance_to(global_position) <= danger_distance_to_player:
				self.state = States.RUNNING
			elif target.distance_to(position) < 2.0:
				target = yield(get_new_target(), "completed")
		States.RUNNING:
			move_and_slide(move_speed * direction)
			if target.distance_to(position) < 2.0:
				self.state = States.IDLE


func get_new_target(away_from_player: bool = false):
	var cast_direction := Utils.get_random_vec2().normalized() \
		if not away_from_player else (global_position - player.global_position).normalized()
	raycast.cast_to = cast_direction * 25.0
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	if raycast.is_colliding():
		while raycast.is_colliding():
			raycast.cast_to = Utils.get_random_vec2().normalized() * 25.0
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
	return position + raycast.cast_to.normalized() * 20.0


func hit(direction: Vector2, force: float) -> void:
	target = yield(get_new_target(), "completed")
	move_and_slide(direction * force)
	animation_player.play("hit")
	hits_to_die -= 1
	if hits_to_die == 0:
		self.state = States.DEAD


func initialize(_player: Player) -> void:
	player = _player


func set_state(value) -> void:
	state = value
	match state:
		States.IDLE:
			target = yield(get_new_target(), "completed")
		States.RUNNING:
			target = yield(get_new_target(), "completed")
		States.DEAD:
			set_process(false)
			set_physics_process(false)
			$CollisionShape2D.queue_free()
