extends Area2D

@export var father : CharacterBody2D
@export var invFrames := 15

signal health_depleted(val1, val2)

func _ready():
	pass # Replace with function body.

func damage(attack, attacker, atkWeight):
	$CollisionShape2D.set_deferred("disabled", true)
	$invTimer.start()
	if father:
		if father.has_method("receive_knockback"):
			father.receive_knockback(attacker, atkWeight)
		if father.get_node("hitflashPlayer"):
			father.get_node("hitflashPlayer").play("hitflash")
	GlobalScript.playerHP -= attack
	pass


func _on_inv_timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.
