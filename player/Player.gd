extends KinematicBody2D
class_name Player

onready var hook : Position2D = $Hook
onready var particles : CPUParticles2D = $Particles
onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed := 25.0


func _ready() -> void:
	hook.initialize(self)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("move_left") and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		particles.position.x = abs(particles.position.x)
		particles.scale = Vector2(1, 1)
	elif event.is_action_pressed("move_right") and animated_sprite.flip_h:
		animated_sprite.flip_h = false
		particles.position.x = -abs(particles.position.x)
		particles.scale = Vector2(-1, 1)


func _physics_process(delta: float) -> void:
	var motion := Vector2(int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")), 
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up")))
	
	if motion == Vector2.ZERO and animated_sprite.animation != "idle":
		animated_sprite.play("idle")
		particles.emitting = false
	elif motion != Vector2.ZERO and animated_sprite.animation != "run":
		animated_sprite.play("run")
		particles.emitting = true
	
	var velocity := motion.normalized() * move_speed
	if not hook.active:
		move_and_slide(velocity)
