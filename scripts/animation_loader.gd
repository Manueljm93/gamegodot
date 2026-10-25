extends Node
## Loads animations from external GLB scenes and remaps tracks to match character skeleton.

@export var animation_scenes: Array[PackedScene] = []


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	var character := get_parent()
	if not character.has_method("play_animation"):
		print("AnimationLoader: Parent has no character script")
		return

	var anim_player: AnimationPlayer = character.anim_player
	var skeleton: Skeleton3D = character.skeleton

	if not anim_player:
		print("AnimationLoader: No AnimationPlayer on character")
		return
	if not skeleton:
		print("AnimationLoader: No Skeleton3D on character")
		return

	var skel_path_from_player := anim_player.get_path_to(skeleton)
	print("Skeleton path from AnimationPlayer: ", skel_path_from_player)

	for scene in animation_scenes:
		if not scene:
			continue
		_load_scene_animations(scene, anim_player, skeleton, skel_path_from_player)

	character.print_animations()


func _load_scene_animations(
	scene: PackedScene,
	target_player: AnimationPlayer,
	_target_skeleton: Skeleton3D,
	skel_path: NodePath
) -> void:
	var instance := scene.instantiate()
	add_child(instance)
	await get_tree().process_frame

	var src_player := _find_animation_player(instance)
	if not src_player:
		print("No AnimationPlayer in: ", scene.resource_path)
		instance.queue_free()
		return

	var src_skeleton := _find_skeleton(instance)
	var src_skel_path := ""
	if src_skeleton and src_player:
		src_skel_path = str(src_player.get_path_to(src_skeleton))

	var lib := AnimationLibrary.new()
	var lib_name := scene.resource_path.get_file().get_basename()
	var count := 0

	for anim_name in src_player.get_animation_list():
		if anim_name == "T-Pose" or anim_name == "RESET":
			continue
		var src_anim := src_player.get_animation(anim_name)
		var new_anim := _remap_animation(src_anim, src_skel_path, str(skel_path))
		lib.add_animation(anim_name, new_anim)
		count += 1

	target_player.add_animation_library(lib_name, lib)
	print("Loaded '", lib_name, "': ", count, " animations")
	instance.queue_free()


func _remap_animation(src_anim: Animation, old_skel_path: String, new_skel_path: String) -> Animation:
	var anim := src_anim.duplicate()
	for i in anim.get_track_count():
		var track_path := str(anim.track_get_path(i))
		if not old_skel_path.is_empty() and track_path.begins_with(old_skel_path):
			var remainder := track_path.substr(old_skel_path.length())
			track_path = new_skel_path + remainder
			anim.track_set_path(i, NodePath(track_path))
	return anim


func _find_animation_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var result := _find_animation_player(child)
		if result:
			return result
	return null


func _find_skeleton(node: Node) -> Skeleton3D:
	for child in node.get_children():
		if child is Skeleton3D:
			return child
		var result := _find_skeleton(child)
		if result:
			return result
	return null
