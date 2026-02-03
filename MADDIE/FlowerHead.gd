extends Sprite2D

@onready var LineParent :Line2D = get_parent()
@onready var CollisionDetector : Area2D = $Area2D
@export var VentZoom : Vector2 = Vector2(5,5)

func _ready() -> void:
	CollisionDetector.connect("area_entered",AreaDetected)

func AreaDetected(area : Area2D):
	if(!area.is_in_group("ventopening")):
		return
	if(area!=get_parent().get_parent()):
		get_parent().ExitVentAtNewVent(area)
		position = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = deg_to_rad(LineParent.CurrentRotationDegrees)
	if(LineParent.points.size()!=0):
		position = LineParent.get_point_position(LineParent.points.size()-1)
	
	if(LineParent.visible):
		if(LineParent.GrowthDirection != LineParent.GrowthStates.Recalling):
			get_tree().get_first_node_in_group("player").get_node("Camera2D").position = position + Vector2(0,48)

func TweenCameraToPosition():
	##if($Camera2D.enabled == false):
	#global_position = get_tree().get_first_node_in_group("player").global_position
	#
	#$Camera2D.enabled = true
	#$Camera2D.make_current()
	var TweenOut = get_tree().create_tween()
	TweenOut.tween_property(get_tree().get_first_node_in_group("player").get_node("Camera2D"),"zoom",VentZoom,1)

func UnCamera(AtNewPos : bool):
	var TweenOut = get_tree().create_tween()
	TweenOut.set_parallel(true)
	TweenOut.tween_property(get_tree().get_first_node_in_group("player").get_node("Camera2D"),"zoom",Vector2(3,3),1)
	if(AtNewPos):
		get_tree().get_first_node_in_group("player").get_node("Camera2D").position = Vector2(0,0)
	else:
		TweenOut.tween_property(get_tree().get_first_node_in_group("player").get_node("Camera2D"),"position",Vector2(0,0),1)
	#$Camera2D.enabled = false
	#$Camera2D.zoom = Vector2(3,3)
