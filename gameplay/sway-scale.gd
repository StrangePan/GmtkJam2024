extends Node


@export var scaleNode: Scale
var _time: float = 0


func _physics_process(delta: float) -> void:
	_time += delta
	if (scaleNode):
		scaleNode.tilt = sin(_time / 3)
