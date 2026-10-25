extends Node3D
## Generates a hexagonal grid in 3D space using flat-top hexagons.
## Uses axial coordinates (q, r) internally.

@export var grid_radius := 5
@export var hex_size := 1.0
@export var hex_height := 0.3

var cells := {}  # Dictionary[Vector2i, HexCell]

const TERRAIN_TYPES := {
	"grass": Color(0.35, 0.65, 0.3),
	"forest": Color(0.2, 0.45, 0.2),
	"water": Color(0.25, 0.5, 0.75),
	"mountain": Color(0.55, 0.5, 0.45),
	"sand": Color(0.85, 0.78, 0.55),
	"path": Color(0.6, 0.55, 0.4),
}


func _ready() -> void:
	generate_grid()


func generate_grid() -> void:
	_clear_grid()
	for q in range(-grid_radius, grid_radius + 1):
		var r_min: int = maxi(-grid_radius, -q - grid_radius)
		var r_max: int = mini(grid_radius, -q + grid_radius)
		for r in range(r_min, r_max + 1):
			var coord := Vector2i(q, r)
			var terrain := _pick_terrain(coord)
			var cell := _create_hex_cell(coord, terrain)
			cells[coord] = cell


func axial_to_world(coord: Vector2i) -> Vector3:
	var q := float(coord.x)
	var r := float(coord.y)
	var x := hex_size * (3.0 / 2.0 * q)
	var z := hex_size * (sqrt(3.0) / 2.0 * q + sqrt(3.0) * r)
	return Vector3(x, 0, z)


func world_to_axial(world_pos: Vector3) -> Vector2i:
	var q := (2.0 / 3.0 * world_pos.x) / hex_size
	var r := (-1.0 / 3.0 * world_pos.x + sqrt(3.0) / 3.0 * world_pos.z) / hex_size
	return _axial_round(q, r)


func get_neighbors(coord: Vector2i) -> Array[Vector2i]:
	var directions: Array[Vector2i] = [
		Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1),
		Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, 1),
	]
	var result: Array[Vector2i] = []
	for d: Vector2i in directions:
		var neighbor: Vector2i = coord + d
		if cells.has(neighbor):
			result.append(neighbor)
	return result


func get_cell_world_pos(coord: Vector2i) -> Vector3:
	var pos := axial_to_world(coord)
	pos.y = hex_height / 2.0
	return pos


func is_walkable(coord: Vector2i) -> bool:
	if not cells.has(coord):
		return false
	var cell: Node3D = cells[coord]
	var terrain: String = cell.get_meta("terrain")
	return terrain != "water" and terrain != "mountain"


func find_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if not cells.has(from) or not cells.has(to):
		return []
	if not is_walkable(to):
		return []
	var frontier: Array[Vector2i] = [from]
	var came_from := {}
	came_from[from] = from
	while frontier.size() > 0:
		var current: Vector2i = frontier[0]
		frontier.remove_at(0)
		if current == to:
			break
		for neighbor: Vector2i in get_neighbors(current):
			if not came_from.has(neighbor) and is_walkable(neighbor):
				frontier.append(neighbor)
				came_from[neighbor] = current
	if not came_from.has(to):
		return []
	var path: Array[Vector2i] = []
	var trace: Vector2i = to
	while trace != from:
		path.append(trace)
		trace = came_from[trace]
	path.reverse()
	return path


func _create_hex_cell(coord: Vector2i, terrain: String) -> Node3D:
	var cell := Node3D.new()
	cell.name = "Hex_%d_%d" % [coord.x, coord.y]

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = _create_hex_mesh()

	var mat := StandardMaterial3D.new()
	mat.albedo_color = TERRAIN_TYPES.get(terrain, Color.WHITE)
	mat.roughness = 0.85
	mesh_instance.material_override = mat

	cell.add_child(mesh_instance)

	var body := StaticBody3D.new()
	body.set_meta("coord", coord)
	var col_shape := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = hex_size * 0.9
	shape.height = hex_height
	col_shape.shape = shape
	body.add_child(col_shape)
	cell.add_child(body)

	cell.position = axial_to_world(coord)

	cell.set_meta("coord", coord)
	cell.set_meta("terrain", terrain)

	add_child(cell)
	return cell


func _create_hex_mesh() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var top_y := hex_height / 2.0
	var bot_y := -hex_height / 2.0
	var verts_top: Array[Vector3] = []
	var verts_bot: Array[Vector3] = []

	for i in 6:
		var angle := deg_to_rad(60.0 * i)
		var x := hex_size * cos(angle) * 0.95
		var z := hex_size * sin(angle) * 0.95
		verts_top.append(Vector3(x, top_y, z))
		verts_bot.append(Vector3(x, bot_y, z))

	# Top face
	var center_top := Vector3(0, top_y, 0)
	for i in 6:
		st.set_normal(Vector3.UP)
		st.add_vertex(center_top)
		st.set_normal(Vector3.UP)
		st.add_vertex(verts_top[i])
		st.set_normal(Vector3.UP)
		st.add_vertex(verts_top[(i + 1) % 6])

	# Side faces
	for i in 6:
		var next := (i + 1) % 6
		var side_normal := (verts_top[i] + verts_top[next]).normalized()
		side_normal.y = 0
		side_normal = side_normal.normalized()

		st.set_normal(side_normal)
		st.add_vertex(verts_top[i])
		st.set_normal(side_normal)
		st.add_vertex(verts_bot[i])
		st.set_normal(side_normal)
		st.add_vertex(verts_top[next])

		st.set_normal(side_normal)
		st.add_vertex(verts_top[next])
		st.set_normal(side_normal)
		st.add_vertex(verts_bot[i])
		st.set_normal(side_normal)
		st.add_vertex(verts_bot[next])

	# Bottom face
	var center_bot := Vector3(0, bot_y, 0)
	for i in 6:
		st.set_normal(Vector3.DOWN)
		st.add_vertex(center_bot)
		st.set_normal(Vector3.DOWN)
		st.add_vertex(verts_bot[(i + 1) % 6])
		st.set_normal(Vector3.DOWN)
		st.add_vertex(verts_bot[i])

	st.generate_tangents()
	return st.commit()


func _pick_terrain(coord: Vector2i) -> String:
	var dist := _axial_distance(coord, Vector2i.ZERO)
	var noise_val := sin(coord.x * 0.7 + coord.y * 1.3) * 0.5 + 0.5

	if dist <= 1:
		return "path"
	elif noise_val < 0.15:
		return "water"
	elif noise_val < 0.35:
		return "sand"
	elif noise_val < 0.6:
		return "grass"
	elif noise_val < 0.8:
		return "forest"
	else:
		return "mountain"


func _axial_distance(a: Vector2i, b: Vector2i) -> int:
	var diff := a - b
	return (abs(diff.x) + abs(diff.x + diff.y) + abs(diff.y)) / 2


func _axial_round(fq: float, fr: float) -> Vector2i:
	var fs: float = -fq - fr
	var rq: int = roundi(fq)
	var rr: int = roundi(fr)
	var rs: int = roundi(fs)
	var q_diff: float = absf(float(rq) - fq)
	var r_diff: float = absf(float(rr) - fr)
	var s_diff: float = absf(float(rs) - fs)
	if q_diff > r_diff and q_diff > s_diff:
		rq = -rr - rs
	elif r_diff > s_diff:
		rr = -rq - rs
	return Vector2i(rq, rr)


func _clear_grid() -> void:
	for child in get_children():
		child.queue_free()
	cells.clear()
