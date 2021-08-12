extends Node2D

export var adjacent_names = []
onready var Main = get_node("/root/Main")

var player_owner_index = null
var player_card_owner_index = null
var shape = null
var infantary_count = 0

func _process(delta):
	$Area2D/CollisionPolygon2D/Polygon2D.color = Main.get_player(player_owner_index).color.color
