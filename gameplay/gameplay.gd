extends Node

var leftWeight: int = 0
var rightWeight: int = 0
var tilt: float = 0.0
@export var maxUnbalance: float = 20
@export var minTiltSpeed: float = 0.01
@export var maxTiltSpeed: float = 0.2
@export var tiltEasing: float = 2
@export var scaleNode: Scale


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
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
	return clampf(float(_calculate_balance()) / float(maxUnbalance), -1, 1)
