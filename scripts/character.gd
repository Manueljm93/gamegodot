extends Node3D
## Character controller: manages animations from external animation packs.

var anim_player: AnimationPlayer = null
var skeleton: Skeleton3D = null


func _ready() -> void:
	initialize()


func initialize() -> void:
	skeleton = _find_node_of_type(self, "Skeleton3D")
	anim_player = _find_node_of_type(self, "AnimationPlayer")

	if skeleton:
		print("Skeleton found: ", skeleton.get_path())
	else:
		print("WARNING: No Skeleton3D in character")

	if anim_player:
		print("AnimationPlayer found: ", anim_player.get_path())
	else:
		print("No AnimationPlayer, creating one...")
		anim_player = AnimationPlayer.new()
		anim_player.name = "AnimationPlayer"
		add_child(anim_player)
		print("AnimationPlayer created")

	_print_tree_debug(self, 0)


func play_animation(anim_name: String) -> void:
	if not anim_player:
		return
	var found := _find_animation(anim_name)
	if found.is_empty():
		print("Animation not found: ", anim_name)
		return
	print("Playing: ", found)
	anim_player.stop()
	anim_player.play(found)


func get_available_animations() -> PackedStringArray:
	if not anim_player:
		return PackedStringArray()
	var result := PackedStringArray()
	for lib_name in anim_player.get_animation_library_list():
		var lib := anim_player.get_animation_library(lib_name)
		for anim_name in lib.get_animation_list():
			if lib_name.is_empty():
				result.append(anim_name)
			else:
				result.append(lib_name + "/" + anim_name)
	return result


func _find_animation(search: String) -> String:
	var anims := get_available_animations()
	# Exact match first
	for a in anims:
		var short_name := a.get_file() if "/" in a else a
		if short_name.to_lower() == search.to_lower():
			return a
	# Partial match
	for a in anims:
		if a.to_lower().contains(search.to_lower()):
			return a
	return ""


func print_animations() -> void:
	var anims := get_available_animations()
	print("Available animations (", anims.size(), "):")
	for a in anims:
		print("  - ", a)


func _find_node_of_type(node: Node, type_name: String) -> Node:
	for child in node.get_children():
		if child.get_class() == type_name:
			return child
		var result := _find_node_of_type(child, type_name)
		if result:
			return result
	return null


func _print_tree_debug(node: Node, depth: int) -> void:
	var indent := ""
	for i in depth:
		indent += "  "
	print(indent, node.name, " [", node.get_class(), "]")
	for child in node.get_children():
		_print_tree_debug(child, depth + 1)
