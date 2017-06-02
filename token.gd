extends Node2D

const ANIMATION_TIME = 0.1

var value setget _change_value
var current_pos

func destroy():
	global.matrix.erase(current_pos)
	queue_free()

func _change_value(v):
	value = v
	get_node("token_sprite/value").text = str(v)

func setup(pos):
	value = 2
	current_pos = pos
	set_pos(get_parent()._get_world_pos(pos))

func _is_valid_pos(p):
	return p.x >= 0 and p.x < global.MATRIX_SIZE and p.y >= 0 and p.y < global.MATRIX_SIZE

func _check_fusion(direction):
	var prev_pos = current_pos - direction

	while _is_valid_pos(prev_pos):
		if global.matrix.has(prev_pos):
			var prev_token = global.matrix[prev_pos]
			if prev_token.value == value:
				prev_token.destroy()
				self.value = value * 2
				return true
			return false
		prev_pos -= direction
	return false

func _get_destination(direction):
	var pos = current_pos
	var next_pos = pos + direction

	while _is_valid_pos(next_pos) and !global.matrix.has(next_pos):
		pos = next_pos
		next_pos += direction

	return pos

func move(direction):
	var destination = _get_destination(direction)
	var changed = _check_fusion(direction)

	if current_pos == destination and !changed:
		return false

	global.matrix.erase(current_pos)
	global.matrix[destination] = self

	var world_pos = get_parent()._get_world_pos(destination)

	global.tween.interpolate_method(self, "set_pos", get_pos(), world_pos, ANIMATION_TIME,
									global.tween.TRANS_LINEAR, global.tween.EASE_IN)
	current_pos = destination

	return true
