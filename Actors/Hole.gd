extends Node2D


onready var offering_area : Area2D = $Area2D

var offerings = []
var drag_speed = 20

var offering_offset = Vector2(0, -15)

var ui : UIController

func _ready():
	var parent = get_parent()
	print('here', parent.name)
	parent = parent.get_parent()
	print('here', parent.name)
	ui = parent.get_node('UIController')
	print(ui)
	pass
	# offering_area.connect('body_entered', self, 'take_offering')

func _physics_process(delta):
	var bodies = offering_area.get_overlapping_bodies()
	for body in bodies:
		var obj = body
		if obj.name == 'Player':
			if obj.is_dragging:
				# obj.dragging_obj.is_being_offered = true
				offerings.push_back(obj.dragging_obj)
				obj.end_dragging()
				obj.on_offering_completed()
	# for offering in offerings:
	for i in range(offerings.size() - 1, -1, -1):
		var offering = offerings[i]
		var direction = position + offering_offset - offering.position
		var distance = direction.length()
		if distance > 0.2:
			offering.position += direction.normalized() * delta * drag_speed
			offering.timer_sprite.visible = false
			offering.current_recovery_time = 0.0
			offering.offering_started = true
		else:
			offering.set_being_offered()
			offerings.remove(i)
