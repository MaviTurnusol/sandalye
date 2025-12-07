extends Node

var player
var playerMaxHP := 400.0
var playerHP := 50.0 : set = set_hp
var playerStamina := 100.0
var currentWeapon := "knife"

var currentLayer = 0 : set = set_layer
var currentScene

func set_layer(value):
	if value == currentLayer:
		return
	currentLayer = value
	if player:
		player.update_collisions()
	if currentScene:
		for stuff in currentScene.get_tree().get_nodes_in_group("enemy"):
			if stuff.has_node("RoomDetector"):
				stuff.get_node("RoomDetector").update_modulate()
				stuff.get_node("RoomDetector").update_collisions()
func set_hp(value):
	if value == playerHP:
		return
	if value <= 0:
		value = 0
	if value < playerHP:
		player.get_node("Marker2D/playerHurtBox").health_depleted.emit(playerHP - value)
	if value > playerMaxHP:
		value = playerMaxHP
	playerHP = value
	
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
