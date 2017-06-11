extends Node

var score_current = 0 setget _set_score_current
var score_best = 0 setget _set_score_best
var max_current = 0 setget _set_max_current
var current_goal = 0 setget _set_current_goal

var stage
var current_challenge
var next_challenge_index

signal current_score_changed
signal current_max_changed
signal current_goal_changed

func _ready():
	stage = get_tree().get_root().get_node("stage")
	next_challenge_index = config.DEFAULT_CHALLENGE
	call_deferred("_next_challenge")

func _next_challenge():
	current_challenge = config.CHALLENGES[next_challenge_index]
	self.current_goal = current_challenge.goal
	next_challenge_index += 1
	stage.prepare_board(current_challenge)	

func _check_win():
	if max_current == current_goal:
		print("WIN")
		self.score_current = 0
		self.max_current = 0
		_next_challenge()

func handle_token_increased(v):
	self.score_current += v
	self.max_current = v if v > max_current else max_current
	_check_win()

func game_over():
	print("Game over")
	self.score_current = 0
	self.max_current = 0
	stage.prepare_board(current_challenge)

func _set_score_current(v):
	score_current = v
	emit_signal("current_score_changed", score_current)

func _set_score_best(v):
	pass

func _set_max_current(v):
	max_current = v
	emit_signal("current_max_changed", max_current)

func _set_current_goal(v):
	current_goal = v
	emit_signal("current_goal_changed", current_goal)
