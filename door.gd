extends Area2D

@export var room1 := Node
@export var room2 = Node
var playerInArea = false
var onCooldown = false

func _ready():
	update_collisions()
	pass # Replace with function body.

func _process(_delta):
	if playerInArea:
		if Input.is_action_just_pressed("interact"):
			if GlobalScript.currentLayer == room1.layer:
				if !onCooldown:
					GlobalScript.currentLayer = room2.layer
					GlobalScript.player.update_collisions()
					var twink = get_tree().create_tween()
					twink.tween_property(room1, "modulate", Color.TRANSPARENT, 1.0)
					var twink2 = get_tree().create_tween()
					twink2.tween_property(room2, "modulate", Color.WHITE, 1.0)
					$cooldown.start()
					onCooldown = true
					print(GlobalScript.currentLayer)
			elif GlobalScript.currentLayer == room2.layer:
				if !onCooldown:
					GlobalScript.currentLayer = room1.layer
					GlobalScript.player.update_collisions()
					var twink = get_tree().create_tween()
					twink.tween_property(room2, "modulate", Color.TRANSPARENT, 1.0)
					var twink2 = get_tree().create_tween()
					twink2.tween_property(room1, "modulate", Color.WHITE, 1.0)
					$cooldown.start()
					onCooldown = true
					print(GlobalScript.currentLayer)
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		playerInArea = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false

func update_collisions():
	if room1:
		set_collision_layer_value(room1.layer+10, true)
		set_collision_mask_value(room1.layer+5, true)
	if room2:
		set_collision_layer_value(room2.layer+10, true)
		set_collision_mask_value(room2.layer+5, true)


func _on_cooldown_timeout():
	onCooldown = false
