extends Camera2D


onready var MAX_ZOOM = Vector2(2.5, 2.5)
onready var MIN_ZOOM = Vector2(1, 1)
onready var mouse_start_pos
onready var screen_start_position
onready var dragging = false

func _ready():
	pass 

func _process(delta):
	if(Input.is_action_just_released("scroll_down")):
		zoom.x += 0.15
		zoom.y += 0.15
	if(Input.is_action_just_released("scroll_up")):
		zoom.x -= 0.15
		zoom.y -= 0.15
	zoom.x = clamp(zoom.x, MIN_ZOOM.x, MAX_ZOOM.x)
	zoom.y = clamp(zoom.y, MIN_ZOOM.y, MAX_ZOOM.y)
	

func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
