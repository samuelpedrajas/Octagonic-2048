extends Node

var score_current = 0 setget _set_current_score
var score_best = 0
var stage
var current_challenge

signal current_score_changed

func _ready():
	stage = get_tree().get_root().get_node("stage")
	current_challenge = config.CHALLENGES[config.DEFAULT_CHALLENGE]
	call_deferred("_prepare_stage", current_challenge)

func _prepare_stage(current_challenge):
	stage.prepare_board(current_challenge)

func _set_current_score(s):
	score_current = s
	emit_signal("current_score_changed", s)
