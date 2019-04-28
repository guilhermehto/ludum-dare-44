extends CanvasLayer

onready var punished : Label = $Control/Panel/Punished
onready var combo : Label = $Control/Panel/Combo
onready var time : Label = $Control/Panel/Time
onready var tween : Tween = $Tween


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


func _on_Level_combo_ended() -> void:
	combo.hide()


func _on_Level_comboed(count) -> void:
	combo.show()
	combo.text = "COMBO\n%s" % count
	tween.interpolate_property(combo,
		"rect_scale",
		Vector2(0.5, 0.5),
		Vector2(0.75, 0.75),
		0.25,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT)
	tween.interpolate_property(combo,
		"rect_scale",
		Vector2(0.75, 0.75),
		Vector2(0, 0),
		3.0,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT,
		0.25)
	tween.start()
