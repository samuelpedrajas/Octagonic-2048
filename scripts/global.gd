extends Node

const MATRIX_SIZE = 4

var matrix = {}
var tween
var moving = false

func _ready():
	tween = Tween.new()
	add_child(tween)
