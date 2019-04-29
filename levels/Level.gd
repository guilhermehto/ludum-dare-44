extends Node2D

signal won
signal failed
signal comboed(count)
signal combo_ended

onready var ui : CanvasLayer = $UI
onready var timer : Timer = $Timer
onready var player : Player = $Player
onready var spawners : Node2D = $Spawners
onready var combo_timer : Timer = $ComboTimer

export var level_time := 60.0
export var persons_to_punish := 27
export var combo_breaker_time := 1.25

var punished_persons := 0.0
var combo := 0


func _ready() -> void:
	timer.wait_time = level_time
	combo_timer.wait_time = combo_breaker_time
	timer.start()
	ui.initialize(level_time, persons_to_punish)
	for spawner in spawners.get_children():
		spawner.connect("spawned", self, "_on_Spawner_spawned")



func _on_Timer_timeout() -> void:
	emit_signal("failed")


func _on_Person_punished() -> void:
	combo += 1
	if combo > 1:
		emit_signal("comboed", combo)
	punished_persons += 1
	combo_timer.stop()
	combo_timer.start()
	ui.punished_count += 1
	if punished_persons == persons_to_punish:
		emit_signal("won")
		timer.stop()


func _on_Spawner_spawned(person) -> void:
		person.initialize(player)
		person.connect("punished", self, "_on_Person_punished")


func _on_ComboTimer_timeout() -> void:
	combo = 0
	combo_timer.stop()
	emit_signal("combo_ended")
