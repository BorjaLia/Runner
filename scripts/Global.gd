extends Node

const LANE_WIDTH: float = 3.0 

var speed: float = 10.0
var initial_speed: float = 10.0

var score: int = 0

var coins: int = 0

func reset_game():
	score = 0
	coins = 0
	speed = initial_speed

func increase_speed(amount: float = 0.5):
	speed += amount
