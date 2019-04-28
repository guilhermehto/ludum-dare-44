extends Position2D

signal spawned(person)

onready var tween : Tween = $Tween
onready var timer : Timer = $Timer

export var persons := []
export(float, 5.0, 15.0) var max_spawn_interval := 7.5

const Y_OFFSET = 100


func _ready() -> void:
	assert persons.size() > 0
	randomize()
	timer.wait_time = rand_range(max_spawn_interval * 0.5, max_spawn_interval)
	timer.start()


func _on_Timer_timeout() -> void:
	timer.wait_time = rand_range(max_spawn_interval * 0.5, max_spawn_interval)
	timer.start()
	spawn()


func spawn() -> void:
	var new_person = persons[randi() % persons.size()].instance()
	add_child(new_person)
	emit_signal("spawned", new_person)
	new_person.global_position = global_position + Vector2.UP * Y_OFFSET
	tween.interpolate_property(new_person,
		"global_position",
		new_person.global_position,
		new_person.global_position + Vector2.DOWN * Y_OFFSET,
		0.75,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	new_person.active = true
