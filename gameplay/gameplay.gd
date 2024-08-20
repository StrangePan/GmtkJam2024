extends Node

var leftWeight: int = 0
var rightWeight: int = 0
var tilt: float = 0.0
@export var maxUnbalance: float = 20
@export var minTiltSpeed: float = 0.01
@export var maxTiltSpeed: float = 0.2
@export var tiltEasing: float = 2
@export var scaleNode: Scale

var _windTimeRemaining: float = 0
var _windCooldown: float = 6
var _windStrength: float = 0
var _timeElapsed: float = 0


func _physics_process(delta: float) -> void:
	_timeElapsed += delta
	_updateWind(delta)

	if (scaleNode):
		leftWeight = scaleNode.countKernels(Scale.Side.Left)
		rightWeight = scaleNode.countKernels(Scale.Side.Right)

	var target_tilt: float = _calculate_target_tilt()
	var angle_delta: float = (
		clampf(
			absf(tilt - target_tilt) / tiltEasing, 
			minTiltSpeed,
			maxTiltSpeed) * delta)
	tilt = move_toward(tilt, target_tilt, angle_delta)

	if (scaleNode):
		scaleNode.tilt = tilt


func _calculate_balance() -> int:
	return clamp(rightWeight - leftWeight, -maxUnbalance, maxUnbalance)


func _calculate_target_tilt() -> float:
	return clampf(float(_calculate_balance()) / float(maxUnbalance) + _windStrength, -1, 1)


func _updateWind(delta: float) -> void:
	if _windTimeRemaining > 0:
		_windTimeRemaining = max(0, _windTimeRemaining - delta)
		if _windTimeRemaining == 0:
			_windStrength = 0
			_windCooldown = randf_range(4, 8)
	else:
		_windCooldown = max(0, _windCooldown - delta)
		if _windCooldown == 0:
			_windTimeRemaining = randf_range(5, 10)
			_windStrength = randf_range(0.1 + max(_timeElapsed / 40, 0.1), 0.2 + max(_timeElapsed / 40, 0.2)) * (-1 if randf() < 0.5 else 1)
