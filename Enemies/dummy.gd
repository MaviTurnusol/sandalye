extends CharacterBody2D

func receive_knockback(attacker, atkWeight):
	var twink = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	twink.tween_property(self, "rotation_degrees", sign(global_position.x - attacker.global_position.x)*atkWeight*20.0, 0.15)
	twink.tween_property(self, "rotation_degrees", 0.0, 0.75)

func death():
	queue_free()
