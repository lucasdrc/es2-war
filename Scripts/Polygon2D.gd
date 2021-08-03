extends Polygon2D

func _ready():
	polygon = (get_parent() as CollisionPolygon2D).polygon
