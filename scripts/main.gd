extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight

var camera_distance := 8.0
var camera_angle := 35.264  # isometric angle (atan(1/sqrt(2)))
var camera_rotation := 45.0  # Y-axis rotation


func _ready() -> void:
	print("GameOne started - Milestone 1")
	_update_camera()


func _update_camera() -> void:
	var target := knight.global_position if knight else Vector3.ZERO
	var rot_rad := deg_to_rad(camera_rotation)
	var pitch_rad := deg_to_rad(camera_angle)

	var offset := Vector3(
		sin(rot_rad) * cos(pitch_rad),
		sin(pitch_rad),
		cos(rot_rad) * cos(pitch_rad)
	) * camera_distance

	camera.position = target + offset
	camera.look_at(target, Vector3.UP)


func _process(_delta: float) -> void:
	pass
