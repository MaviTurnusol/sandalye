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
}

var CurrentRotationDegrees : float = 0
var RotationDirection : RotationStates = RotationStates.Immobile
enum RotationStates{
	RotateClockwise = 1,
	RotateAntiClockwise = -1,
	Immobile = 0
}
var RotationAtIntervals : Array[RotationStates]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
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
			
			if(RotationAtIntervals.size()!=0):
				RotationDirection = RotationAtIntervals.back()
			else:
				RotationDirection = RotationStates.Immobile
			
			CurrentRotationDegrees += (RotationDirection * RotationSpeed) * -1 * delta 
			pass
		GrowthStates.Stationary:
			pass
		
	CurrentInterval = (CurrentLength/LengthInterval)

func OnIntervalChanged(OldInterval, NewInterval):
	if(OldInterval < NewInterval):
		#add_point(Vector2.RIGHT * CurrentLength)
		if(points.size()!=0):
			add_point(get_point_position(points.size()-1)+(Vector2.RIGHT * LengthInterval).rotated(deg_to_rad(CurrentRotationDegrees)))
		else:
			add_point(Vector2.ZERO+(Vector2.RIGHT * LengthInterval).rotated(deg_to_rad(CurrentRotationDegrees)))
		RotationAtIntervals.append(RotationDirection)
	elif(OldInterval > NewInterval):
		remove_point(points.size()-1)
		RotationAtIntervals.pop_back()
