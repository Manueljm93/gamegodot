extends Control

signal building_requested(building_name: String)
signal close_requested

var buildings := [
	{"name": "barracks", "label": "Barracks", "cost": 200, "desc": "Enables troop recruitment"},
	{"name": "guard_tower", "label": "Guard Tower", "cost": 150, "desc": "Town defense"},
	{"name": "gold_mine", "label": "Gold Mine", "cost": 300, "desc": "+50 gold per turn"},
]

var built_buildings: Array[String] = []
var build_buttons: Array[Button] = []
var panel: Panel = null


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	_build_ui()


func _build_ui() -> void:
	panel = Panel.new()
	panel.name = "TownPanel"
	panel.position = Vector2(340, 100)
	panel.size = Vector2(600, 420)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.6, 0.5, 0.2)
	panel.add_theme_stylebox_override("panel", style)

	var title := Label.new()
	title.text = "Town - Buildings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(0, 20)
	title.size = Vector2(600, 40)
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(0.9, 0.75, 0.3))
	panel.add_child(title)

	var y_pos: int = 80
	for i in buildings.size():
		var b: Dictionary = buildings[i]
		var row := _create_building_row(b, Vector2(30, y_pos), i)
		panel.add_child(row)
		y_pos += 90

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.position = Vector2(240, 365)
	close_btn.size = Vector2(120, 40)
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color(0.4, 0.3, 0.3)
	close_style.corner_radius_top_left = 6
	close_style.corner_radius_top_right = 6
	close_style.corner_radius_bottom_left = 6
	close_style.corner_radius_bottom_right = 6
	close_btn.add_theme_stylebox_override("normal", close_style)
	var close_hover := close_style.duplicate()
	close_hover.bg_color = Color(0.5, 0.35, 0.35)
	close_btn.add_theme_stylebox_override("hover", close_hover)
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.add_theme_font_size_override("font_size", 16)
	close_btn.pressed.connect(func() -> void: close_requested.emit())
	panel.add_child(close_btn)

	add_child(panel)


func _create_building_row(b: Dictionary, pos: Vector2, index: int) -> Control:
	var row := Control.new()
	row.position = pos
	row.size = Vector2(540, 80)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var bg := Panel.new()
	bg.position = Vector2.ZERO
	bg.size = Vector2(540, 80)
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.15, 0.15, 0.2, 0.8)
	bg_style.corner_radius_top_left = 6
	bg_style.corner_radius_top_right = 6
	bg_style.corner_radius_bottom_left = 6
	bg_style.corner_radius_bottom_right = 6
	bg.add_theme_stylebox_override("panel", bg_style)
	row.add_child(bg)

	var name_label := Label.new()
	name_label.text = b["label"]
	name_label.position = Vector2(15, 10)
	name_label.size = Vector2(250, 25)
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	row.add_child(name_label)

	var desc_label := Label.new()
	var cost_val: int = b["cost"]
	desc_label.text = "%s  |  Cost: %d gold" % [b["desc"], cost_val]
	desc_label.position = Vector2(15, 40)
	desc_label.size = Vector2(380, 25)
	desc_label.add_theme_font_size_override("font_size", 14)
	desc_label.add_theme_color_override("font_color", Color(0.65, 0.65, 0.7))
	row.add_child(desc_label)

	var btn := Button.new()
	btn.name = "BuildBtn_%d" % index
	btn.text = "Build"
	btn.position = Vector2(420, 20)
	btn.size = Vector2(100, 40)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.2, 0.55, 0.3)
	btn_style.corner_radius_top_left = 6
	btn_style.corner_radius_top_right = 6
	btn_style.corner_radius_bottom_left = 6
	btn_style.corner_radius_bottom_right = 6
	btn.add_theme_stylebox_override("normal", btn_style)
	var btn_hover := btn_style.duplicate()
	btn_hover.bg_color = Color(0.25, 0.65, 0.35)
	btn.add_theme_stylebox_override("hover", btn_hover)
	var btn_disabled := btn_style.duplicate()
	btn_disabled.bg_color = Color(0.3, 0.3, 0.3)
	btn.add_theme_stylebox_override("disabled", btn_disabled)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 16)
	var building_name: String = b["name"]
	btn.pressed.connect(func() -> void: building_requested.emit(building_name))
	row.add_child(btn)

	build_buttons.append(btn)
	return row


func show_menu(gold: int, building_locked: bool = false) -> void:
	visible = true
	_refresh_buttons(gold, building_locked)


func hide_menu() -> void:
	visible = false


func mark_built(building_name: String) -> void:
	built_buildings.append(building_name)


func _refresh_buttons(gold: int, building_locked: bool) -> void:
	for i in buildings.size():
		var b: Dictionary = buildings[i]
		var btn: Button = build_buttons[i]
		var bname: String = b["name"]
		var cost: int = b["cost"]
		if built_buildings.has(bname):
			btn.text = "BUILT"
			btn.disabled = true
		elif building_locked:
			btn.text = "Locked"
			btn.disabled = true
		elif gold < cost:
			btn.text = "Build"
			btn.disabled = true
		else:
			btn.text = "Build"
			btn.disabled = false
