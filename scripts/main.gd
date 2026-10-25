extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight
const HexGridScript = preload("res://scripts/hex_grid.gd")
@onready var hex_grid: HexGridScript = $HexGrid

var camera_distance := 14.0
var camera_angle := 40.0
var camera_rotation := 45.0

var knight_coord := Vector2i.ZERO
var move_path: Array[Vector2i] = []
var move_index: int = 0
var is_moving: bool = false
var move_speed := 4.0


func _ready() -> void:
	print("GameOne started - Milestone 4: Hex Movement")
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
	knight_coord = Vector2i.ZERO
	var pos: Vector3 = hex_grid.get_cell_world_pos(knight_coord)
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


func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			_handle_click(mb.position)


func _handle_click(screen_pos: Vector2) -> void:
	var origin := camera.project_ray_origin(screen_pos)
	var dir := camera.project_ray_normal(screen_pos)
	var end := origin + dir * 100.0
	var space := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := space.intersect_ray(query)
	if result.is_empty():
		return
	var collider: Node3D = result["collider"]
	if not collider.has_meta("coord"):
		return
	var target: Vector2i = collider.get_meta("coord")
	if target == knight_coord:
		return
	var path: Array[Vector2i] = hex_grid.find_path(knight_coord, target)
	if path.is_empty():
		return
	move_path = path
	move_index = 0
	is_moving = true
	knight.play_animation("Walking", true)


func _process(delta: float) -> void:
	if is_moving:
		_process_movement(delta)
	_update_camera()


func _process_movement(delta: float) -> void:
	var target_pos: Vector3 = hex_grid.get_cell_world_pos(move_path[move_index])
	var diff := target_pos - knight.position
	diff.y = 0.0
	var dist := diff.length()
	if dist < 0.05:
		knight.position = target_pos
		move_index += 1
		if move_index >= move_path.size():
			is_moving = false
			knight_coord = move_path[move_path.size() - 1]
			knight.play_animation("Idle_A")
			move_path = []
			return
	else:
		var step_dist := move_speed * delta
		if step_dist > dist:
			knight.position = target_pos
		else:
			knight.position += diff.normalized() * step_dist
		if diff.length() > 0.01:
			var look_target := knight.position + diff
			look_target.y = knight.position.y
			knight.look_at(look_target, Vector3.UP)
			knight.rotate_y(PI)
