extends Node

signal combat_started
signal combat_ended(player_won: bool)
signal turn_changed(is_player_turn: bool)
signal hp_changed(who: String, current: int, max_hp: int)
signal action_performed(who: String, action: String, damage: int)

var in_combat := false
var is_player_turn := true

var player_hp: int = 100
var player_max_hp: int = 100
var player_attack: int = 20

var enemy_hp: int = 0
var enemy_max_hp: int = 0
var enemy_attack: int = 0
var enemy_node: Node3D = null


func start_combat(enemy: Node3D, hp: int, atk: int) -> void:
	enemy_node = enemy
	enemy_hp = hp
	enemy_max_hp = hp
	enemy_attack = atk
	in_combat = true
	is_player_turn = true
	combat_started.emit()
	hp_changed.emit("player", player_hp, player_max_hp)
	hp_changed.emit("enemy", enemy_hp, enemy_max_hp)
	turn_changed.emit(true)


func player_action(_action: String) -> void:
	if not in_combat or not is_player_turn:
		return
	is_player_turn = false
	var damage: int = maxi(player_attack + randi_range(-3, 3), 1)
	enemy_hp = maxi(enemy_hp - damage, 0)
	action_performed.emit("player", "attack", damage)
	hp_changed.emit("enemy", enemy_hp, enemy_max_hp)
	if enemy_hp <= 0:
		await get_tree().create_timer(0.8).timeout
		_end_combat(true)
		return
	turn_changed.emit(false)
	await get_tree().create_timer(1.0).timeout
	_enemy_action()


func _enemy_action() -> void:
	var damage: int = maxi(enemy_attack + randi_range(-2, 2), 1)
	player_hp = maxi(player_hp - damage, 0)
	action_performed.emit("enemy", "attack", damage)
	hp_changed.emit("player", player_hp, player_max_hp)
	if player_hp <= 0:
		await get_tree().create_timer(0.8).timeout
		_end_combat(false)
		return
	await get_tree().create_timer(0.5).timeout
	is_player_turn = true
	turn_changed.emit(true)


func _end_combat(player_won: bool) -> void:
	in_combat = false
	combat_ended.emit(player_won)
