extends Node

@export var max_health : int
var health : set = set_health

signal healthChanged(oldVal, newVal)

func set_health(value):
	if value >= max_health:
		value = max_health
	if value <= 0:
		value = 0
		if get_parent():
			if get_parent().has_method("death"):
				get_parent().death()
	if value != health:
		healthChanged.emit(health, value)
		health = value
	health = value

func _ready():
	health = max_health

func damage(attack):
	health -= attack
	print(health)
