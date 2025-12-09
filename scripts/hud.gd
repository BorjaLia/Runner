extends CanvasLayer

@onready var distance_label: Label = $DistanceLabel
@onready var coin_label: Label = $CoinLabel

func _process(delta: float) -> void:
	distance_label.text = str(Global.score) + " m"
	coin_label.text = "Coins: " + str(Global.coins)
