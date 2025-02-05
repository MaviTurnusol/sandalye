extends CharacterBody2D

@onready var sprites = $sprites
func playAnimationFullBody(animation):
	for child in sprites.get_children():
		child.play(animation)
