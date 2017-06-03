extends TileMap

onready var token = preload("res://scenes/token.tscn")

func _prepare_next_round():
	var available_positions = []
	for i in range(global.MATRIX_SIZE):
		for j in range(global.MATRIX_SIZE):
			var pos = Vector2(i, j)
			if !global.matrix.has(pos):
				available_positions.append(pos)
	var pos = available_positions[randi() % available_positions.size()]
	var t = token.instance()
	add_child(t)
	t.setup(pos)
	global.matrix[pos] = t

func _ready():
	_prepare_next_round()

func _get_world_pos(pos):
	return map_to_world(Vector2(pos.x, pos.y + 3))

func _diagonal_move(direction):
	return false

func _perpendicular_move(direction):
	var board_changed = false
	# MATRIX_SIZE - 1 if the non 0 value of the direction is greater than 0, otherwise => 0
	var start_index = (global.MATRIX_SIZE - 1) * (direction[0] + direction[1] > 0)  
	for i in range(0, global.MATRIX_SIZE):
		for j in range(0, global.MATRIX_SIZE):
			# if moving horizontally:
			# 	- we want the columns to move faster ("j" for columns)
			# elif moving vertically:
			#	- we want the rows to move faster ("j" for rows)
			#
			# if moving positively:
			#	- we want "i" to decrease the position
			# elif moving negatively:
			#	- we want "i" to increase the position
			var row = start_index - (i * direction[0] + j * direction[1])
			var col = start_index - (i * direction[1] + j * direction[0])

			# if there is a token - move it
			if global.matrix.has(Vector2(row, col)):
				# if the token taken into consideration was moved or merged with another token
				# "move" returns true, otherwise it returns false
				board_changed = global.matrix[Vector2(row, col)].move(direction) or board_changed

	return board_changed

func move_token(direction):
	var board_changed = false
	if direction.x == 0 or direction.y == 0:
		board_changed = _perpendicular_move(direction)
	else:
		board_changed = _diagonal_move(direction)

	if board_changed:
		global.tween.start()
		var expected_runtime = global.tween.get_runtime()
		global.tween.interpolate_callback(self, expected_runtime, "_prepare_next_round")
