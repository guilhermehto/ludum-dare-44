extends CanvasLayer

onready var punished : Label = $Control/Panel/Punished
onready var time : Label = $Control/Panel/Time

var level_time := 0.0
var punished_goal := 0
var punished_count := 0 setget set_punished_count


func _process(delta: float) -> void:
	level_time -= delta
	set_time_text(level_time)


func initialize(_level_time: float, _punished_goal: int) -> void:
	level_time = _level_time
	punished_goal = _punished_goal
	punished.text = "0/%s" % str(punished_goal)


func set_time_text(time_in_seconds: float) -> void:
	var minutes := int(time_in_seconds / 60)
	var seconds := int(fmod(time_in_seconds, 60.0))
	if minutes > 0:
		time.text = "%s:%s" % [minutes, str(seconds) if seconds >= 10 else "0%s" % seconds]
	else:
		time.text = "%s" % seconds


func set_punished_count(value: int) -> void:
	punished_count = value
	punished.text = "%s/%s" % [str(punished_count), str(punished_goal)]
