extends Sprite2D

@onready var LineParent :Line2D = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = deg_to_rad(LineParent.CurrentRotationDegrees)
	if(LineParent.points.size()!=0):
		position = LineParent.get_point_position(LineParent.points.size()-1)
