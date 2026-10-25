extends Control

signal encounter_choice(fight: bool)

var combat_hud: Control = null
var player_bar: ProgressBar = null
var player_hp_label: Label = null
var enemy_bar: ProgressBar = null
var enemy_hp_label: Label = null
var turn_label: Label = null
var info_label: Label = null
var encounter_panel: Panel = null


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_combat_hud()
	_build_encounter_panel()


func _build_combat_hud() -> void:
	combat_hud = Control.new()
	combat_hud.name = "CombatHUD"
	combat_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	combat_hud.visible = false
	add_child(combat_hud)

	var p_panel := _create_hp_panel("Knight", Color(0.2, 0.6, 0.3), Vector2(20, 20))
	combat_hud.add_child(p_panel)
	player_bar = p_panel.get_node("Bar") as ProgressBar
	player_hp_label = p_panel.get_node("HP") as Label

	var e_panel := _create_hp_panel("Enemy", Color(0.7, 0.2, 0.2), Vector2(1010, 20))
	combat_hud.add_child(e_panel)
	enemy_bar = e_panel.get_node("Bar") as ProgressBar
	enemy_hp_label = e_panel.get_node("HP") as Label

	turn_label = Label.new()
	turn_label.name = "TurnLabel"
	turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	turn_label.position = Vector2(490, 80)
	turn_label.size = Vector2(300, 40)
	turn_label.add_theme_font_size_override("font_size", 24)
	turn_label.add_theme_color_override("font_color", Color.WHITE)
	combat_hud.add_child(turn_label)

	info_label = Label.new()
	info_label.name = "InfoLabel"
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info_label.position = Vector2(390, 300)
	info_label.size = Vector2(500, 60)
	info_label.add_theme_font_size_override("font_size", 36)
	combat_hud.add_child(info_label)


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
	var pressed := normal.duplicate()
	pressed.bg_color = color.darkened(0.15)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 20)
	return btn


func _create_hp_panel(title: String, color: Color, pos: Vector2) -> Control:
	var panel := Control.new()
	panel.name = title + "Panel"
	panel.position = pos
	panel.size = Vector2(250, 65)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var name_label := Label.new()
	name_label.name = "Name"
	name_label.text = title
	name_label.position = Vector2(0, 0)
	name_label.size = Vector2(250, 25)
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	panel.add_child(name_label)

	var bar := ProgressBar.new()
	bar.name = "Bar"
	bar.position = Vector2(0, 25)
	bar.size = Vector2(250, 20)
	bar.max_value = 100
	bar.value = 100
	bar.show_percentage = false
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.15, 0.15, 0.15)
	bg.corner_radius_top_left = 4
	bg.corner_radius_top_right = 4
	bg.corner_radius_bottom_left = 4
	bg.corner_radius_bottom_right = 4
	bar.add_theme_stylebox_override("background", bg)
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	fill.corner_radius_top_left = 4
	fill.corner_radius_top_right = 4
	fill.corner_radius_bottom_left = 4
	fill.corner_radius_bottom_right = 4
	bar.add_theme_stylebox_override("fill", fill)
	panel.add_child(bar)

	var hp_label := Label.new()
	hp_label.name = "HP"
	hp_label.position = Vector2(0, 47)
	hp_label.size = Vector2(250, 20)
	hp_label.add_theme_font_size_override("font_size", 14)
	hp_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(hp_label)

	return panel


func show_encounter() -> void:
	encounter_panel.visible = true


func hide_encounter() -> void:
	encounter_panel.visible = false


func show_combat() -> void:
	combat_hud.visible = true
	info_label.text = ""


func hide_combat() -> void:
	combat_hud.visible = false


func update_hp(who: String, current: int, max_hp: int) -> void:
	if who == "player":
		player_bar.max_value = max_hp
		player_bar.value = current
		player_hp_label.text = "%d / %d" % [current, max_hp]
	else:
		enemy_bar.max_value = max_hp
		enemy_bar.value = current
		enemy_hp_label.text = "%d / %d" % [current, max_hp]


func update_turn(is_player_turn: bool) -> void:
	if is_player_turn:
		turn_label.text = ">> Your Turn <<"
	else:
		turn_label.text = "Enemy Turn..."


func show_action(who: String, damage: int) -> void:
	if who == "player":
		info_label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		info_label.add_theme_color_override("font_color", Color.RED)
	info_label.text = "-%d!" % damage


func show_result(player_won: bool) -> void:
	if player_won:
		info_label.add_theme_color_override("font_color", Color.GREEN)
		info_label.text = "VICTORY!"
	else:
		info_label.add_theme_color_override("font_color", Color.RED)
		info_label.text = "DEFEAT!"
	turn_label.text = ""
