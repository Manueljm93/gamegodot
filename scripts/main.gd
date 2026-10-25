extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var knight: Node3D = $Knight
const HexGridScript = preload("res://scripts/hex_grid.gd")
const AbilityUIScript = preload("res://scripts/ability_ui.gd")
const CombatManagerScript = preload("res://scripts/combat_manager.gd")
const CombatUIScript = preload("res://scripts/combat_ui.gd")
const ResourceManagerScript = preload("res://scripts/resource_manager.gd")
const HUDScript = preload("res://scripts/hud.gd")
const TownUIScript = preload("res://scripts/town_ui.gd")
const ArmyStackScript = preload("res://scripts/army_stack.gd")

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
var resource_manager: ResourceManagerScript = null
var hud: HUDScript = null
var town_ui: TownUIScript = null
var enemies := {}
var player_army: Array = []
var arena_player_nodes: Array[Node3D] = []
var arena_enemy_nodes: Array[Node3D] = []
var arena_enemy_map := {}

var encounter_active := false
var in_combat_view := false
var town_menu_open := false
var prev_knight_coord := Vector2i.ZERO
var saved_knight_pos := Vector3.ZERO
var combat_enemy_coord := Vector2i.ZERO
var arena_grid: HexGridScript = null
var town_building_chosen := false

const TOWN_COORD := Vector2i.ZERO
const BUILDING_OFFSETS := {
	"barracks": Vector3(0.5, 0.0, -0.4),
	"guard_tower": Vector3(-0.5, 0.0, -0.4),
	"gold_mine": Vector3(0.0, 0.0, 0.5),
}
const ARENA_PLAYER_HEXES := [Vector2i(-1, 0), Vector2i(-1, 1)]
const ARENA_ENEMY_HEXES := [Vector2i(1, 0), Vector2i(1, -1)]
const ARENA_HERO_HEX := Vector2i(-2, 1)


func _ready() -> void:
	print("GameOne started - Milestone 7: Army Stacks")
	_setup_character()
	_init_player_army()
	_setup_resources()
	_setup_combat()
	_setup_town()
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


func _init_player_army() -> void:
	var swordsmen: ArmyStackScript = ArmyStackScript.new()
	swordsmen.setup("swordsman", "Swordsmen", 5, 10, 5, 3, 2, 4, 4, Color(0.3, 0.5, 0.8))
	var archers: ArmyStackScript = ArmyStackScript.new()
	archers.setup("archer", "Archers", 3, 8, 4, 2, 3, 5, 6, Color(0.4, 0.7, 0.3))
	player_army = [swordsmen, archers]


func _setup_resources() -> void:
	resource_manager = ResourceManagerScript.new()
	resource_manager.name = "ResourceManager"
	add_child(resource_manager)
	resource_manager.gold_changed.connect(_on_gold_changed)
	resource_manager.day_changed.connect(_on_day_changed)

	hud = HUDScript.new()
	hud.name = "HUD"
	add_child(hud)
	hud.end_turn_pressed.connect(_on_end_turn)
	hud.update_gold(resource_manager.gold, resource_manager.gold_income)


func _setup_combat() -> void:
	combat_manager = CombatManagerScript.new()
	combat_manager.name = "CombatManager"
	add_child(combat_manager)
	combat_manager.combat_started.connect(_on_combat_started)
	combat_manager.combat_ended.connect(_on_combat_ended)
	combat_manager.turn_started.connect(_on_turn_started)
	combat_manager.attack_done.connect(_on_attack_done)

	combat_ui = CombatUIScript.new()
	combat_ui.name = "CombatUI"
	add_child(combat_ui)
	combat_ui.encounter_choice.connect(_on_encounter_choice)


func _setup_town() -> void:
	town_ui = TownUIScript.new()
	town_ui.name = "TownUI"
	add_child(town_ui)
	town_ui.building_requested.connect(_on_building_requested)
	town_ui.close_requested.connect(_on_town_close)


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
	knight_coord = TOWN_COORD
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
	if is_moving or encounter_active or town_menu_open:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			if combat_manager.in_combat:
				_handle_combat_click(mb.position)
			else:
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
		if target == TOWN_COORD:
			_open_town_menu()
		return
	var path: Array[Vector2i] = hex_grid.find_path(knight_coord, target)
	if path.is_empty():
		return
	move_path = path
	move_index = 0
	is_moving = true
	knight.play_animation("Walking", true)


