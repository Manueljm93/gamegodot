extends Node

signal gold_changed(amount: int, income: int)
signal day_changed(day: int)

var gold: int = 500
var gold_income: int = 0
var day: int = 1


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	gold_changed.emit(gold, gold_income)
	return true


func end_turn() -> void:
	gold += gold_income
	day += 1
	gold_changed.emit(gold, gold_income)
	day_changed.emit(day)
