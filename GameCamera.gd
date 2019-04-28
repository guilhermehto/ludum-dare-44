extends Camera2D

onready var timer : Timer = $Timer

export var default_amplitude := 2.0
export var shaking_duration := 0.3
export(float, EASE) var DAMP_EASING := 1.0

var shake := false setget set_shake
var amplitude := default_amplitude

func _ready() -> void:
	GlobalEvents.connect("shake_requested", self, "_on_shake_requested")
	randomize()
	set_process(false)
	timer.wait_time = shaking_duration


func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _on_ShakeTimer_timeout() -> void:
	self.shake = false


func _on_shake_requested(duration: float = shaking_duration, _amplitude: float = default_amplitude) -> void:
	timer.wait_time = duration
	amplitude = _amplitude
	self.shake = true


func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	offset = Vector2()
	if shake:
		timer.start()