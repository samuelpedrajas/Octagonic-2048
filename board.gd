extends TileMap

const MATRIX_SIZE = 4

onready var token = preload("res://token.tscn")
var matrix
var tween

func _create_matrix():
	var m = []
	for i in range(MATRIX_SIZE):
		m.append([])
		for j in range(MATRIX_SIZE):
			m[i].append(-1)
	return m

func _ready():
	tween = Tween.new()
	add_child(tween)
	matrix = _create_matrix()
	_spawn_token(0, 0)
	_spawn_token(0, 1)

func _get_world_pos(i, j):
	return map_to_world(Vector2(i, j + 3))

func _spawn_token(i, j):
	var t = token.instance()
	t.setup(_get_world_pos(i, j), tween)
	add_child(t)
	matrix[i][j] = t

func move(direction):
	# MATRIX_SIZE - 1 if the non 0 value of the direction is greater than 0, otherwise => 0
	var start_index = (MATRIX_SIZE - 1) * (direction[0] + direction[1] > 0)  
	for i in range(0, MATRIX_SIZE):
		for j in range(0, MATRIX_SIZE):
			var row = start_index - (i * direction[0] + j * direction[1])
			var col = start_index - (i * direction[1] + j * direction[0])

			
	# matrix[0][0].move(_get_world_pos(3, 0))
	# matrix[0][1].move(_get_world_pos(3, 1))
	# tween.start()
