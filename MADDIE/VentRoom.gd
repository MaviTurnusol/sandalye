extends Node2D

@onready var VisiTween : Tween = get_tree().create_tween()

func _ready() -> void:
	modulate = Color.TRANSPARENT
	visible = false

func TryShow():
	for i in get_tree().get_nodes_in_group("ventopening"):
		i.z_index = 10
	
	VisiTween.kill()
	VisiTween = get_tree().create_tween()
	self.visible = true
	VisiTween.tween_property(self, "modulate", Color.WHITE, 1.0)

func TryHide():
	for i in get_tree().get_nodes_in_group("ventopening"):
		i.z_index = i.DefaultZ
	
	VisiTween.kill()
	VisiTween = get_tree().create_tween()
	VisiTween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	await VisiTween.finished
	self.visible = false
