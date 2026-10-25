extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight
const HexGridScript = preload("res://scripts/hex_grid.gd")
const AbilityUIScript = preload("res://scripts/ability_ui.gd")
const CombatManagerScript = preload("res://scripts/combat_manager.gd")
const CombatUIScript = preload("res://scripts/combat_ui.gd")

@onready var hex_grid: HexGridScript = $HexGrid
@onready var ability_ui: AbilityUIScript = $AbilityUI

var camera_distance := 14.0
var camera_angle := 40.0
var camera_rotation := 45.0

var knight_coord := Vector2i.ZERO
var move_path: Array[Vector2i] = []
var move_index: int = 0
var is_moving: bool = false
var move_speed := 4.0

var combat_manager: CombatManagerScript = null
var combat_ui: CombatUIScript = null
var enemies := {}

var encounter_active := false
var in_combat_view := false
var prev_knight_coord := Vector2i.ZERO
var saved_knight_pos := Vector3.ZERO
var combat_enemy_coord := Vector2i.ZERO
var arena_grid: HexGridScript = null


func _ready() -> void:
	print("GameOne started - Milestone 5: Combat Arena")
	_setup_character()
	_setup_combat()
	_spawn_enemies()
	_place_knight_on_grid()
	ability_ui.ability_used.connect(_on_ability_used)
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


func _setup_combat() -> void:
	combat_manager = CombatManagerScript.new()
	combat_manager.name = "CombatManager"
	add_child(combat_manager)
	combat_manager.combat_started.connect(_on_combat_started)
	combat_manager.combat_ended.connect(_on_combat_ended)
	combat_manager.hp_changed.connect(_on_hp_changed)
	combat_manager.turn_changed.connect(_on_turn_changed)
	combat_manager.action_performed.connect(_on_action_performed)

	combat_ui = CombatUIScript.new()
	combat_ui.name = "CombatUI"
	add_child(combat_ui)
	combat_ui.encounter_choice.connect(_on_encounter_choice)


func _spawn_enemies() -> void:
	var enemy_scene: PackedScene = load("res://assets/models/kaykit/characters/Barbarian.glb")
	var spawn_coords: Array[Vector2i] = hex_grid.get_walkable_coords(true, 3)
	spawn_coords.shuffle()
	var count: int = mini(3, spawn_coords.size())
	for i in count:
		var coord: Vector2i = spawn_coords[i]
		var enemy: Node3D = enemy_scene.instantiate()
		enemy.name = "Enemy_%d" % i
		enemy.position = hex_grid.get_cell_world_pos(coord)
		add_child(enemy)
		enemies[coord] = enemy


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


func _update_camera_arena() -> void:
	var target := Vector3(0.0, 0.1, 0.0)
	var rot_rad := deg_to_rad(camera_rotation)
	var pitch_rad := deg_to_rad(camera_angle)
	var offset := Vector3(
		sin(rot_rad) * cos(pitch_rad),
		sin(pitch_rad),
		cos(rot_rad) * cos(pitch_rad)
	) * 8.0
	camera.position = target + offset
	camera.look_at(target, Vector3.UP)


func _unhandled_input(event: InputEvent) -> void:
	if is_moving or combat_manager.in_combat or encounter_active:
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
	if in_combat_view:
		_update_camera_arena()
	else:
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
			if move_path.size() >= 2:
				prev_knight_coord = move_path[move_path.size() - 2]
			else:
				prev_knight_coord = knight_coord
			knight_coord = move_path[move_path.size() - 1]
			knight.play_animation("Idle_A")
			move_path = []
			_check_encounter()
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


func _check_encounter() -> void:
	if enemies.has(knight_coord):
		encounter_active = true
		combat_enemy_coord = knight_coord
		combat_ui.show_encounter()


func _on_encounter_choice(fight: bool) -> void:
	encounter_active = false
	combat_ui.hide_encounter()
	if fight:
		_enter_combat_view()
	else:
		knight_coord = prev_knight_coord
		knight.position = hex_grid.get_cell_world_pos(prev_knight_coord)


func _enter_combat_view() -> void:
	in_combat_view = true
	saved_knight_pos = knight.position

	hex_grid.visible = false
	for key in enemies:
		var e: Node3D = enemies[key]
		if key != combat_enemy_coord:
			e.visible = false

	arena_grid = HexGridScript.new()
	arena_grid.name = "ArenaGrid"
	arena_grid.grid_radius = 2
	arena_grid.hex_size = 1.0
	arena_grid.hex_height = 0.2
	arena_grid.arena_mode = true
	add_child(arena_grid)

	var knight_pos: Vector3 = arena_grid.get_cell_world_pos(Vector2i(-2, 1))
	knight.position = knight_pos

	var enemy: Node3D = enemies[combat_enemy_coord]
	var enemy_pos: Vector3 = arena_grid.get_cell_world_pos(Vector2i(2, -1))
	enemy.position = enemy_pos

	knight.look_at(enemy.global_position, Vector3.UP)
	knight.rotate_y(PI)
	enemy.look_at(knight.global_position, Vector3.UP)

	combat_manager.start_combat(enemy, 60, 12)


func _exit_combat_view(player_won: bool) -> void:
	combat_ui.hide_combat()

	if arena_grid:
		arena_grid.queue_free()
		arena_grid = null

	if player_won:
		var enemy: Node3D = combat_manager.enemy_node
		enemy.queue_free()
		enemies.erase(combat_enemy_coord)
	else:
		get_tree().reload_current_scene()
		return

	hex_grid.visible = true
	for key in enemies:
		var e: Node3D = enemies[key]
		e.visible = true

	knight.position = hex_grid.get_cell_world_pos(knight_coord)
	knight.play_animation("Idle_A")
	in_combat_view = false


func _on_ability_used(anim_name: String) -> void:
	if encounter_active:
		return
	if combat_manager.in_combat:
		if combat_manager.is_player_turn:
			combat_manager.player_action(anim_name)
	else:
		knight.play_animation(anim_name)


func _on_combat_started() -> void:
	combat_ui.show_combat()


func _on_combat_ended(player_won: bool) -> void:
	combat_ui.show_result(player_won)
	await get_tree().create_timer(2.0).timeout
	_exit_combat_view(player_won)


func _on_hp_changed(who: String, current: int, max_hp: int) -> void:
	combat_ui.update_hp(who, current, max_hp)


func _on_turn_changed(is_player_turn: bool) -> void:
	combat_ui.update_turn(is_player_turn)


func _on_action_performed(who: String, _action: String, damage: int) -> void:
	combat_ui.show_action(who, damage)
	if who == "player":
		knight.play_animation("Throw")
	else:
		knight.play_animation("Hit_A")
