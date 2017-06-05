extends Node

const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1),  # Vertical: |
	Vector2(1, 1), Vector2(-1, -1), # Diagonal: \
	Vector2(1, -1), Vector2(-1, 1)  # Diagonal: /
]
const DEFAULT_BOARD = "3x3"

# first positions in each direction line
var direction_pivots = {}
var score = 0
var current_board
var matrix = {}
var tween

# All available boards
onready var boards = {
	"3x3": preload("../scenes/board_3x3.tscn"),
	"4x4": preload("../scenes/board_4x4.tscn")
}

func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = current_board.get_used_cells()

	# for each used cell, if it has no previous cell but it has a next one
	# for a given direction, then it is a pivot for that direction
	for cell_pos in used_cells:
		for direction in DIRECTIONS:
			var next_pos = (cell_pos + direction)
			var prev_pos = (cell_pos - direction)
			if next_pos in used_cells and !(prev_pos in used_cells):
				if !direction_pivots.has(direction):
					direction_pivots[direction] = []
				direction_pivots[direction].append(cell_pos)

func _reset_points():
	score = 0
	get_tree().get_root().get_node("game/score").set_text(str(score))

func _reset_board():
	tween.remove_all()
	_reset_points()
	current_board.queue_free()
	direction_pivots.clear()  # clear all the pivots
	matrix.clear()

func _prepare_board(board_id):
	# if we had a previous board, remove it
	if current_board:
		_reset_board()
	current_board = boards[board_id].instance()  # create a new board
	get_tree().get_root().get_node("game").add_child(current_board)  # add it to the root
	_set_direction_pivots()  # set its direction pivots
	get_tree().get_root().get_node("game").connect("user_input", current_board, "move_token")

func _ready():
	_prepare_board(DEFAULT_BOARD)  # prepare default board 
	tween = Tween.new()  # create a tween for token animation
	add_child(tween)

func is_valid_pos(p):
	# check if the position is inside the board
	return p in current_board.get_used_cells()

func check_moves_available():
	var used_cells = current_board.get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return

	for i in range(0, used_cells.size() - 1):
		for j in range(i + 1, used_cells.size()):
			var cell_i = used_cells[i]
			var cell_j = used_cells[j]
			var v = cell_i - cell_j
			if abs(v.x) <= 1 and abs(v.y) <= 1 and matrix[cell_i].value == matrix[cell_j].value:
				return
	_prepare_board(DEFAULT_BOARD)

func increase_points(p):
	score += p
	get_tree().get_root().get_node("game/score").set_text(str(score))
