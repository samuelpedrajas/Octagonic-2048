extends Node2D

const ANIMATION_TIME = 0.1
const MERGE_THRESHOLD = 100

var value
var token_to_merge_with = null
var current_pos

func _set_label():
	get_node("token_sprite/value").text = str(value)

func setup(pos):
	value = 2
	current_pos = pos
	_set_label()
	set_pos(get_parent().map_to_world(pos))

func _modulate():
	var sprite = get_node("token_sprite")
	var c = sprite.get_modulate()
	c = c.linear_interpolate(Color(value / 2048.0, 0, 0), 0.1)
	sprite.set_modulate(c)

func _increase_value():
	value *= 2
	_modulate()
	_set_label()
	global.increase_points(value)

func _interpolated_move(pos):
	# if there is a token to merge with...
	if token_to_merge_with:
		var world_current_pos = get_parent().map_to_world(current_pos)
		# length of the difference between the current position and the destination
		var d = (world_current_pos - pos).length()

		# if it's close enough -> time increase the other token and to be free
		if d < MERGE_THRESHOLD:
			token_to_merge_with._increase_value()
			token_to_merge_with = null
			global.tween.remove(self, "_interpolated_move")
			queue_free()
			return

	set_pos(pos)

func move(direction):
	var destination = current_pos
	var next_pos = current_pos + direction

	# while next_position is inside the board
	while global.is_valid_pos(next_pos):
		# if next_position is occupied by a token
		if global.matrix.has(next_pos):
			var token = global.matrix[next_pos]

			# move the next token first to get its final position after
			token.move(direction)

			if token.token_to_merge_with or token.value != value:
				# take the previous position of the next token if it's gonna be merged
				# or cannot be merged with the actual one
				destination = token.current_pos - direction
			else:
				# if the next token did not find any token to be merged with and its
				# value is the same as the current token value, take the same position
				# and set token_to_merge_with to merge it near the end of the animation
				destination = token.current_pos
				token_to_merge_with = token
			break
		destination = next_pos
		next_pos += direction

	if current_pos != destination:
		global.matrix.erase(current_pos)  # the token is not in that position anymore
		# update the token position in the matrix if it's not gonna be merged
		# (otherwise we'll override the token that's gonna be increased)
		if !token_to_merge_with:
			global.matrix[destination] = self
		
		# get the real world position since destination is a position in the matrix
		var world_pos = get_parent().map_to_world(destination)

		# interpolate the position using the tweening technique
		global.tween.interpolate_method(self, "_interpolated_move", get_pos(), world_pos, ANIMATION_TIME,
										global.tween.TRANS_LINEAR, global.tween.EASE_IN)

		current_pos = destination  # update the current position

		return true

	return token_to_merge_with
