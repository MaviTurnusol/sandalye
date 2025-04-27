extends CharacterBody2D

enum STATES { RAGDOLL, TURN }
var state = STATES.RAGDOLL : set = set_state

@onready var Skeleton = $stuff/bones/Skeleton2D
@onready var ModStack = Skeleton.get_modification_stack()
@onready var ArmRMod = ModStack.get_modification(0) as SkeletonModification2DCCDIK
@onready var FootRMod = ModStack.get_modification(1) as SkeletonModification2DCCDIK
@onready var ArmLMod = ModStack.get_modification(2) as SkeletonModification2DCCDIK
@onready var FootLMod = ModStack.get_modification(3) as SkeletonModification2DCCDIK
@onready var ArmRTarget = $"IK Targets/ArmR Target"
@onready var ArmLTarget = $"IK Targets/ArmL Target"
@onready var FootRTarget = $"IK Targets/FootR Target"
@onready var FootLTarget = $"IK Targets/FootL Target"
@onready var HeartMimic = $"IK Targets/HeartMimic"

var ArmRConstraints : PackedVector2Array = [Vector2(40, 240), Vector2(0, 260), Vector2(30, 330)]
var ArmRisReverse = [true, true, true]
var ArmLConstraints : PackedVector2Array = [Vector2(-20, 120), Vector2(160, 360), Vector2(-40, 20)]
var ArmLisReverse = [true, false, true]

func set_state(value):
	if value == STATES.TURN:
		HeartMimic.get_node("RemoteTransform2D").update_position = false
		FootLMod.set_ccdik_joint_enable_constraint(2, false)
		FootLMod.set_ccdik_joint_enable_constraint(1, false)
		FootLMod.set_ccdik_joint_enable_constraint(0, false)
		Skeleton.set_modification_stack(3)
	state = value

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		STATES.RAGDOLL:
			if !HeartMimic.is_on_floor():
				HeartMimic.velocity.y += get_gravity().y * delta
			HeartMimic.move_and_slide()
			if !ArmRTarget.is_on_floor():
				ArmRTarget.velocity.y += get_gravity().y * delta
			ArmRTarget.move_and_slide()
			if !ArmLTarget.is_on_floor():
				ArmLTarget.velocity.y += get_gravity().y * delta
			ArmLTarget.move_and_slide()
			if !FootRTarget.is_on_floor():
				FootRTarget.velocity.y += get_gravity().y * delta
			FootRTarget.move_and_slide()
			if !FootLTarget.is_on_floor():
				FootLTarget.velocity.y += get_gravity().y * delta
			FootLTarget.move_and_slide()
		STATES.TURN:
			HeartMimic.get_node("RemoteTransform2D").update_position = false
	pass
