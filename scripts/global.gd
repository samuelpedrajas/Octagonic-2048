extends Node

const MATRIX_SIZE = 4

var score = 0
var matrix = {}
var tween

static func is_valid_pos(p):
	# checks if the position is inside the bounds of the matrix
	return p.x >= 0 and p.x < MATRIX_SIZE and p.y >= 0 and p.y < MATRIX_SIZE

static func game_over():
	print("GAME OVER!!")

func _ready():
	tween = Tween.new()
	add_child(tween)

func increase_points(p):
	score += p
	get_tree().get_root().get_node("game/score").set_text(str(score))
