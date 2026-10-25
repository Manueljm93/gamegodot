extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight

var camera_distance := 8.0
var camera_angle := 35.264
var camera_rotation := 45.0


func _ready() -> void:
	print("GameOne started - Milestone 2: Abilities")
	_update_camera()
	_setup_character()


func _setup_character() -> void:
	var char_script := preload("res://scripts/character.gd")
	knight.set_script(char_script)
	knight.initialize()

	var loader := preload("res://scripts/animation_loader.gd").new()
	loader.name = "AnimationLoader"
	loader.animation_scenes = [
		load("res://assets/models/kaykit/animations/Rig_Medium_General.glb"),
		load("res://assets/models/kaykit/animations/Rig_Medium_MovementBasic.glb"),
	]
	knight.add_child(loader)


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
