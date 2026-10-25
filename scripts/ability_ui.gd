extends Control
## UI panel with ability buttons that trigger character animations.

@export var character_path: NodePath

var character: Node3D = null

var abilities := [
	{"name": "Attack", "anim": "Throw", "color": Color(0.9, 0.3, 0.3)},
	{"name": "Magic", "anim": "Interact", "color": Color(0.7, 0.3, 0.9)},
	{"name": "Item", "anim": "Use_Item", "color": Color(0.3, 0.8, 0.4)},
	{"name": "Hit A", "anim": "Hit_A", "color": Color(0.9, 0.5, 0.2)},
	{"name": "Hit B", "anim": "Hit_B", "color": Color(0.85, 0.45, 0.15)},
	{"name": "Death", "anim": "Death_A", "color": Color(0.4, 0.4, 0.4)},
]


func _ready() -> void:
	character = get_node_or_null(character_path)
	_build_buttons()


func _build_buttons() -> void:
	var container := HBoxContainer.new()
	container.name = "ButtonContainer"
	container.anchor_left = 0.5
	container.anchor_right = 0.5
	container.anchor_top = 1.0
	container.anchor_bottom = 1.0
	container.offset_left = -250
	container.offset_right = 250
	container.offset_top = -80
	container.offset_bottom = -20
	container.set("theme_override_constants/separation", 10)
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(container)

	for ability in abilities:
		var btn := Button.new()
		btn.text = ability["name"]
		btn.custom_minimum_size = Vector2(90, 50)

		var stylebox := StyleBoxFlat.new()
		stylebox.bg_color = ability["color"]
		stylebox.corner_radius_top_left = 8
		stylebox.corner_radius_top_right = 8
		stylebox.corner_radius_bottom_left = 8
		stylebox.corner_radius_bottom_right = 8
		btn.add_theme_stylebox_override("normal", stylebox)

		var hover_style := stylebox.duplicate()
		hover_style.bg_color = ability["color"].lightened(0.2)
		btn.add_theme_stylebox_override("hover", hover_style)

		var pressed_style := stylebox.duplicate()
		pressed_style.bg_color = ability["color"].darkened(0.2)
		btn.add_theme_stylebox_override("pressed", pressed_style)

		btn.add_theme_color_override("font_color", Color.WHITE)
		btn.add_theme_font_size_override("font_size", 16)

		var anim_name: String = ability["anim"]
		btn.pressed.connect(_on_ability_pressed.bind(anim_name))
		container.add_child(btn)


func _on_ability_pressed(anim_name: String) -> void:
	if character and character.has_method("play_animation"):
		character.play_animation(anim_name)
