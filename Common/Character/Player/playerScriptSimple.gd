extends CharacterBody2D

var speed = 130.0
var jumpvel = -400.0

enum STATES {WALK, RUN, ROLL, IDLE, JUMP, FALL, FALL_RECOVERY, RUN_RECOVERY, WALK_RECOVERY, LIGHT_ATK_1, ON_LEDGE, LEDGE_CLIMBING}
var state = STATES.IDLE : set = set_state

@onready var anima = $Marker2D/anima
@onready var wepAnima = $Marker2D/weapon
@onready var rayCast = $Marker2D/RayCast2D

var combo = false
var comboUsed = false

func set_state(value):
	if state == value:
		if !combo && state != STATES.LIGHT_ATK_1:
			return
	if value == STATES.ROLL:
		if Input.is_action_pressed("right"):
			velocity.x = 300
			$Marker2D.scale.x = 1.0
		if Input.is_action_pressed("left"):
			velocity.x = -300
			$Marker2D.scale.x = -1.0
		playAnimWithWeapon("roll")
	if value == STATES.JUMP:
		velocity.y -= 300
		if Input.is_action_pressed("right"):
			velocity.x = 200
		if Input.is_action_pressed("left"):
			velocity.x = -200
		playAnimWithWeapon("jump")
	if value == STATES.FALL:
		playAnimWithWeapon("fall")
	if value == STATES.FALL_RECOVERY:
		playAnimWithWeapon("fallRecovery")
	if value == STATES.ON_LEDGE:
		velocity.x = 100*$Marker2D.scale.x
		playAnimWithWeapon("wallFuck")
	if value == STATES.LEDGE_CLIMBING:
		playAnimWithWeapon("ledgeClimb")
	if value == STATES.LIGHT_ATK_1:
		playAnimWithWeapon("stab")
		if combo:
			anima.frame = 2
			wepAnima.frame = 2
			comboUsed = true
		if rayCast.is_colliding():
			if is_instance_valid(rayCast.get_collider()):
				if rayCast.get_collider().is_in_group("enemy"):
					if !combo:
						velocity.x = lerp(velocity.x, (rayCast.get_collision_point().x - (position.x-sign(rayCast.get_collision_point().x - position.x)*-50+(rayCast.get_collider().velocity.x*-0.5)+(velocity.x/8.0))) * 10.5, 0.4)
					else:
						velocity.x = lerp(velocity.x, (rayCast.get_collision_point().x - (position.x-sign(rayCast.get_collision_point().x - position.x)*-40+(rayCast.get_collider().velocity.x*-0.5)+(velocity.x/8.0))) * 10.5, 0.4)
		elif Input.is_action_pressed("right"):
			velocity.x = 300
		elif Input.is_action_pressed("left"):
			velocity.x = -300
	if state == STATES.LIGHT_ATK_1:
		combo = false
	if state in [STATES.RUN] && value == STATES.IDLE:
		state = STATES.RUN_RECOVERY
		playAnimWithWeapon("runRecovery")
		return
	if state in [STATES.WALK, STATES.LIGHT_ATK_1] && value == STATES.IDLE:
		state = STATES.WALK_RECOVERY
		playAnimWithWeapon("walkRecovery")
		return

	state = value
	
