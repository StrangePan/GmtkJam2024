class_name Popcorn
extends Node3D


var popped := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func pop() -> void:
	if (popped):
		return
	popped = true
	transform.scaled(Vector3(5, 5, 5))


func initialize(start_position: Vector3) -> void:
	global_position = start_position
