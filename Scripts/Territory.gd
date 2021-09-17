extends Node2D

class_name Territory

export var adjacent_names = []
onready var _Main = get_node("/root/Main")

var player_owner_index = null
var player_card_owner_index = null
var shape = null
var infantary_count = 0
var selected = false
var counter = 0

func _process(delta):
	counter += delta
	if selected:
		$Area2D/CollisionPolygon2D/Polygon2D.color.a = 0.2 + abs(sin(counter * 2))/2
	else:
		$Area2D/CollisionPolygon2D/Polygon2D.color = _Main.get_player(player_owner_index).color.color
		$Area2D/CollisionPolygon2D/Polygon2D.color.a = 0.8