func _handle_combat_click(screen_pos: Vector2) -> void:
	if not combat_manager.is_player_turn:
		return
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
	var coord: Vector2i = collider.get_meta("coord")
	if arena_enemy_map.has(coord):
		var idx: int = arena_enemy_map[coord]
		combat_manager.player_attack(idx)


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


# --- Town ---

func _open_town_menu() -> void:
	town_menu_open = true
	town_ui.show_menu(resource_manager.gold, town_building_chosen)


func _on_town_close() -> void:
	town_menu_open = false
	town_ui.hide_menu()


func _on_building_requested(building_name: String) -> void:
	if town_building_chosen:
		return
	var cost: int = _get_building_cost(building_name)
	if not resource_manager.spend_gold(cost):
		return
	town_ui.mark_built(building_name)
	town_building_chosen = true
	_place_building_visual(building_name)
	town_ui.show_menu(resource_manager.gold, town_building_chosen)
	if building_name == "gold_mine":
		resource_manager.gold_income += 50


func _get_building_cost(building_name: String) -> int:
	match building_name:
		"barracks":
			return 200
		"guard_tower":
			return 150
		"gold_mine":
			return 300
	return 0


func _on_end_turn() -> void:
	if combat_manager.in_combat or encounter_active or is_moving or town_menu_open:
		return
	resource_manager.end_turn()


func _place_building_visual(building_name: String) -> void:
	if not BUILDING_OFFSETS.has(building_name):
		return
	var town_pos: Vector3 = hex_grid.get_cell_world_pos(TOWN_COORD)
	var offset: Vector3 = BUILDING_OFFSETS[building_name]

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Building_" + building_name
	var mat := StandardMaterial3D.new()
	mat.roughness = 0.7

	match building_name:
		"barracks":
			var box := BoxMesh.new()
			box.size = Vector3(0.4, 0.5, 0.4)
			mesh_instance.mesh = box
			mat.albedo_color = Color(0.7, 0.25, 0.2)
			offset.y = town_pos.y + 0.25
		"guard_tower":
			var cyl := CylinderMesh.new()
			cyl.top_radius = 0.15
			cyl.bottom_radius = 0.2
			cyl.height = 0.8
			mesh_instance.mesh = cyl
			mat.albedo_color = Color(0.3, 0.4, 0.7)
			offset.y = town_pos.y + 0.4
		"gold_mine":
			var box := BoxMesh.new()
			box.size = Vector3(0.4, 0.35, 0.4)
			mesh_instance.mesh = box
			mat.albedo_color = Color(0.85, 0.7, 0.2)
			offset.y = town_pos.y + 0.18

	mesh_instance.material_override = mat
	mesh_instance.position = Vector3(town_pos.x + offset.x, offset.y, town_pos.z + offset.z)
	add_child(mesh_instance)


func _on_gold_changed(amount: int, income: int) -> void:
	hud.update_gold(amount, income)


func _on_day_changed(day: int) -> void:
	hud.update_day(day)


# --- Encounter & Combat ---

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
	hud.visible = false

	hex_grid.visible = false
	for key in enemies:
		var e: Node3D = enemies[key]
		e.visible = false

	arena_grid = HexGridScript.new()
	arena_grid.name = "ArenaGrid"
	arena_grid.grid_radius = 2
	arena_grid.hex_size = 1.0
	arena_grid.hex_height = 0.2
	arena_grid.arena_mode = true
	add_child(arena_grid)

	var hero_pos: Vector3 = arena_grid.get_cell_world_pos(ARENA_HERO_HEX)
	knight.position = hero_pos

	var enemy_army: Array = _create_enemy_army()

	arena_player_nodes.clear()
	for i in player_army.size():
		var stack: ArmyStackScript = player_army[i]
		if i < ARENA_PLAYER_HEXES.size():
			var coord: Vector2i = ARENA_PLAYER_HEXES[i]
			var pos: Vector3 = arena_grid.get_cell_world_pos(coord)
			var node: Node3D = _create_stack_visual(stack, pos)
			if not stack.is_alive():
				node.visible = false
			arena_player_nodes.append(node)

	arena_enemy_nodes.clear()
	arena_enemy_map.clear()
	for i in enemy_army.size():
		var stack: ArmyStackScript = enemy_army[i]
		if i < ARENA_ENEMY_HEXES.size():
			var coord: Vector2i = ARENA_ENEMY_HEXES[i]
			var pos: Vector3 = arena_grid.get_cell_world_pos(coord)
			var node: Node3D = _create_stack_visual(stack, pos)
			arena_enemy_nodes.append(node)
			arena_enemy_map[coord] = i

	var look_target: Vector3 = arena_grid.get_cell_world_pos(Vector2i.ZERO)
	look_target.y = knight.position.y
	knight.look_at(look_target, Vector3.UP)
	knight.rotate_y(PI)

	combat_manager.start_combat(player_army, enemy_army)


