extends TileMap

onready var token = preload("res://scenes/token.tscn")

func _get_empty_position():
	var available_positions = []
	# for each cell used in the board
	for cell in global.current_board.get_used_cells():
		# if there is no token in it, add it to available positions
		if !global.matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]

func _spawn_token(pos):
	var t = token.instance()
	add_child(t)  # t.setup() needs access to the board, so add it before
	t.setup(pos)
	global.matrix[pos] = t

func _prepare_next_round():
	var pos = _get_empty_position()
	if pos != null:
		_spawn_token(pos)
	global.check_moves_available()

func _ready():
	_prepare_next_round()

func move_token(direction):
	var board_changed = false

	# for each pivot in this direction
	for pivot in global.direction_pivots[direction]:
		var next_pos = pivot
		# while next_pos is in the board
		while(global.is_valid_pos(next_pos)):
			if global.matrix.has(next_pos):
				# here we found the first token for the given pivot and direction -> move it
				board_changed = global.matrix[next_pos].move(direction) or board_changed
				break
			next_pos += direction  # no tokens yet -> advance to the next position

	if board_changed:
		global.tween.start()
		# When the animation of all tokens is finished -> prepare next round
		global.tween.interpolate_callback(self, global.tween.get_runtime(), "_prepare_next_round")
