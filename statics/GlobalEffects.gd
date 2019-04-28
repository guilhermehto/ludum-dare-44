extends Node

const FRAME_FREEZE_DEFAULT_DURATION := 30

func frame_freeze(duration: float = FRAME_FREEZE_DEFAULT_DURATION) -> void:
	OS.delay_msec(duration)
