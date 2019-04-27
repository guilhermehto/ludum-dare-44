extends Node2D

signal won
signal failed

onready var timer : Timer = $Timer
onready var player : Player = $Player
onready var persons : Node2D = $Persons

export var level_time := 60.0
export var persons_to_punish := 27

var punished_persons := 0.0
var time_since_last_punishment := 0


func _ready() -> void:
	timer.wait_time = level_time
	timer.start()
	for person in persons.get_children():
		person.initialize(player)
		person.connect("punished", self, "_on_Person_punished")


func _process(delta: float) -> void:
	time_since_last_punishment += delta


func _on_Timer_timeout() -> void:
	emit_signal("failed")


func _on_Person_punished() -> void:
	time_since_last_punishment = 0
	punished_persons += 1
	if punished_persons == persons_to_punish:
		emit_signal("won")
		timer.stop()
