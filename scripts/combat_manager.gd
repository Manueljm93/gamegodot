extends Node

signal combat_started
signal combat_ended(player_won: bool)
signal turn_started(side: String, stack_index: int)
signal attack_done(atk_side: String, atk_idx: int, def_side: String, def_idx: int, damage: int, kills: int)

const ArmyStackScript = preload("res://scripts/army_stack.gd")

var player_army: Array = []
var enemy_army: Array = []
var turn_order: Array = []
var current_turn: int = -1
var in_combat: bool = false
var is_player_turn: bool = false
var active_side: String = ""
var active_index: int = -1


func start_combat(p_army: Array, e_army: Array) -> void:
	player_army = p_army
	enemy_army = e_army
	in_combat = true
	current_turn = -1
	_build_turn_order()
	combat_started.emit()
	_next_turn()


func player_attack(target_index: int) -> void:
	if not is_player_turn or not in_combat:
		return
	if target_index < 0 or target_index >= enemy_army.size():
		return
	var target: ArmyStackScript = enemy_army[target_index]
	if not target.is_alive():
		return
	is_player_turn = false
	_resolve_attack(active_side, active_index, "enemy", target_index)


func get_army_stack(side: String, index: int) -> ArmyStackScript:
	if side == "player":
		return player_army[index]
	return enemy_army[index]


func _build_turn_order() -> void:
	turn_order.clear()
	for i in player_army.size():
		var s: ArmyStackScript = player_army[i]
		if s.is_alive():
			turn_order.append({"side": "player", "index": i, "speed": s.speed})
	for i in enemy_army.size():
		var s: ArmyStackScript = enemy_army[i]
		if s.is_alive():
			turn_order.append({"side": "enemy", "index": i, "speed": s.speed})
	turn_order.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["speed"] > b["speed"])


func _next_turn() -> void:
	current_turn += 1
	while current_turn < turn_order.size():
		var entry: Dictionary = turn_order[current_turn]
		var stack: ArmyStackScript = get_army_stack(entry["side"], entry["index"])
		if stack.is_alive():
			break
		current_turn += 1

	if current_turn >= turn_order.size():
		if _check_victory():
			return
		_build_turn_order()
		current_turn = -1
		_next_turn()
		return

	var entry: Dictionary = turn_order[current_turn]
	active_side = entry["side"]
	active_index = entry["index"]
	is_player_turn = active_side == "player"
	turn_started.emit(active_side, active_index)

	if not is_player_turn:
		await get_tree().create_timer(0.8).timeout
		_enemy_action()


func _enemy_action() -> void:
	var targets: Array[int] = []
	for i in player_army.size():
		var s: ArmyStackScript = player_army[i]
		if s.is_alive():
			targets.append(i)
	if targets.is_empty():
		_end_combat(false)
		return
	targets.shuffle()
	_resolve_attack(active_side, active_index, "player", targets[0])


func _resolve_attack(atk_side: String, atk_idx: int, def_side: String, def_idx: int) -> void:
	var attacker: ArmyStackScript = get_army_stack(atk_side, atk_idx)
	var target: ArmyStackScript = get_army_stack(def_side, def_idx)
	var base_dmg: int = attacker.calc_damage()
	var modifier: float = maxf(0.1, 1.0 + float(attacker.attack - target.defense) * 0.05)
	var damage: int = maxi(1, roundi(float(base_dmg) * modifier))
	var kills: int = target.take_damage(damage)
	attack_done.emit(atk_side, atk_idx, def_side, def_idx, damage, kills)
	await get_tree().create_timer(0.6).timeout
	if _check_victory():
		return
	_next_turn()


func _check_victory() -> bool:
	var player_alive := false
	for i in player_army.size():
		var s: ArmyStackScript = player_army[i]
		if s.is_alive():
			player_alive = true
			break
	var enemy_alive := false
	for i in enemy_army.size():
		var s: ArmyStackScript = enemy_army[i]
		if s.is_alive():
			enemy_alive = true
			break
	if not enemy_alive:
		_end_combat(true)
		return true
	if not player_alive:
		_end_combat(false)
		return true
	return false


func _end_combat(player_won: bool) -> void:
	in_combat = false
	is_player_turn = false
	combat_ended.emit(player_won)
