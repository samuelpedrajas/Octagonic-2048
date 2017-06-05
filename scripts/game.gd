extends Control

const MOTION_DISTANCE = 40  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.55  # Minimum distance from the 8 direction vectors to make a move

var tap_start_position

signal user_input

func _ready():
	connect("user_input", get_node("board"), "move_token")

func _check_move(input_vector):
	if input_vector.length() > MOTION_DISTANCE:
		# Don't needed, but could improve performance?
		input_vector = input_vector.normalized()

		for direction in global.DIRECTIONS:
			# if the distance is smaller than the threshold, try to make a move
			if (direction - input_vector).length() < MINIMUM_DISTANCE_TO_MOVE:
				emit_signal("user_input", direction)

func _input_event(event):
	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.pos
	elif event.is_action_released("click"):
		# if released, erase de position and check if we can make a move
		_check_move(event.pos - tap_start_position)
		tap_start_position = null
