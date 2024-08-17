extends Node

var leftWeight: int = 0
var rightWeight: int = 0
var angle: float = 0.0
@export var maxAngleDeviation: float = 20.0
@export var minAngleDeltaPerSecond: float = 0.01
@export var maxAngleDeltaPerSecond: float = 0.2
@export var angleDeltaEasing: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_angle: float = _calculate_target_angle()
	var angle_delta: float = (
		clampf(
			absf(angle - target_angle) / angleDeltaEasing, 
			minAngleDeltaPerSecond,
			maxAngleDeltaPerSecond) * delta)
	angle = move_toward(angle, target_angle, angle_delta)


func _calculate_balance() -> int:
	return leftWeight - rightWeight


func _calculate_target_angle() -> float:
	return clampf(float(_calculate_balance()), -maxAngleDeviation, maxAngleDeviation)
