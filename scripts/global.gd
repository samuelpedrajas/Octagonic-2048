extends Node

const MATRIX_SIZE = 4

var matrix = {}
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)

static func is_valid_pos(p):
	# checks if the position is inside the bounds of the matrix
	return p.x >= 0 and p.x < MATRIX_SIZE and p.y >= 0 and p.y < MATRIX_SIZE