func _create_enemy_army() -> Array:
	var goblins: ArmyStackScript = ArmyStackScript.new()
	goblins.setup("goblin", "Goblins", 4, 6, 3, 1, 1, 3, 5, Color(0.3, 0.5, 0.2))
	var wolves: ArmyStackScript = ArmyStackScript.new()
	wolves.setup("wolf", "Wolves", 2, 12, 4, 2, 3, 5, 8, Color(0.55, 0.5, 0.55))
	return [goblins, wolves]


func _create_stack_visual(stack: ArmyStackScript, pos: Vector3) -> Node3D:
	var node := Node3D.new()
	node.position = pos

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.35, 0.45, 0.35)
	mesh.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = stack.color
	mat.roughness = 0.7
	mesh.material_override = mat
	mesh.position.y = 0.23
	node.add_child(mesh)

	var label := Label3D.new()
	label.text = "%d" % stack.count
	label.font_size = 64
	label.pixel_size = 0.01
	label.position = Vector3(0, 0.7, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.modulate = Color.WHITE
	label.outline_modulate = Color.BLACK
	label.outline_size = 12
	node.add_child(label)

	add_child(node)
	return node


func _update_arena_stack_visuals() -> void:
	for i in arena_player_nodes.size():
		var node: Node3D = arena_player_nodes[i]
		if i < combat_manager.player_army.size():
			var stack: ArmyStackScript = combat_manager.player_army[i]
			if stack.is_alive():
				var label: Label3D = node.get_child(1) as Label3D
				label.text = "%d" % stack.count
			else:
				node.visible = false
	for i in arena_enemy_nodes.size():
		var node: Node3D = arena_enemy_nodes[i]
		if i < combat_manager.enemy_army.size():
			var stack: ArmyStackScript = combat_manager.enemy_army[i]
			if stack.is_alive():
				var label: Label3D = node.get_child(1) as Label3D
				label.text = "%d" % stack.count
			else:
				node.visible = false


func _exit_combat_view(player_won: bool) -> void:
	combat_ui.hide_combat()

	for node: Node3D in arena_player_nodes:
		node.queue_free()
	arena_player_nodes.clear()
	for node: Node3D in arena_enemy_nodes:
		node.queue_free()
	arena_enemy_nodes.clear()
	arena_enemy_map.clear()

	if arena_grid:
		arena_grid.queue_free()
		arena_grid = null

	if player_won:
		var enemy: Node3D = enemies[combat_enemy_coord]
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
	hud.visible = true


func _on_ability_used(anim_name: String) -> void:
	if encounter_active or town_menu_open or combat_manager.in_combat:
		return
	knight.play_animation(anim_name)


func _on_combat_started() -> void:
	combat_ui.show_combat(combat_manager.player_army, combat_manager.enemy_army)


func _on_combat_ended(player_won: bool) -> void:
	combat_ui.show_result(player_won)
	await get_tree().create_timer(2.0).timeout
	_exit_combat_view(player_won)


func _on_turn_started(side: String, stack_index: int) -> void:
	var stack: ArmyStackScript = combat_manager.get_army_stack(side, stack_index)
	combat_ui.update_turn(side, stack.unit_label)


func _on_attack_done(atk_side: String, _atk_idx: int, def_side: String, def_idx: int, damage: int, kills: int) -> void:
	var target: ArmyStackScript = combat_manager.get_army_stack(def_side, def_idx)
	combat_ui.show_attack(damage, kills, target.unit_label)
	combat_ui.refresh_stacks(combat_manager.player_army, combat_manager.enemy_army)
	_update_arena_stack_visuals()
	if atk_side == "player":
		knight.play_animation("Throw")
	else:
		knight.play_animation("Hit_A")
