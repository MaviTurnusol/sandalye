extends Node

@export var layer = 0
@export var hitboxes: Array[CollisionShape2D]
@export var bodies: Array[CharacterBody2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_collisions():
	if GlobalScript.currentLayer == layer:
		for hitbox in hitboxes:
			hitbox.set_deferred("disabled", false)
	else:
		for hitbox in hitboxes:
			hitbox.set_deferred("disabled", true)
	pass

func update_modulate():
	if GlobalScript.currentLayer == layer:
		var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		twink.tween_property(get_parent(), "modulate", Color.WHITE, 1.0)
	else:
		var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		twink.tween_property(get_parent(), "modulate", Color.TRANSPARENT, 1.0)
