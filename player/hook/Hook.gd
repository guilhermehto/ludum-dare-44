extends Position2D

onready var tween : Tween = $Tween
onready var line : Line2D = $Line2D
onready var raycast : RayCast2D = $RayCast2D

export var margin := 10.0
export var speed := 350.0
export var travel_distance := 75.0
export var acceleration := 2.0


var player : Player
var hook_to : Vector2
var hook_direction : Vector2
var current_speed := 0.0
var active := false


func _physics_process(delta: float) -> void:
	match tween.is_active():
		false:
			var direction := (get_global_mouse_position() - global_position).normalized()
			raycast.cast_to = direction * 150.0
			if Input.is_action_just_pressed("hook"):
				hook_to = to_global(raycast.cast_to)
				line.add_point(Vector2())
				tween.interpolate_method(line, 
					"add_point",
					Vector2(),
					direction * 150,
					0.5,
					Tween.TRANS_QUART, 
					Tween.EASE_OUT)
				tween.start()
				yield(tween, "tween_completed")
				line.points = PoolVector2Array()
		true:
			current_speed = lerp(current_speed, speed, acceleration * delta)
			player.move_and_slide(current_speed * (hook_to - global_position).normalized())


func initialize(_player: Player) -> void:
	player = _player


func _on_Tween_tween_started(object: Object, key: NodePath) -> void:
	active = true


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	active = false
	current_speed = 0
