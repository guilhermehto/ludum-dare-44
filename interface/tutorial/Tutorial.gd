extends Node

onready var texture_rect : TextureRect = $Control/TextureRect

const TEXTURES := [
	preload("res://assets/sprites/tutorial/tut-2.png"),
	preload("res://assets/sprites/tutorial/tut-3.png")
]

var index := 0

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("ui_accept"):
		if index < TEXTURES.size():
			texture_rect.texture = TEXTURES[index]
			index += 1
		else:
			get_tree().change_scene("res://Game.tscn")
