extends Node

var score_current = 0
var score_best = 0
var max_current = 0
var stage
var current_challenge

signal current_score_changed
signal current_max_changed

func _ready():
	stage = get_tree().get_root().get_node("stage")
	current_challenge = config.CHALLENGES[config.DEFAULT_CHALLENGE]
	call_deferred("_prepare_stage", current_challenge)

func _prepare_stage(current_challenge):
	stage.prepare_board(current_challenge)

func handle_token_increased(v):
	score_current += v
	max_current = v if v > max_current else max_current
	emit_signal("current_score_changed", score_current)
	emit_signal("current_max_changed", max_current)
