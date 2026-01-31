extends Area2D

@onready var InteractPrompt : Label = $InteractPrompt

# Called when the node enters the scene tree for the first time.
func _ready():
	InteractPrompt.visible = false
	connect("body_entered",_body_entered)
	connect("body_exited",_body_exited)
	
	update_collisions()

func _body_entered(body : Node2D):
	if(body.is_in_group("player")):
		playerInArea = true
		InteractPrompt.visible = true

func _body_exited(body : Node2D):
	if(body.is_in_group("player")):
		playerInArea = false
		InteractPrompt.visible = false

#STOLEN FROM DOOR CODE
@export var OwnRoom := Node
@export var VentRoom = Node
var playerInArea = false
var onCooldown = false

func _input(event):
	if playerInArea && event.is_action_pressed("interact"):
		if GlobalScript.currentLayer == OwnRoom.layer:
			if !onCooldown:
				GlobalScript.currentLayer = VentRoom.layer
				GlobalScript.player.update_collisions()
				var twink = get_tree().create_tween()
				twink.tween_property(OwnRoom, "modulate", Color.TRANSPARENT, 1.0)
				var twink2 = get_tree().create_tween()
				twink2.tween_property(VentRoom, "modulate", Color.WHITE, 1.0)
				$cooldown.start()
				onCooldown = true
				print(GlobalScript.currentLayer)
		elif GlobalScript.currentLayer == VentRoom.layer:
			if !onCooldown:
				GlobalScript.currentLayer = OwnRoom.layer
				GlobalScript.player.update_collisions()
				var twink = get_tree().create_tween()
				twink.tween_property(VentRoom, "modulate", Color.TRANSPARENT, 1.0)
				var twink2 = get_tree().create_tween()
				twink2.tween_property(OwnRoom, "modulate", Color.WHITE, 1.0)
				$cooldown.start()
				onCooldown = true
				print(GlobalScript.currentLayer)

func update_collisions():
	return
	
	#if OwnRoom:
		#set_collision_layer_value(OwnRoom.layer+10, true)
		#set_collision_mask_value(OwnRoom.layer+5, true)
	#if VentRoom:
		#set_collision_layer_value(VentRoom.layer+10, true)
		#set_collision_mask_value(VentRoom.layer+5, true)

func _on_cooldown_timeout():
	onCooldown = false
