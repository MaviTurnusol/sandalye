extends Node2D

var IsInVents : bool = false:
	get:
		return IsInVents
	set(value):
		IsInVents = value
		UpdateVentsVisibility()

func UpdateVentsVisibility():
	visible = IsInVents
