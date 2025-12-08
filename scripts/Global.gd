extends Node

const LANE_WIDTH: float = 3.0 

var speed: float = 10.0

var initial_speed: float = 10.0

var score: int = 0

var high_score: int = 0

func reset_game():
	score = 0
	speed = initial_speed

func increase_speed(amount: float = 0.5):
	speed += amount
