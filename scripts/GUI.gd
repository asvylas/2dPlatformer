extends CanvasLayer

var maxValue
var minValue
var currentValue

onready var Player = get_parent().get_node("Player")

signal elementReady

func _ready():
	get_node("Base").get_node("NinePatchRect").get_node("LifeBar").max_value = Player.hp
	pass

func _process(delta):
	get_node("Base").get_node("NinePatchRect").get_node("LifeBar").value = Player.hp
	pass
