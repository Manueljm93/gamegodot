extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight
const HexGridScript = preload("res://scripts/hex_grid.gd")
@onready var hex_grid: HexGridScript = $HexGrid

var camera_distance := 14.0
var camera_angle := 40.0
var camera_rotation := 45.0


func _ready() -> void:
	print("GameOne started - Milestone 3: Hex Grid")
	_setup_character()
	_place_knight_on_grid()
	_update_camera()


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


func _place_knight_on_grid() -> void:
	var center := Vector2i.ZERO
	var pos: Vector3 = hex_grid.get_cell_world_pos(center)
	knight.position = pos


func _update_camera() -> void:
	var target := knight.global_position
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
