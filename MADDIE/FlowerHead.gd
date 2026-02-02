extends Sprite2D

@onready var LineParent :Line2D = get_parent()
@onready var CollisionDetector : Area2D = $Area2D

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
