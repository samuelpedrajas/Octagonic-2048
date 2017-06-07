extends Node2D

const ANIMATION_TIME = 0.1
const MERGE_THRESHOLD = 20
const MOVEMENT_OPACITY = 0.2
const LABEL_SCALE = Vector2(0.9, 0.9)
const LABEL_OFFSET = Vector2(-5, -5)

var value
var token_to_merge_with = null
var current_pos

func _set_label():
	var n_digits_old = str(value / 2).length()
	var n_digits_new = str(value).length()
	var label = get_node("token_sprite/value")

	if n_digits_new != n_digits_old:
		label.set_scale(label.get_scale() * LABEL_SCALE)
		label.set_pos(-label.get_size() * label.get_scale() / 2 + LABEL_OFFSET)
	label.text = str(value)

func _spawn_animation():
	# play spawn animation
	get_node("animation").play("spawn")

func setup(pos):
	value = 2
	current_pos = pos
	_set_label()
	set_pos(get_parent().map_to_world(pos))
	_spawn_animation()

func _modulate():
	var sprite = get_node("token_sprite")
	var c = sprite.get_modulate()
	sprite.set_modulate(Color(c.r, c.g * 0.9, c.b * 0.9, 0.5))

func _increase_value():
	value *= 2
	_modulate()
	_set_label()
	global.score_current += value
	# play merge animation
	get_node("animation").play("merge")

func _interpolated_move(pos):
	var world_current_pos = get_parent().map_to_world(current_pos)

	# length of the difference between the current position and the destination
	var d = (world_current_pos - pos).length()

	# if it's close enough -> time to restore the opacity
	if d < MERGE_THRESHOLD:
		if get_opacity() < 1:  # must check, otherwise opacity will be set more than once
			set_opacity(1)
		# if it's close enough and flagged as merge -> merge it
		if token_to_merge_with:
			token_to_merge_with._increase_value()
			token_to_merge_with = null
			global.tween.remove(self, "_interpolated_move")
			queue_free()
			return

	set_pos(pos)

func _define_tweening():
	# get the real world position since destination is a position in the matrix
	var world_pos = get_parent().map_to_world(current_pos)

	# interpolate the position
	global.tween.interpolate_method(self, "_interpolated_move", get_pos(), world_pos, ANIMATION_TIME,
									global.tween.TRANS_LINEAR, global.tween.EASE_IN)
	# decrease opacity for a smoother animation
	set_opacity(MOVEMENT_OPACITY)

func move(direction):
	var destination = current_pos
	var next_pos = current_pos + direction
	var line_events = {
		"movement": false,
		"merge": false
	}

	# while next_position is inside the board
	while global.is_valid_pos(next_pos):
		# if next_position is occupied by a token
		if global.matrix.has(next_pos):
			var token = global.matrix[next_pos]

			# move the next token and get if it saw any merge in the line
			line_events.merge = token.move(direction).merge

			if token.token_to_merge_with or token.value != value:
				# take the previous position of the next token if it's gonna be merged
				# or cannot be merged with the actual one
				destination = token.current_pos - direction
			else:
				# if the next token did not find any token to be merged with and its
				# value is the same as the current token value, take the same position
				# and set token_to_merge_with to merge it close to the animation end
				destination = token.current_pos
				token_to_merge_with = token
				line_events.merge = true  # there is a merge!
			break
		destination = next_pos
		next_pos += direction

	line_events.movement = current_pos != destination

	if line_events.movement:
		global.matrix.erase(current_pos)  # the token is not in that position anymore
		# update the token position in the matrix if it's not gonna be merged
		# (otherwise we'll override the token that's gonna be increased)
		if !token_to_merge_with:
			global.matrix[destination] = self

		current_pos = destination  # update the current position
		_define_tweening()

	return line_events
