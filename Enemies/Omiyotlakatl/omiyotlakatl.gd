extends CharacterBody2D

enum STATES { RAGDOLL, TURN, WALK, WALK_BACKWARDS }
var state = STATES.WALK : set = set_state

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

var FLTargetPos
var FRTargetPos
var armLattacking = false
var armRattacking = false

func set_state(value):
	if value == STATES.TURN:
		$"IK Targets/anima".play("turnLeft")
		
	state = value
func _ready():
	FLTargetPos = to_global($"IK Targets/HeartMimic/FootLCast".target_position)
	FRTargetPos = to_global($"IK Targets/HeartMimic/FootRCast".target_position)
	await get_tree().create_timer(5).timeout
	state = STATES.WALK_BACKWARDS
	await get_tree().create_timer(5).timeout
	state = STATES.WALK
	await get_tree().create_timer(5).timeout
	state = STATES.WALK_BACKWARDS
	await get_tree().create_timer(5).timeout
	state = STATES.WALK
	pass # Replace with function body.

func _physics_process(delta):
	match state:
		STATES.RAGDOLL:
			HeartMimic.velocity.x = lerp(HeartMimic.velocity.x, 0.0, 0.1)
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
			#ArmRTarget.global_position = get_global_mouse_position()
			pass
		STATES.WALK:
			if $targetRefresh.is_stopped(): $targetRefresh.start()
			if $attackTimer1.is_stopped(): $attackTimer1.start(randf_range(3, 12))
			if $attackTimer2.is_stopped(): $attackTimer2.start(randf_range(6, 16))
			HeartMimic.velocity.x = lerp(HeartMimic.velocity.x, 100.0, 0.1)
			stabilize_arm_r()
			stabilize_arm_l()
			HeartMimic.move_and_slide()
			FootRTarget.velocity.y += get_gravity().y * delta
			FootRTarget.move_and_slide()
			if !FootLTarget.is_on_floor():
				FootLTarget.velocity.y += get_gravity().y * delta
			FootLTarget.move_and_slide()
			FootLTarget.global_position = lerp(FootLTarget.global_position, FLTargetPos, 0.1)
			FootRTarget.global_position = lerp(FootRTarget.global_position, FRTargetPos, 0.1)
			FootLTarget.velocity.x = lerp(FootLTarget.velocity.x, 0.0, 0.1)
			FootRTarget.velocity.x = lerp(FootRTarget.velocity.x, 0.0, 0.1)
			$"IK Targets/HeartMimic/FootRCast".target_position = Vector2(140, 90)
			$"IK Targets/HeartMimic/FootLCast".target_position = Vector2(140, 90)
		STATES.WALK_BACKWARDS:
			if $targetRefresh.is_stopped(): $targetRefresh.start()
			if $attackTimer1.is_stopped(): $attackTimer1.start(randf_range(3, 12))
			if $attackTimer2.is_stopped(): $attackTimer2.start(randf_range(6, 16))
			HeartMimic.velocity.x = lerp(HeartMimic.velocity.x, -100.0, 0.1)
			stabilize_arm_r()
			stabilize_arm_l()
			HeartMimic.move_and_slide()
			FootRTarget.velocity.y += get_gravity().y * delta
			FootRTarget.move_and_slide()
			if !FootLTarget.is_on_floor():
				FootLTarget.velocity.y += get_gravity().y * delta
			FootLTarget.move_and_slide()
			FootLTarget.global_position = lerp(FootLTarget.global_position, FLTargetPos, 0.1)
			FootRTarget.global_position = lerp(FootRTarget.global_position, FRTargetPos, 0.1)
			FootLTarget.velocity.x = lerp(FootLTarget.velocity.x, 0.0, 0.1)
			FootRTarget.velocity.x = lerp(FootRTarget.velocity.x, 0.0, 0.1)
			$"IK Targets/HeartMimic/FootRCast".target_position = Vector2(-40, 90)
			$"IK Targets/HeartMimic/FootLCast".target_position = Vector2(-40, 90)
	pass

func stabilize_arm_r():
	if ArmRTarget.global_position.distance_to($"IK Targets/HeartMimic/ArmRMarker".global_position) > 5:
		ArmRTarget.velocity.x = lerp(ArmRTarget.velocity.x, sign($"IK Targets/HeartMimic/ArmRMarker".global_position.x-ArmRTarget.global_position.x) * 200, 0.05)
		ArmRTarget.velocity.y = lerp(ArmRTarget.velocity.y, sign($"IK Targets/HeartMimic/ArmRMarker".global_position.y-ArmRTarget.global_position.y) * 400, 0.01)
	else:
		ArmRTarget.velocity.x = lerp(ArmRTarget.velocity.x, sign($"IK Targets/HeartMimic/ArmRMarker".global_position.x-ArmRTarget.global_position.x) * -200, 0.05)
		ArmRTarget.velocity.y = lerp(ArmRTarget.velocity.y, sign($"IK Targets/HeartMimic/ArmRMarker".global_position.y-ArmRTarget.global_position.y) * -400, 0.01)
	if ArmRTarget.global_position.y > $"IK Targets/HeartMimic/ArmRMarker".global_position.y:
		ArmRTarget.velocity.y = lerp(ArmRTarget.velocity.y, -100.0, 0.05)
	else:
		ArmRTarget.velocity.y = lerp(ArmRTarget.velocity.y, 100.0, 0.05)
	ArmRTarget.move_and_slide()

