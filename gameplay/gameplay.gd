extends Node

var leftWeight: int = 0
var rightWeight: int = 0
var angle: float = 0.0
@export var maxAngleDeviation: float = 1.0
@export var minAngleDeltaPerSecond: float = 0.01
@export var maxAngleDeltaPerSecond: float = 0.2
@export var angleDeltaEasing: float = 4
@export var scaleNode: Scale


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if (scaleNode):
		leftWeight = scaleNode.countLeftKernels()
		rightWeight = scaleNode.countRightKernels()

	var target_angle: float = _calculate_target_angle()
	var angle_delta: float = (
		clampf(
			absf(angle - target_angle) / angleDeltaEasing, 
			minAngleDeltaPerSecond,
			maxAngleDeltaPerSecond) * delta)
	angle = move_toward(angle, target_angle, angle_delta)

	if (scaleNode):
		scaleNode.tilt = angle


func _calculate_balance() -> int:
	return rightWeight - leftWeight


func _calculate_target_angle() -> float:
	return clampf(float(_calculate_balance()), -maxAngleDeviation, maxAngleDeviation)
