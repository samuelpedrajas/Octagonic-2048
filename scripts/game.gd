extends Control

const MOTION_DISTANCE = 40  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.45  # Minimum distance from the 8 direction vectors to make a move

var tap_start_position

signal user_input

func _ready():
	connect("user_input", get_node("board"), "move_token")

func _check_move(d):
	if d.length() > MOTION_DISTANCE:
		# Don't needed, but could improve performance?
		d = d.normalized()

		# Add all 8 directions
		for i in range(-1, 2):
			for j in range(-1, 2):
				if i == 0 and j == 0:
					continue

				# create a direction in the plane
				var v = Vector2(i, j)

				# if the distance is smaller than the threshold, try to make a move
				if (v - d).length() < MINIMUM_DISTANCE_TO_MOVE:
					emit_signal("user_input", v)

func _input_event(event):
	if global.moving:
		return

	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.pos
	elif event.is_action_released("click"):
		# if released, erase de position
		_check_move(event.pos - tap_start_position)
		tap_start_position = null
