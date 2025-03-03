extends CharacterBody2D

@onready var sprites = $sprites
var animationNextToPlay
var currentAnim

signal exitAnimEnd

func _ready():
	velocity.x = 300

func playAnimationFullBody(animation):
	for child in $sprites.get_children():
		if child.animation != animation:
			child.play(animation)
			currentAnim = animation

func playAnimationFullBodyBackwards(animation):
	for child in $sprites.get_children():
		if child.animation != animation:
			child.play_backwards(animation)
			currentAnim = animation

func playAnimationConsequtively(anim1, anim2):
	if currentAnim == anim2:
		return
	for child in $sprites.get_children():
		if child.animation != anim1:
			child.play(anim1)
			currentAnim = anim1
		animationNextToPlay = anim2
		if !child.animation_finished.is_connected(AnimationFinished):
			child.animation_finished.connect(AnimationFinished)

func AnimationFinished():
	playAnimationFullBody(animationNextToPlay)

	exitAnimEnd.emit()
	for child in $sprites.get_children():
		if child.animation_finished.is_connected(ExitAnimationFinished):
			child.animation_finished.disconnect(ExitAnimationFinished)

func PlayExitAnimation(animation):
	for child in $sprites.get_children():
		if !child.animation_finished.is_connected(ExitAnimationFinished):
			child.animation_finished.connect(ExitAnimationFinished)
		child.play(animation)

func PlayExitAnimationBackwards(animation):
	for child in $sprites.get_children():
		if !child.animation_finished.is_connected(ExitAnimationFinished):
			child.animation_finished.connect(ExitAnimationFinished)
		child.play_backwards(animation)

func TurnSprites(direction):
	match direction:
		"left":
			$sprites.scale.x = -1
		"right":
			$sprites.scale.x = 1
