extends SceneTree
## Validation script: loads all .gd files and reports errors.
## Run with: godot --headless --script res://scripts/validate.gd

func _init() -> void:
	print("=== GDScript Validation ===")
	var scripts := _find_scripts("res://scripts/")
	var errors := 0
	for path in scripts:
		if path.ends_with("validate.gd"):
			continue
		var script := load(path) as GDScript
		if script == null:
			print("FAIL: ", path, " - could not load")
			errors += 1
		elif not script.can_instantiate():
			print("FAIL: ", path, " - cannot instantiate")
			errors += 1
		else:
			print("  OK: ", path)
	print("=== ", scripts.size() - 1, " scripts, ", errors, " errors ===")
	quit(errors)


func _find_scripts(dir_path: String) -> PackedStringArray:
	var result := PackedStringArray()
	var dir := DirAccess.open(dir_path)
	if not dir:
		return result
	dir.list_dir_begin()
	var file := dir.get_next()
	while file != "":
		var full_path := dir_path + file
		if file.ends_with(".gd"):
			result.append(full_path)
		file = dir.get_next()
	return result
