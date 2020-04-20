extends Camera2D

var size : Vector2

onready var north_edge : Area2D = $Edges/North
onready var south_edge : Area2D = $Edges/South
onready var east_edge : Area2D = $Edges/East
onready var west_edge : Area2D = $Edges/West

onready var viewport = get_viewport()

func _ready():
	size = viewport.size + Vector2(16.0, 13.0)
	# print(size)
	var _c = north_edge.connect('body_entered', self, 'pan_by_screensize', [Vector2.UP])
	_c = south_edge.connect('body_entered', self, 'pan_by_screensize', [Vector2.DOWN])
	_c = east_edge.connect('body_entered', self, 'pan_by_screensize', [Vector2.RIGHT])
	_c = west_edge.connect('body_entered', self, 'pan_by_screensize', [Vector2.LEFT])
	align()

func pan_by_screensize(obj, direction: Vector2):
	if obj.name != 'Player':
		obj.position += direction * 32.0
		return
	obj.position += direction * 32.0
	direction = direction.normalized()
	position += direction * size
	align()

func align():
	# TODO don't let go negative
	var x_pos = int(position.x)
	var y_pos = int(position.y)
	var x_rem = (int(x_pos)) % 16
	var y_rem = (int(y_pos) - 8) % 16
	if x_rem <= 8:
		position.x = x_pos - x_rem
	else:
		position.x = x_pos + (16 - x_rem)

	if y_rem <= 8:
		position.y = y_pos - y_rem
	else:
		position.y = y_pos + (16 - y_rem)