func stabilize_arm_l():
	if ArmLTarget.global_position.distance_to($"IK Targets/HeartMimic/ArmLMarker".global_position) > 5:
		ArmLTarget.velocity.x = lerp(ArmLTarget.velocity.x, sign($"IK Targets/HeartMimic/ArmLMarker".global_position.x-ArmLTarget.global_position.x) * 200, 0.05)
		ArmLTarget.velocity.y = lerp(ArmLTarget.velocity.y, sign($"IK Targets/HeartMimic/ArmLMarker".global_position.y-ArmLTarget.global_position.y) * 400, 0.01)
	else:
		ArmLTarget.velocity.x = lerp(ArmLTarget.velocity.x, sign($"IK Targets/HeartMimic/ArmLMarker".global_position.x-ArmLTarget.global_position.x) * -200, 0.05)
		ArmLTarget.velocity.y = lerp(ArmLTarget.velocity.y, sign($"IK Targets/HeartMimic/ArmLMarker".global_position.y-ArmLTarget.global_position.y) * -400, 0.01)
	if ArmLTarget.global_position.y > $"IK Targets/HeartMimic/ArmLMarker".global_position.y:
		ArmLTarget.velocity.y = lerp(ArmLTarget.velocity.y, -100.0, 0.05)
	else:
		ArmLTarget.velocity.y = lerp(ArmLTarget.velocity.y, 100.0, 0.05)
	ArmLTarget.move_and_slide()
func attack_arm_l():
	
	armLattacking = true
	var armltween1 = get_tree().create_tween()
	armltween1.tween_property(ArmLTarget, "position", ArmLTarget.position + Vector2(129, 13), 0.4)
	await get_tree().create_timer(0.45).timeout
	if state == STATES.WALK:
		var armltween2 = get_tree().create_tween()
		armltween2.tween_property(ArmLTarget, "position", ArmLTarget.position + Vector2(144, 150), 0.2)
		await get_tree().create_timer(0.45).timeout
	elif state == STATES.WALK_BACKWARDS:
		var armltween2 = get_tree().create_tween()
		armltween2.tween_property(ArmLTarget, "position", ArmLTarget.position + Vector2(74, 150), 0.2)
	armLattacking = false
	
func attack_arm_r():
	
	armRattacking = true
	var armrtween1 = get_tree().create_tween()
	var waitTime = randf_range(0.4, 0.7)
	armrtween1.tween_property(ArmRTarget, "position", ArmRTarget.position + Vector2(32, -38), waitTime)
	await get_tree().create_timer(waitTime+0.1).timeout
	if state == STATES.WALK:
		var armltween2 = get_tree().create_tween()
		armltween2.tween_property(ArmRTarget, "position", ArmRTarget.position + Vector2(50, 150), 0.1)
		await get_tree().create_timer(0.45).timeout
	elif state == STATES.WALK_BACKWARDS:
		var armltween2 = get_tree().create_tween()
		armltween2.tween_property(ArmRTarget, "position", ArmRTarget.position + Vector2(0, 150), 0.1)
	armRattacking = false
	
func _on_target_refresh_timeout():
	if $"IK Targets/HeartMimic/FootLCast".is_colliding():
		FLTargetPos = $"IK Targets/HeartMimic/FootLCast".get_collision_point()
		if state == STATES.WALK:
			FootLTarget.velocity.y -= 100
			FootLTarget.velocity.x = 100
		elif state == STATES.WALK_BACKWARDS:
			FootLTarget.velocity.y -= 100
			FootLTarget.velocity.x = -100
	await get_tree().create_timer(0.5).timeout
	if $"IK Targets/HeartMimic/FootRCast".is_colliding():
		FRTargetPos = $"IK Targets/HeartMimic/FootRCast".get_collision_point()
		FootRTarget.velocity.y -= 100
	pass # Replace with function body.

func receive_knockback(attacker, atkWeight):
	HeartMimic.velocity.x += 70.0 * atkWeight * sign(global_position.x - attacker.global_position.x)
	
func _on_attack_timer_1_timeout():
	attack_arm_l()
	pass # Replace with function body.


func _on_attack_timer_2_timeout():
	attack_arm_r()
	pass # Replace with function body.

func death():
	state = STATES.RAGDOLL
	await get_tree().create_timer(0.75).timeout
	var twink = get_tree().create_tween()
	twink.tween_property(self, "modulate", Color.TRANSPARENT, 0.75)
	await get_tree().create_timer(0.75).timeout
	queue_free()
