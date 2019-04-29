
extends Control
class_name MainMenu

export var arrow_offset : Vector2 = Vector2(-15, 0)

onready var buttons_container : VBoxContainer = $Options
onready var selection_arrow : Control = $SelectionArrow
onready var main_menu : HBoxContainer = $Title
onready var tween : = $Tween as Tween

var buttons = []
var selected_index : int

func _ready() -> void:
	buttons = buttons_container.get_children()
	selection_arrow.rect_global_position = _get_arrow_position()
	tween.interpolate_property(main_menu, 
		"rect_global_position", 
		Vector2(main_menu.rect_global_position.x, -100),
		main_menu.rect_global_position, 
		0.75, 
		Tween.TRANS_EXPO, 
		Tween.EASE_OUT)
	tween.start()


func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_up'):
		selected_index = max(selected_index - 1, 0)
		_move_arrow()
	elif event.is_action_pressed('ui_down'):
		selected_index = min(selected_index + 1, buttons.size() - 1)
		_move_arrow()
	elif event.is_action_pressed('ui_accept'):
		var path = buttons[selected_index].path
#		yield(_transition(), "completed")
		if path == '':
			get_tree().quit()
		else:
			get_tree().change_scene(path)


func _move_arrow() -> void:
	var move_to = _get_arrow_position(selected_index)
	tween.interpolate_property(selection_arrow, 
		"rect_global_position", 
		selection_arrow.rect_global_position, 
		move_to, 
		0.1, 
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()

#func _transition() -> void:
#	tween.interpolate_property(transition_overlay, 
#		"self_modulate", 
#		transition_overlay.self_modulate, 
#		Color('ff426894'), 
#		0.5, 
#		Tween.TRANS_QUART, 
#		Tween.EASE_OUT
#	)
#	tween.start()
#	yield(tween, 'tween_completed')

func _get_arrow_position(button_index : int = 0) -> Vector2:
	return Vector2(buttons[button_index].get_global_rect().position.x + arrow_offset.x, buttons[button_index].get_global_rect().position.y + arrow_offset.y)
