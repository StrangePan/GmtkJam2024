class_name Kernel
extends Node3D

signal kernel_popped
signal kernel_burned

@onready var _popcornScene := preload("res://gameplay/popcorn.tscn")
@export_range(0, 10, 0.25, "The number of seconds required to pop or burn") var cookTime: float = 4
@export_range(0, 10, 0.25, "The amount of allowed random variation inc ook time") var cookTimeVariation: float = 2
@export_range(0, 1, 0.01, "The threshold that the kernel will start to cook") var cookThreshold: float = -0.05
@export_range(0, 1, 0.01, "The threshold that the kernel will start to burn") var burnThreshold: float = 0.2
@export_range(0, 1, 0.01, "The maximum amount of allowable burnage") var acceptableBurnedPercentage: float = 0.5

@export_range(0, 100, 0.5, "The speed at which to pop") var popVelocity: float = 5

var _timeCooked: float = 0
var _timeBurned: float = 0
var _scale: Scale
var _side: Scale.Side
@onready var _cookTime: float = cookTime + randf() * cookTimeVariation


func initialize(start_position: Vector3, scale: Scale, side: Scale.Side) -> void:
	global_position = start_position
	_scale = scale
	_side = side


func _physics_process(delta: float) -> void:
	var tilt := _scale.tilt
	if (_side == Scale.Side.Left):
		if (tilt < -cookThreshold):
			_timeCooked += delta
		if (tilt < -burnThreshold):
			_timeBurned += delta
	if (_side == Scale.Side.Right):
		if (tilt >= cookThreshold):
			_timeCooked += delta
		if (tilt >= burnThreshold):
			_timeBurned += delta
	if (_timeCooked >= _cookTime or _timeBurned >= _cookTime):
		if (_timeBurned / _cookTime < acceptableBurnedPercentage):
			pop()
		else:
			burn()


func pop() -> void:
	var popcorn := _popcornScene.instantiate()
	self.add_sibling(popcorn)
	popcorn.global_position = global_position
	if (_side == Scale.Side.Left):
		popcorn.apply_impulse(Vector3(-popVelocity / 4, popVelocity, 0))
	else:
		popcorn.apply_impulse(Vector3(popVelocity / 4, popVelocity, 0))
	kernel_popped.emit()
	self.queue_free()


func burn() -> void:
	kernel_burned.emit()
	self.queue_free()
