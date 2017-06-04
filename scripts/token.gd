extends Node2D

const ANIMATION_TIME = 0.1
const MERGE_THRESHOLD = 100

var value setget _change_value
var token_to_merge = null
var current_pos

func setup(pos):
	self.value = 2
	current_pos = pos
	set_pos(get_parent()._get_world_pos(pos))

func _change_value(v):
	value = v
	get_node("token_sprite/value").text = str(v)

func _interpolated_move(pos):
	if token_to_merge:
		var world_current_pos = get_parent()._get_world_pos(current_pos)
		var d = (world_current_pos - pos).length()

		if d < MERGE_THRESHOLD:
			token_to_merge.value *= 2
			token_to_merge = null
			queue_free()
			return

	set_pos(pos)

func move(direction):
	var destination = current_pos
	var next_pos = current_pos + direction

	while global.is_valid_pos(next_pos):
		print("TOKEN: ", current_pos, " destination: ", destination, " next_pos: ", next_pos)
		if global.matrix.has(next_pos):
			var token = global.matrix[next_pos]
			token.move(direction)
			if token.token_to_merge or token.value != value:
				destination = token.current_pos - direction
			else:
				destination = token.current_pos
				token_to_merge = token
			break
		destination = next_pos
		next_pos += direction

	# update token position in the matrix if it's not destroyed
	if !token_to_merge:
		global.matrix[destination] = self

	if current_pos != destination:
		global.matrix.erase(current_pos)
		
		# get the real world position since destination is a position in the matrix
		var world_pos = get_parent()._get_world_pos(destination)

		# interpolate the position using the tweening technique
		global.tween.interpolate_method(self, "_interpolated_move", get_pos(), world_pos, ANIMATION_TIME,
										global.tween.TRANS_LINEAR, global.tween.EASE_IN)

		# update the current position
		current_pos = destination

		return true

	return token_to_merge
