extends Control

var tap_start_position

signal user_input

func _check_move(input_vector):
	if input_vector.length() > config.MOTION_DISTANCE:
		# Don't needed, but could improve performance?
		input_vector = input_vector.normalized()

		for direction in config.DIRECTIONS:
			# if the distance is smaller than the threshold, try to make a move
			if (direction.normalized() - input_vector).length() < config.MINIMUM_DISTANCE_TO_MOVE:
				emit_signal("user_input", direction)
				break

func _input_event(event):
	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.pos
	elif event.is_action_released("click"):
		# if released, erase de position and check if we can make a move
		_check_move(event.pos - tap_start_position)
		tap_start_position = null
