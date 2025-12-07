extends Node2D

@export var layer := 0
@export var collider : Node

func _ready():
	update_collisions()
	z_index = layer
	
func _process(_delta):
	pass
	
func update_collisions():
	if collider:
		collider.set_collision_layer_value(10+layer, true)
		collider.set_collision_mask_value(5+layer, true)
