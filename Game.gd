extends Node

onready var ongoing_level : Node = $OngoingLevel

export var levels = []

var current_level := 0

func _ready() -> void:
	var level = levels[current_level].instance()
	level.connect("failed", self, "_on_Level_failed")
	level.connect("won", self, "_on_Level_won")
	ongoing_level.add_child(level)


func _on_Level_failed() -> void:
	#TODO: Show failed animation and restart button
	get_tree().reload_current_scene()


func _on_Level_won() -> void:
	#TODO: Save progress, show win message
	current_level += 1
	start_next_level()


func start_next_level() -> void:
	var level = levels[current_level].instance()
	level.connect("failed", self, "_on_Level_failed")
	level.connect("won", self, "_on_Level_won")
	ongoing_level.get_child(0).queue_free()
	ongoing_level.add_child(level)
