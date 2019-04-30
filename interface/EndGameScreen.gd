extends CanvasLayer

onready var total_time_label : Label = $Control/TotalTime
onready var biggest_combo_label : Label = $Control/BiggestCombo


func initialize(biggest_combo: int, game_time: float) -> void:
	biggest_combo_label.text = "Biggest combo: %s" % biggest_combo
	total_time_label.text = "Time: %s" % _get_time_string(game_time)


func _get_time_string(time_in_seconds) -> String:
	var text := ""
	var minutes := int(time_in_seconds / 60)
	var seconds := int(fmod(time_in_seconds, 60.0))
	if minutes > 0:
		text = "%s:%s" % [minutes, str(seconds) if seconds >= 10 else "0%s" % seconds]
	else:
		text = "%s" % seconds
	return text