class_name Scale
extends Node3D


@onready var _leftSpawnPoint := $scale/Armature/Skeleton3D/Plane_010/Plane_010/LeftScaleSpawn
@onready var _rightSpawnPoint := $scale/Armature/Skeleton3D/BezierCircle_001/BezierCircle_001/RightScaleSpawn
@onready var _leftKernelArea := $scale/Armature/Skeleton3D/Plane_010/Plane_010/LeftScaleLKernelArea
@onready var _rightKernelArea := $scale/Armature/Skeleton3D/BezierCircle_001/BezierCircle_001/RightScaleKernelArea
@onready var _kernelScene := preload("res://gameplay/kernel.tscn")

@onready var animation := $AnimationPlayer as AnimationPlayer

@export_range(-1, 1, 0.001, "the amount of tilt on the scale") var tilt: float = 0: set = set_tilt


func set_tilt(value: float) -> void:
	tilt = value
	if (animation):
		animation.seek(clampf((value + 1) / 2 * animation.current_animation_length, 0, animation.current_animation_length), true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("tilt-scales", -1, 0)


func spawnLeftKernel() -> void:
	var kernel := _kernelScene.instantiate()
	add_child(kernel)
	kernel.initialize(_leftSpawnPoint.global_position)


func spawnRightKernel() -> void:
	var kernel := _kernelScene.instantiate()
	add_child(kernel)
	kernel.initialize(_rightSpawnPoint.global_position)


func countLeftKernels() -> int:
	return _leftKernelArea.get_overlapping_bodies().size()


func countRightKernels() -> int:
	return _rightKernelArea.get_overlapping_bodies().size()
