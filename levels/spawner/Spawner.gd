extends Position2D

signal spawned(person)

onready var tween : Tween = $Tween
onready var timer : Timer = $Timer

export var persons := []
export var max_spawn_count := 3
export(float, 5.0, 15.0) var max_spawn_interval := 7.5


const Y_OFFSET = 100

var currently_spawned := 0

func _ready() -> void:
	assert persons.size() > 0
	randomize()
	timer.wait_time = rand_range(max_spawn_interval * 0.5, max_spawn_interval)
	timer.start()


func _on_Timer_timeout() -> void:
	timer.wait_time = rand_range(max_spawn_interval * 0.5, max_spawn_interval)
	timer.start()
	if currently_spawned < max_spawn_count:
		spawn()


func spawn() -> void:
	currently_spawned += 1
	var new_person = persons[randi() % persons.size()].instance()
	new_person.connect("punished", self, "_on_Person_punished")
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


func _on_Person_punished() -> void:
	currently_spawned -= 1