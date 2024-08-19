class_name Scale
extends Node3D


@onready var _leftPan := $scale/Armature/Skeleton3D/pan_001/pan_001/LeftPan
@onready var _rightPan := $scale/Armature/Skeleton3D/pan/pan/RightPan
@onready var _kernelScene := preload("res://gameplay/kernel.tscn")

@onready var animation := $AnimationPlayer as AnimationPlayer

@export_range(-1, 1, 0.001, "the amount of tilt on the scale") var tilt: float = 0: set = set_tilt


enum Side
{
	Left,
	Right,
}


func set_tilt(value: float) -> void:
	tilt = value
	if (animation):
		animation.seek(clampf((value + 1) / 2 * animation.current_animation_length, 0, animation.current_animation_length), true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("tilt-scales", -1, 0)


func _getPan(side: Scale.Side) -> Pan:
	if (side == Side.Left):
		return _leftPan
	if (side == Side.Right):
		return _rightPan
	else:
		push_error("Invalid side: " + str(side))
		return null


func spawnKernel(side: Scale.Side) -> Kernel:
	var kernel := _kernelScene.instantiate()
	add_child(kernel)
	kernel.initialize(_getPan(side).kernelSpawn.global_position, self, side)
	return kernel


func countKernels(side: Scale.Side) -> int:
	return _getPan(side).kernelArea.get_overlapping_bodies().size()
