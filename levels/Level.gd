extends Node2D

signal won
signal failed

onready var ui : CanvasLayer = $UI
onready var timer : Timer = $Timer
onready var player : Player = $Player
onready var spawners : Node2D = $Spawners

export var level_time := 60.0
export var persons_to_punish := 27

var punished_persons := 0.0
var time_since_last_punishment := 0


func _ready() -> void:
	timer.wait_time = level_time
	timer.start()
	ui.initialize(level_time, persons_to_punish)
	for spawner in spawners.get_children():
		spawner.connect("spawned", self, "_on_Spawner_spawned")


func _process(delta: float) -> void:
	time_since_last_punishment += delta


func _on_Timer_timeout() -> void:
	emit_signal("failed")


func _on_Person_punished() -> void:
	time_since_last_punishment = 0
	punished_persons += 1
	ui.punished_count += 1
	if punished_persons == persons_to_punish:
		emit_signal("won")
		timer.stop()


func _on_Spawner_spawned(person) -> void:
		person.initialize(player)
		person.connect("punished", self, "_on_Person_punished")
