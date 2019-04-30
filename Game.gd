extends Node

signal level_ended(won, level_time)

onready var ongoing_level : Node = $OngoingLevel

export var levels = []
export var end_game_menu : PackedScene

var current_level := 0
var biggest_combo := 0
var game_time := 0.0
var current_level_time := 0.0
var active := false

func _ready() -> void:
	var level = levels[current_level].instance()
	level.connect("failed", self, "_on_Level_failed")
	level.connect("won", self, "_on_Level_won")
	level.connect("comboed", self, "_on_Level_comboed")
	ongoing_level.add_child(level)
	active = true


func _process(delta: float) -> void:
	if active:
		game_time += delta
		current_level_time += delta


func _on_Level_failed() -> void:
	emit_signal("level_ended", false, current_level_time)
	active = false
	ongoing_level.get_child(0).queue_free()


func _on_Level_won() -> void:
	emit_signal("level_ended", true, current_level_time)
	active = false
	ongoing_level.get_child(0).queue_free()


func _on_Level_comboed(count: int) -> void:
	biggest_combo = max(count, biggest_combo)

func _on_TransitionMenu_next_level_requested() -> void:
	current_level += 1
	if current_level < levels.size():
		start_next_level()
	else:
		var menu = end_game_menu.instance()
		add_child(menu)
		menu.initialize(biggest_combo, game_time)


func _on_TransitionMenu_restart_requested() -> void:
	start_next_level()


func start_next_level() -> void:
	var level = levels[current_level].instance()
	level.connect("failed", self, "_on_Level_failed")
	level.connect("won", self, "_on_Level_won")
	level.connect("comboed", self, "_on_Level_comboed")
	if ongoing_level.get_child_count() > 0:
		ongoing_level.get_child(0).queue_free()
	ongoing_level.add_child(level)
	current_level_time = 0.0
	active = true
