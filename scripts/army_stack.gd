extends RefCounted


var unit_type: String = ""
var unit_label: String = ""
var count: int = 0
var max_hp: int = 10
var hp: int = 10
var attack: int = 5
var defense: int = 3
var damage_min: int = 2
var damage_max: int = 4
var speed: int = 5
var color: Color = Color.WHITE


func setup(p_type: String, p_label: String, p_count: int, p_max_hp: int, p_atk: int, p_def: int, p_dmg_min: int, p_dmg_max: int, p_speed: int, p_color: Color) -> void:
	unit_type = p_type
	unit_label = p_label
	count = p_count
	max_hp = p_max_hp
	hp = p_max_hp
	attack = p_atk
	defense = p_def
	damage_min = p_dmg_min
	damage_max = p_dmg_max
	speed = p_speed
	color = p_color


func is_alive() -> bool:
	return count > 0


func take_damage(dmg: int) -> int:
	var kills: int = 0
	var remaining: int = dmg
	while remaining > 0 and count > 0:
		if remaining >= hp:
			remaining -= hp
			count -= 1
			kills += 1
			hp = max_hp
		else:
			hp -= remaining
			remaining = 0
	if count <= 0:
		count = 0
		hp = 0
	return kills


func calc_damage() -> int:
	if count <= 0:
		return 0
	return randi_range(damage_min, damage_max) * count
