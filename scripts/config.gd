extends Node

# Directions available for input
const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1),  # Vertical: |
	Vector2(1, 1), Vector2(-1, -1), # Diagonal: \
	Vector2(1, -1), Vector2(-1, 1)  # Diagonal: /
]

const ANIMATION_TIME = 0.1  # time to travel to the destination, in seconds
const MERGE_THRESHOLD = 20  # in pixels, distance to the destination to perform a merge
const MOVEMENT_OPACITY = 0.2  # opacity when moving
const LABEL_SCALE = Vector2(0.9, 0.9)  # scale factor when the number of digits are increased
const LABEL_OFFSET = Vector2(-5, -5)  # offset to center the label -> TODO: refactor at some point
const MODULATION_ON_MERGE = Color(1.0, 0, 0, 1.0)
const LINEAR_INTERPOLATION_SCALAR = 0.1

const MOTION_DISTANCE = 40  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.35  # Minimum distance from the 8 direction vectors to make a move

# current available challenges
const CHALLENGES = [
	{
		"name": "Challenge 0",
		"goal": 256,
		"board": "res://scenes/board_3x3.tscn"
	},
	{
		"name": "Challenge 1",
		"goal": 1024,
		"board": "res://scenes/board_4x4.tscn"
	}
]
const DEFAULT_CHALLENGE = 0
