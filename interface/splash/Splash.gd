extends Control

onready var tween : Tween = $Tween
onready var overlay : ColorRect = $Overlay

func _ready() -> void:
	tween.interpolate_property(overlay,
		"color",
		overlay.color,
		Color(0, 0, 0, 1),
		2.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		1.0)
	tween.start()
	yield(tween, "tween_completed")
	get_tree().change_scene("res://interface/MainMenu.tscn")
