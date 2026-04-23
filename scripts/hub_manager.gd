extends Node

var _positions = [
	Vector2(0, 144),
	Vector2(96, 32),
	Vector2(-32, 64),
	Vector2(352, 192)
]

var _player_position: Vector2 = _positions[0]

func set_player_position(position: Hub.Position):
	_player_position = _positions[position]

func get_player_position() -> Vector2:
	return _player_position