func _physics_process(delta):
	
	match state:
		STATES.IDLE:
			if anima.animation == "roll":
				playAnimWithWeapon("idle")
			if velocity.x < 50 && velocity.x > -50:
				playAnimWithWeapon("idle")
			move_and_slide()
		STATES.RUN:
			playAnimWithWeapon("run")
			move_and_slide()
		STATES.WALK:
			if abs(velocity.x) <= speed * 1.35:
				playAnimWithWeapon("walk")
			move_and_slide()
		STATES.ROLL:
			if anima.animation == "roll" && anima.frame == 4:
				velocity.x = lerp(velocity.x, velocity.x/30, 0.1)
			if anima.animation == "roll" && anima.frame >= 10:
				state = STATES.IDLE
			move_and_slide()
		STATES.JUMP:
			if velocity.y > 0:
				state = STATES.FALL
			move_and_slide()
		STATES.FALL:
			if is_on_floor():
				state = STATES.FALL_RECOVERY
			move_and_slide()
			if $Marker2D/climbCast.is_colliding():
				if !$Marker2D/ledgeChecker.is_colliding():
					velocity.y = 0
					state = STATES.ON_LEDGE
		STATES.ON_LEDGE:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			if Input.is_action_just_pressed("down"):
				velocity.y += 200
				state = STATES.FALL
			move_and_slide()
			if Input.is_action_just_pressed("up"):
				state = STATES.LEDGE_CLIMBING
			if Input.is_action_just_pressed("space"):
				state = STATES.ROLL
				if Input.is_action_pressed("left"):
					$Marker2D.scale.x = -1.0
				elif Input.is_action_pressed("right"):
					$Marker2D.scale.x = 1.0
			if Input.is_action_just_pressed("jump"):
				state = STATES.JUMP
				if Input.is_action_pressed("left"):
					$Marker2D.scale.x = -1.0
				elif Input.is_action_pressed("right"):
					$Marker2D.scale.x = 1.0
		STATES.LEDGE_CLIMBING:
			move_and_slide()
			if anima.animation == "ledgeClimb" && anima.frame == 5:
				position.x += 25 * $Marker2D.scale.x
				position.y -= 80
				state = STATES.IDLE
		STATES.FALL_RECOVERY:
			velocity.x = lerp(velocity.x, velocity.x/30, 0.1)
			if anima.animation == "fallRecovery" && anima.frame == 2:
				state = STATES.IDLE
			move_and_slide()
		STATES.RUN_RECOVERY:
			velocity.x = lerp(velocity.x, velocity.x/30, 0.1)
			if anima.animation == "runRecovery" && anima.frame == 3:
				state = STATES.IDLE
			move_and_slide()
		STATES.WALK_RECOVERY:
			velocity.x = lerp(velocity.x, velocity.x/30, 0.1)
			if anima.animation == "walkRecovery" && anima.frame == 1:
				state = STATES.IDLE
			move_and_slide()
		STATES.LIGHT_ATK_1:
			velocity.x = lerp(velocity.x, velocity.x/2, 0.1)
			if anima.animation == "stab" && anima.frame == 7:
				state = STATES.IDLE
			if Input.is_action_just_pressed("lightAttack"):
				if combo:
					state = STATES.LIGHT_ATK_1
			if Input.is_action_just_pressed("space"):
				if anima.animation == "stab" && anima.frame in [5, 6, 7]:
					state = STATES.ROLL
			move_and_slide()
	
	if not is_on_floor():
		if state not in [STATES.ON_LEDGE, STATES.LEDGE_CLIMBING]:
			if state == STATES.FALL:
				velocity += get_gravity() * delta * 1.4
			else:
				velocity += get_gravity() * delta
	
	if anima.animation == "stab" && anima.frame == 5:
		$Marker2D/stabHitbox.activate(1, 10)

	var input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
	if state not in [STATES.ROLL, STATES.JUMP, STATES.FALL, STATES.FALL_RECOVERY, STATES.RUN_RECOVERY, STATES.WALK_RECOVERY, STATES.LIGHT_ATK_1, STATES.LEDGE_CLIMBING, STATES.ON_LEDGE]:
		if !is_on_floor() && velocity.y > 0:
			state = STATES.FALL
		if input.x != 0:
			if Input.is_action_pressed("run"):
				velocity.x = lerp(velocity.x, input.x * speed * 1.65, 0.1)
				if is_on_floor(): state = STATES.RUN
			else:
				velocity.x = lerp(velocity.x, input.x * speed, 0.1)
				if is_on_floor(): state = STATES.WALK
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			if is_on_floor():
				if state == STATES.RUN && abs(velocity.x) < 50:
					state = STATES.IDLE
				if state == STATES.WALK:
					state = STATES.IDLE
	
		if Input.is_action_pressed("left"):
			$Marker2D.scale.x = -1.0
			#anima.flip_h = true
		elif Input.is_action_pressed("right"):
			$Marker2D.scale.x = 1.0
			#anima.flip_h = false
		
		if Input.is_action_just_pressed("space"):
			state = STATES.ROLL
		if Input.is_action_just_pressed("jump"):
			state = STATES.JUMP
		
		if Input.is_action_just_pressed("lightAttack"):
			state = STATES.LIGHT_ATK_1

func playAnimWithWeapon(animation):
	wepAnima.sprite_frames = load("res://Items/" + "%s"%GlobalScript.currentWeapon.capitalize() + "/%s.tres"% GlobalScript.currentWeapon)
	if anima.sprite_frames.has_animation(animation): anima.play(animation)
	if wepAnima.sprite_frames.has_animation(animation):
		wepAnima.visible = true
		wepAnima.play(animation)
		wepAnima.frame = anima.frame
	else:
		wepAnima.visible = false

func receive_knockback(weight, direction):
	combo = true
	await get_tree().create_timer(0.1).timeout
	if !comboUsed:
		var input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
		if sign(input.x) != sign(direction*-1):
			velocity.x += 100.0 * weight * direction
	comboUsed = false
