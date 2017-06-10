extends Node

const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1),  # Vertical: |
	Vector2(1, 1), Vector2(-1, -1), # Diagonal: \
	Vector2(1, -1), Vector2(-1, 1)  # Diagonal: /
]

const ANIMATION_TIME = 0.1
const MERGE_THRESHOLD = 20
const MOVEMENT_OPACITY = 0.2
const LABEL_SCALE = Vector2(0.9, 0.9)
const LABEL_OFFSET = Vector2(-5, -5)

const MOTION_DISTANCE = 40  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.55  # Minimum distance from the 8 direction vectors to make a move

const CHALLENGES = [
	{
		"name": "Challenge 0",
		"goal": 256,
		"board": "res://scenes/board_3x3.tscn"
	}
]
const DEFAULT_CHALLENGE = 0
