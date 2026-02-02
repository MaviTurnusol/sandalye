extends Line2D

@export var MaxLength : float = 2000
@export var LengthInterval : int = 20
@export var GrowthSpeed : float = 250

@export var RotationSpeed : float = 5

var CurrentLength : float = 0

var CurrentInterval : int = 0:
	get:
		return CurrentInterval
	set(NewInterval):
		OnIntervalChanged(CurrentInterval,NewInterval)
		CurrentInterval = NewInterval

var GrowthDirection : GrowthStates = GrowthStates.Stationary

enum GrowthStates{
	Delongating = -1,
	Stationary = 0,
	Elongating = 1,
	Recalling = 999,
}

var CurrentRotationDegrees : float = 0
var RotationDirection : RotationStates = RotationStates.Immobile
enum RotationStates{
	RotateClockwise = 1,
	RotateAntiClockwise = -1,
	Immobile = 0
}
var RotationAtIntervals : Array[RotationStates]

var totalTime : float = 0
func _process(delta):
	totalTime+=delta
	for i in range(0,points.size()):
		points[i] += (Vector2.UP * 0.5 * sin(totalTime+(i/5))*delta)
		points[i] += (Vector2.RIGHT * 0.5 * cos(totalTime+(i/5))*delta)
	
	if(GrowthDirection != GrowthStates.Recalling):
		if(GrowthDirection == GrowthStates.Stationary):
			RotationDirection = RotationStates.Immobile
			if(Input.is_action_just_pressed("down")):
				GrowthDirection = GrowthStates.Delongating
			if(Input.is_action_just_pressed("up")):
				GrowthDirection = GrowthStates.Elongating
			
		if(Input.is_action_just_released("up") || Input.is_action_just_released("down")):
			GrowthDirection = GrowthStates.Stationary
	
	match GrowthDirection:
		GrowthStates.Elongating:
			CurrentLength += GrowthSpeed*delta
			CurrentLength = clampf(CurrentLength,0,MaxLength)
			
			if(CurrentLength!=MaxLength):
				if(Input.is_action_pressed("left")):
					RotationDirection = RotationStates.RotateAntiClockwise
					CurrentRotationDegrees += (RotationDirection * RotationSpeed) * delta 
					pass
				elif(Input.is_action_pressed("right")):
					RotationDirection = RotationStates.RotateClockwise
					CurrentRotationDegrees += (RotationDirection * RotationSpeed) * delta 
					pass
				else:
					RotationDirection = RotationStates.Immobile
			pass
		GrowthStates.Delongating:
			CurrentLength -= GrowthSpeed*delta
			CurrentLength = clampf(CurrentLength,0,MaxLength)
			
			if(CurrentLength == 0):
				ExitVentAtOpening()
			
			if(RotationAtIntervals.size()!=0):
				RotationDirection = RotationAtIntervals.back()
			else:
				RotationDirection = RotationStates.Immobile
			
			CurrentRotationDegrees += (RotationDirection * RotationSpeed) * -1 * delta 
			pass
		GrowthStates.Stationary:
			pass
	
	if(GrowthDirection!=GrowthStates.Recalling):
		CurrentInterval = (CurrentLength/LengthInterval)

func OnIntervalChanged(OldInterval, NewInterval):
	if(OldInterval < NewInterval):
		#add_point(Vector2.RIGHT * CurrentLength)
		if(points.size()!=0):
			add_point(get_point_position(points.size()-1)+(Vector2.UP * LengthInterval).rotated(deg_to_rad(CurrentRotationDegrees)))
		else:
			add_point(Vector2.ZERO+(Vector2.UP * LengthInterval).rotated(deg_to_rad(CurrentRotationDegrees)))
		RotationAtIntervals.append(RotationDirection)
	elif(OldInterval > NewInterval):
		if(points.size()!=0):
			remove_point(points.size()-1)
		RotationAtIntervals.pop_back()

func ExitVentAtOpening():
	RotationAtIntervals.clear()
	clear_points()
	
	get_parent().ExitVentAtStart()
	pass

func ExitVentAtNewVent(NewVentArea : Area2D):
	RotationAtIntervals.clear()
	clear_points()
	CurrentRotationDegrees = 0
	CurrentLength = 0
	CurrentInterval = 0
	GrowthDirection = GrowthStates.Stationary
	get_parent().ExitVentAtNewPosition(NewVentArea.global_position) # v2
	pass

func EMERGENCYRECALL():
	GrowthDirection = GrowthStates.Recalling
	var RecallTween = get_tree().create_tween()
	RecallTween.set_parallel(true)
	RecallTween.set_trans(Tween.TRANS_LINEAR)
	RecallTween.set_ease(Tween.EASE_IN_OUT)
	RecallTween.tween_property(self,"default_color",Color.BLACK,0.5)
	RecallTween.tween_method(RecallMethod,points.size(),0,((CurrentLength/MaxLength)*1.5)+1)
	get_parent().EmergencyExit()
	await RecallTween.finished
	GrowthDirection = GrowthStates.Stationary
	default_color = Color("00ae83")
	get_parent().ExitVent()
	RotationAtIntervals.clear()
	points.clear()
	CurrentLength = 0
	CurrentInterval = 0
	CurrentRotationDegrees = 0

func RecallMethod(interv : int ):
	var NewPoints = points
	NewPoints.resize(interv)
	points = NewPoints
	pass
