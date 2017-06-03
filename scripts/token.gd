extends Node2D

const ANIMATION_TIME = 0.1

var value setget _change_value
var current_pos

func setup(pos):
	self.value = 2
	current_pos = pos
	set_pos(get_parent()._get_world_pos(pos))

func destroy():
	global.matrix.erase(current_pos)
	queue_free()

func _change_value(v):
	value = v
	get_node("token_sprite/value").text = str(v)

func _is_valid_pos(p):
	# checks if the position is inside the bounds of the matrix
	return p.x >= 0 and p.x < global.MATRIX_SIZE and p.y >= 0 and p.y < global.MATRIX_SIZE

func _check_merge(direction):
	var prev_pos = current_pos - direction

	# while is a valid position in the matrix
	while _is_valid_pos(prev_pos):
		# if there is a token
		if global.matrix.has(prev_pos):
			var prev_token = global.matrix[prev_pos]
			# if the token has the same value than the current one, merge
			if prev_token.value == value:
				prev_token.destroy()
				self.value = value * 2

				return true  # there is a merge, return true
	
			return false  # there is no merge but an obstacle, return false
		prev_pos -= direction

	return false  # not merged

func _get_destination(direction):
	var pos = current_pos
	var next_pos = pos + direction

	while _is_valid_pos(next_pos) and !global.matrix.has(next_pos):
		pos = next_pos
		next_pos += direction

	return pos

func move(direction):
	var destination = _get_destination(direction)  # e.g: destination = Vector2(2, 1)
	var merged = _check_merge(direction)

	# if it cannot be moved, there is no need to make an animation
	if current_pos == destination:
		return merged

	# update token position in the matrix
	global.matrix.erase(current_pos)
	global.matrix[destination] = self

	# get the real world position since destination is a position in the matrix
	var world_pos = get_parent()._get_world_pos(destination)

	# interpolate the position using the tweening technique
	global.tween.interpolate_method(self, "set_pos", get_pos(), world_pos, ANIMATION_TIME,
									global.tween.TRANS_LINEAR, global.tween.EASE_IN)

	# update the current position
	current_pos = destination

	return true
