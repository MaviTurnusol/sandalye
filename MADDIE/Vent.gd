extends Area2D

@onready var InteractPrompt : Label = $InteractPrompt

var IsVentVineActive : bool = false
@onready var OwnVentVine : Line2D = $VentVine

# Called when the node enters the scene tree for the first time.
func _ready():
	InteractPrompt.visible = false
	connect("body_entered",_body_entered)
	connect("body_exited",_body_exited)
	
	#MakeVineInvisible
	OwnVentVine.visible = false
	OwnVentVine.set_process(false)

func _body_entered(body : Node2D):
	if(body.is_in_group("player")):
		playerInArea = true
		InteractPrompt.visible = true

func _body_exited(body : Node2D):
	if(body.is_in_group("player")):
		playerInArea = false
		InteractPrompt.visible = false

#STOLEN FROM DOOR CODE
var playerInArea = false
var onCooldown = false

func _input(event):
	if playerInArea:
		if(event.is_action_pressed("interact")):
			if !onCooldown && !IsVentVineActive:
				StartVenting()
				onCooldown = true
				StartCoolDown()
				print("YAY!")
		if(event.is_action_pressed("return_to_body")):
			OwnVentVine.EMERGENCYRECALL()
		

func StartCoolDown():
	await get_tree().create_timer(1.2).timeout
	onCooldown = false

func StartVenting():
	#Call Function In Player
	get_tree().get_first_node_in_group("player").StartVenting()
	
	#MakeVineVisible
	IsVentVineActive = true
	OwnVentVine.visible = true
	OwnVentVine.set_process(true)
	
	#Tween in the vents visibility
	pass

func ExitVentAtStart():
	#ExitAtStart
	ExitVent()
	get_tree().get_first_node_in_group("player").StopVenting(null)
	pass
func ExitVentAtNewPosition(AtWhatPosition : Vector2):
	ExitVent()
	get_tree().get_first_node_in_group("player").StopVenting(AtWhatPosition)
func ExitVent():
	#MakeVineInVisible
	IsVentVineActive = false
	OwnVentVine.GrowthDirection = OwnVentVine.GrowthStates.Stationary
	OwnVentVine.visible = false
	OwnVentVine.set_process(false)
	#Tween out the vents visibility
func EmergencyExit():
	get_tree().get_first_node_in_group("player").StopVenting(null)
	pass
