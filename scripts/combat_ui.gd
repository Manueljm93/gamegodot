extends Control

signal encounter_choice(fight: bool)

const ArmyStackScript = preload("res://scripts/army_stack.gd")

var encounter_panel: Panel = null
var combat_panel: Panel = null
var player_stack_labels: Array[Label] = []
var enemy_stack_labels: Array[Label] = []
var turn_label: Label = null
var info_label: Label = null
var result_label: Label = null


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_encounter_panel()
	_build_combat_panel()
	_build_result_label()


func _build_encounter_panel() -> void:
	encounter_panel = Panel.new()
	encounter_panel.name = "EncounterPanel"
	encounter_panel.position = Vector2(440, 250)
	encounter_panel.size = Vector2(400, 200)
	encounter_panel.visible = false

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.8, 0.6, 0.2)
	encounter_panel.add_theme_stylebox_override("panel", style)

	var title := Label.new()
	title.text = "Enemy Encountered!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(0, 30)
	title.size = Vector2(400, 40)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.9, 0.7, 0.2))
	encounter_panel.add_child(title)

	var fight_btn := _create_panel_btn("FIGHT", Color(0.8, 0.2, 0.2), Vector2(50, 110))
	fight_btn.pressed.connect(func() -> void: encounter_choice.emit(true))
	encounter_panel.add_child(fight_btn)

	var flee_btn := _create_panel_btn("FLEE", Color(0.4, 0.4, 0.4), Vector2(210, 110))
	flee_btn.pressed.connect(func() -> void: encounter_choice.emit(false))
	encounter_panel.add_child(flee_btn)

	add_child(encounter_panel)


func _build_combat_panel() -> void:
	combat_panel = Panel.new()
	combat_panel.name = "CombatPanel"
	combat_panel.position = Vector2(140, 510)
	combat_panel.size = Vector2(1000, 170)
	combat_panel.visible = false

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.9)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	combat_panel.add_theme_stylebox_override("panel", style)

	var p_header := Label.new()
	p_header.text = "YOUR ARMY"
	p_header.position = Vector2(20, 8)
	p_header.size = Vector2(250, 25)
	p_header.add_theme_font_size_override("font_size", 16)
	p_header.add_theme_color_override("font_color", Color(0.5, 0.85, 0.5))
	combat_panel.add_child(p_header)

	for i in 3:
		var lbl := Label.new()
		lbl.position = Vector2(20, 35 + i * 24)
		lbl.size = Vector2(300, 24)
		lbl.add_theme_font_size_override("font_size", 15)
		lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
		lbl.visible = false
		combat_panel.add_child(lbl)
		player_stack_labels.append(lbl)

	var e_header := Label.new()
	e_header.text = "ENEMY ARMY"
	e_header.position = Vector2(720, 8)
	e_header.size = Vector2(250, 25)
	e_header.add_theme_font_size_override("font_size", 16)
	e_header.add_theme_color_override("font_color", Color(0.85, 0.5, 0.5))
	combat_panel.add_child(e_header)

	for i in 3:
		var lbl := Label.new()
		lbl.position = Vector2(720, 35 + i * 24)
		lbl.size = Vector2(280, 24)
		lbl.add_theme_font_size_override("font_size", 15)
		lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
		lbl.visible = false
		combat_panel.add_child(lbl)
		enemy_stack_labels.append(lbl)

	turn_label = Label.new()
	turn_label.position = Vector2(300, 20)
	turn_label.size = Vector2(400, 30)
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.add_theme_font_size_override("font_size", 20)
	turn_label.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	combat_panel.add_child(turn_label)

	info_label = Label.new()
	info_label.position = Vector2(200, 120)
	info_label.size = Vector2(600, 30)
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.add_theme_font_size_override("font_size", 18)
	info_label.add_theme_color_override("font_color", Color(0.9, 0.7, 0.3))
	combat_panel.add_child(info_label)

	add_child(combat_panel)


func _build_result_label() -> void:
	result_label = Label.new()
	result_label.name = "ResultLabel"
	result_label.position = Vector2(340, 280)
	result_label.size = Vector2(600, 80)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 40)
	result_label.visible = false
	add_child(result_label)


func _create_panel_btn(text: String, color: Color, pos: Vector2) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.position = pos
	btn.size = Vector2(140, 55)
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	normal.corner_radius_top_left = 8
	normal.corner_radius_top_right = 8
	normal.corner_radius_bottom_left = 8
	normal.corner_radius_bottom_right = 8
	btn.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = color.lightened(0.15)
	btn.add_theme_stylebox_override("hover", hover)
	var pressed_style := normal.duplicate()
	pressed_style.bg_color = color.darkened(0.15)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 20)
	return btn


func show_encounter() -> void:
	encounter_panel.visible = true


func hide_encounter() -> void:
	encounter_panel.visible = false


func show_combat(p_army: Array, e_army: Array) -> void:
	combat_panel.visible = true
	info_label.text = ""
	turn_label.text = ""
	_refresh_stacks(p_army, e_army)


func hide_combat() -> void:
	combat_panel.visible = false
	result_label.visible = false


func update_turn(side: String, label: String) -> void:
	if side == "player":
		turn_label.text = "%s — Click enemy!" % label
	else:
		turn_label.text = "%s attacks..." % label


func show_attack(damage: int, kills: int, target_label: String) -> void:
	if kills > 0:
		info_label.text = "%d dmg > %s (%d killed)" % [damage, target_label, kills]
	else:
		info_label.text = "%d dmg > %s" % [damage, target_label]


func refresh_stacks(p_army: Array, e_army: Array) -> void:
	_refresh_stacks(p_army, e_army)


func show_result(player_won: bool) -> void:
	if player_won:
		result_label.text = "VICTORY!"
		result_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.3))
	else:
		result_label.text = "DEFEAT!"
		result_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	result_label.visible = true
	turn_label.text = ""


func _refresh_stacks(p_army: Array, e_army: Array) -> void:
	for i in player_stack_labels.size():
		var lbl: Label = player_stack_labels[i]
		if i < p_army.size():
			var s: ArmyStackScript = p_army[i]
			lbl.visible = true
			if s.is_alive():
				var total_hp: int = (s.count - 1) * s.max_hp + s.hp
				lbl.text = "%dx %s  (%d HP)" % [s.count, s.unit_label, total_hp]
				lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
			else:
				lbl.text = "%s — dead" % s.unit_label
				lbl.add_theme_color_override("font_color", Color(0.5, 0.4, 0.4))
		else:
			lbl.visible = false

	for i in enemy_stack_labels.size():
		var lbl: Label = enemy_stack_labels[i]
		if i < e_army.size():
			var s: ArmyStackScript = e_army[i]
			lbl.visible = true
			if s.is_alive():
				var total_hp: int = (s.count - 1) * s.max_hp + s.hp
				lbl.text = "%dx %s  (%d HP)" % [s.count, s.unit_label, total_hp]
				lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
			else:
				lbl.text = "%s — dead" % s.unit_label
				lbl.add_theme_color_override("font_color", Color(0.5, 0.4, 0.4))
		else:
			lbl.visible = false
