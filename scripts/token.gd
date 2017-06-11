extends Node2D

var value
var token_to_merge_with = null
var current_pos
var tween

signal value_changed

func _ready():
	connect("value_changed", global, "handle_token_increased", [], CONNECT_DEFERRED)

func _set_label():
	var n_digits_old = str(value / 2).length()
	var n_digits_new = str(value).length()
	var label = get_node("token_sprite/value")

	if n_digits_new != n_digits_old:
		label.set_scale(label.get_scale() * config.LABEL_SCALE)
		label.set_pos(-label.get_size() * label.get_scale() / 2 + config.LABEL_OFFSET)
	label.text = str(value)

func _spawn_animation():
	# play spawn animation
	get_node("animation").play("spawn")

func setup(pos, t):
	value = 2
	tween = t
	current_pos = pos
	_set_label()
	set_pos(get_parent().map_to_world(pos))
	_spawn_animation()

func _modulate():
	var sprite = get_node("token_sprite")
	var c = sprite.get_modulate()
	sprite.set_modulate(c.linear_interpolate(config.MODULATION_ON_MERGE, config.LINEAR_INTERPOLATION_SCALAR))

func _increase_value():
	value *= 2
	emit_signal("value_changed", value)
	_modulate()
	_set_label()
	# play merge animation
	get_node("animation").play("merge")

func _interpolated_move(pos):
	var world_current_pos = get_parent().map_to_world(current_pos)

	# length of the difference between the current position and the destination
	var d = (world_current_pos - pos).length()

	# if it's close enough -> time to restore the opacity
	if d < config.MERGE_THRESHOLD:
		if get_opacity() < 1:  # must check, otherwise opacity will be set more than once
			set_opacity(1)
		# if it's close enough and flagged as merge -> merge it
		if token_to_merge_with:
			token_to_merge_with._increase_value()
			token_to_merge_with = null
			tween.remove(self, "_interpolated_move")
			queue_free()
			return

	set_pos(pos)

func _define_tweening():
	# get the real world position since destination is a position in the matrix
	var world_pos = get_parent().map_to_world(current_pos)

	# interpolate the position
	tween.interpolate_method(self, "_interpolated_move", get_pos(), world_pos,
							 config.ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN)
	# decrease opacity for a smoother animation
	set_opacity(config.MOVEMENT_OPACITY)
