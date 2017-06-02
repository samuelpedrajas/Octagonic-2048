extends Node2D

const ANIMATION_TIME = 0.1

var value
var current_pos
var changed = false
var tween

func setup(pos, t):
	value = 2
	set_pos(pos)
	tween = t

func move(destination):
	tween.interpolate_method(self, "set_pos", get_pos(), destination, ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN)
	changed = false
