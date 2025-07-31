extends Area2D

var atk := 1
@export var knockbackWeight := 1.0
@export var parentKnockbackWeight := 0.75
@export var father : CharacterBody2D
var collisionShape

func _ready():
	area_entered.connect(hit)
	if get_child(0) is CollisionShape2D:
		collisionShape = get_child(0)
		collisionShape.disabled = true

func hit(area):
	if area.parent:
		if area.parent == father:
			return
	if area.has_method("damage"):
		area.damage(atk, self, knockbackWeight)
		if father:
			if father.has_method("receive_knockback"):
				father.receive_knockback(parentKnockbackWeight, sign(father.global_position.x - global_position.x))

func activate(frames, fps):
	monitoring = true
	monitorable = true
	collisionShape.disabled = false
	for i in frames*fps:
		await get_tree().process_frame
	collisionShape.disabled = true
	monitoring = false
	monitorable = false
