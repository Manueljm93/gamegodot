extends Node
## Global game state singleton (autoload).
## Access via GameManager from any script.

enum GameState { MENU, PLAYING, PAUSED }

var current_state: GameState = GameState.MENU


func change_state(new_state: GameState) -> void:
	current_state = new_state


func _ready() -> void:
	print("GameManager ready")
