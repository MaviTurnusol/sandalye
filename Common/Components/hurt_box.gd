extends Area2D

@export var healthComp : Node
@export var parent : CharacterBody2D
@export var invFrames := 15

func _ready():
	pass # Replace with function body.

func damage(attack, attacker, atkWeight):
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	if parent:
		if parent.has_method("receive_knockback"):
			parent.receive_knockback(attacker, atkWeight)
		if parent.get_node("hitflashPlayer"):
			parent.get_node("hitflashPlayer").play("hitflash")
	if healthComp:
		var realDamage = clamp(attack, attack, healthComp.health)
		healthComp.damage(attack)
	for i in invFrames:
		await get_tree().process_frame
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	pass
