extends CanvasLayer

signal restart_requested
signal next_level_requested

onready var tween : Tween = $Tween
onready var title : Label = $Container/Title
onready var time : Label = $Container/Column/Time
onready var buttons_container : Control = $Container/Buttons
onready var next_button : Label = $Container/Buttons/Next
onready var container : Control = $Container
onready var selection_arrow : Control = $Container/SelectionArrow

var buttons := []
var selected_index : int
var arrow_offset := Vector2(2, 0)
var level_won := false

func _ready() -> void:
	buttons = buttons_container.get_children()
	selection_arrow.rect_global_position = _get_arrow_position()


func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_left'):
		selected_index = max(selected_index - 1, 0)
		_move_arrow()
	elif event.is_action_pressed('ui_right'):
		selected_index = min(selected_index + 1, buttons.size() - 1)
		_move_arrow()
	elif event.is_action_pressed('ui_accept'):
		if not container.visible:
			return
		container.visible = false
		match selected_index:
			0:
				emit_signal("restart_requested")
			1:
				match level_won:
					false:
						get_tree().quit()
					true:
						emit_signal("next_level_requested")


func _move_arrow() -> void:
	var move_to = _get_arrow_position(selected_index)
	tween.interpolate_property(selection_arrow, 
		"rect_global_position", 
		selection_arrow.rect_global_position, 
		move_to, 
		0.1, 
		Tween.TRANS_QUART, 
		Tween.EASE_OUT)
	tween.start()


func _get_arrow_position(button_index : int = 0) -> Vector2:
	return Vector2(buttons[button_index].get_global_rect().position.x + arrow_offset.x, buttons[button_index].get_global_rect().position.y + arrow_offset.y)


func _on_Game_level_ended(won: bool, level_time : float) -> void:
	level_won = won
	next_button.text = "Next" if won else "Quit"
	if won:
		time.text = "Time: %s" % _get_time_string(level_time)
	else:
		time.text = "TIMEOUT"
	title.text = "LEVEL %s" % ("COMPLETED" if won else "FAILED")
	tween.interpolate_property(container, 
		"rect_global_position", 
		Vector2(0, -150), 
		Vector2(), 
		0.75, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT)
	tween.start()
	yield(get_tree(), "idle_frame")
	container.visible = true


func _get_time_string(time_in_seconds) -> String:
	var text := ""
	var minutes := int(time_in_seconds / 60)
	var seconds := int(fmod(time_in_seconds, 60.0))
	if minutes > 0:
		text = "%s:%s" % [minutes, str(seconds) if seconds >= 10 else "0%s" % seconds]
	else:
		text = "%s" % seconds
	return text