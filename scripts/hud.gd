extends Control

signal end_turn_pressed

var gold_label: Label = null
var day_label: Label = null


func _ready() -> void:
	anchor_right = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_hud()


func _build_hud() -> void:
	var bar := Panel.new()
	bar.name = "TopBar"
	bar.position = Vector2(0, 0)
	bar.size = Vector2(1280, 45)
	var bar_style := StyleBoxFlat.new()
	bar_style.bg_color = Color(0.08, 0.08, 0.12, 0.85)
	bar.add_theme_stylebox_override("panel", bar_style)
	add_child(bar)

	day_label = Label.new()
	day_label.text = "Day 1"
	day_label.position = Vector2(20, 10)
	day_label.size = Vector2(150, 30)
	day_label.add_theme_font_size_override("font_size", 20)
	day_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.9))
	bar.add_child(day_label)

	gold_label = Label.new()
	gold_label.text = "Gold: 500"
	gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gold_label.position = Vector2(440, 10)
	gold_label.size = Vector2(400, 30)
	gold_label.add_theme_font_size_override("font_size", 20)
	gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	bar.add_child(gold_label)

	var end_btn := Button.new()
	end_btn.text = "End Turn"
	end_btn.position = Vector2(1120, 5)
	end_btn.size = Vector2(140, 35)
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.2, 0.5, 0.3)
	btn_style.corner_radius_top_left = 6
	btn_style.corner_radius_top_right = 6
	btn_style.corner_radius_bottom_left = 6
	btn_style.corner_radius_bottom_right = 6
	end_btn.add_theme_stylebox_override("normal", btn_style)
	var btn_hover := btn_style.duplicate()
	btn_hover.bg_color = Color(0.25, 0.6, 0.35)
	end_btn.add_theme_stylebox_override("hover", btn_hover)
	end_btn.add_theme_color_override("font_color", Color.WHITE)
	end_btn.add_theme_font_size_override("font_size", 16)
	end_btn.pressed.connect(func() -> void: end_turn_pressed.emit())
	bar.add_child(end_btn)


func update_gold(amount: int, income: int) -> void:
	if income > 0:
		gold_label.text = "Gold: %d  (+%d/turn)" % [amount, income]
	else:
		gold_label.text = "Gold: %d" % amount


func update_day(day: int) -> void:
	day_label.text = "Day %d" % day
