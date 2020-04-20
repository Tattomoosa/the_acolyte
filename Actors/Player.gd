extends Actor
class_name Player

var offerings_to_win = 13

export (int) var speed = 100
export (int) var drag_speed = 35

onready var atk_north : Area2D = $AttackAreas/North
onready var atk_south : Area2D = $AttackAreas/South
onready var atk_east  : Area2D = $AttackAreas/East
onready var atk_west  : Area2D = $AttackAreas/West
var used_atk = false
var damage = 1
var dragging_obj = null

onready var drag_targets : Area2D = $DragTarget
var is_dragging = false

var healthUI : Label
var offeringUI : Label

var offerings_completed = 0


func _ready():
	var root_node = get_tree().root.get_node('Game')
	healthUI = root_node.get_node('Camera2D/HpLabel')
	offeringUI = root_node.get_node('Camera2D/OfferingsLabel')
	update_health_ui()
	# update_offerings_ui()

func get_input():
	velocity = Vector2()
	if not is_enabled:
		return
	# attack unless we can drag
	# TODO if dragging stop
	if Input.is_action_just_pressed('attack'):
		# if dragging, stop dragging
		if is_dragging:
			# TODO
			end_dragging()
			pass
		else:
			# check for knocked out
			var bodies = get_enemies_hit()
			for body in bodies:
				var obj = body.get_parent()
				if 'is_knocked_out' in obj and obj.is_knocked_out:
					# print('attacking a knocked out person')
					var offset = obj.position - position
					obj.get_parent().remove_child(obj)
					add_child(obj)
					dragging_obj = obj
					obj.position = offset
					turn_around()
					is_dragging = true
					break # only drag one
			if not is_dragging:
				is_attacking = true
	if is_attacking or is_recovering:
		return 
	if Input.is_action_pressed('move_south'):
		facing = 'south'
		velocity.y += 1
	if Input.is_action_pressed('move_north'):
		facing = 'north'
		velocity.y -= 1
	if Input.is_action_pressed('move_west'):
		facing = 'west'
		velocity.x -= 1
	if Input.is_action_pressed('move_east'):
		facing = 'east'
		velocity.x += 1
	velocity = velocity.normalized()

func _physics_process(delta):
	if not is_enabled:
		return
	if is_recovering:
		velocity *= 0.8
	else:
		get_input()

	var s = speed
	if is_dragging:
		var drag : AudioStreamPlayer2D = $Drag
		if velocity.length() > 0.5 and not drag.playing:
			drag.play()
		s = drag_speed
		_move_dragged_object_towards_drag_target(delta)
	var _vel = move_and_slide(velocity * s)
	_control_animation()

func _move_dragged_object_towards_drag_target(delta):
	var target = drag_targets.get_node(facing)
	if not target:
		print('error no drag target')
		return
	var direction = target.position - dragging_obj.position
	# direction = direction.normalized()
	dragging_obj.position += direction * delta

func end_dragging():
	remove_child(dragging_obj)
	get_parent().add_child(dragging_obj)
	dragging_obj.position = position + dragging_obj.position
	dragging_obj = null
	is_dragging = false

func take_damage(obj):
	.take_damage(obj)
	velocity = (position - obj.position).normalized() * 2
	# velocity = obj.velocity.normalized() * 2
	if is_dragging:
		end_dragging()
	sprite.frame = 0
	$OnHit.play()
	is_recovering = true
	update_health_ui()

func update_health_ui():
	healthUI.text = 'HP: ' + str(health) + ' / ' + str(max_health)

func check_attack():
	var bodies
	if not used_atk and is_attacking and sprite.frame == 2:
		bodies = get_enemies_hit()
		# print('hit bodies:', bodies)
		if bodies.size() > 0:
			$Punch.play()
			used_atk = true
			for body in bodies:
				var obj = body.get_parent()
				# print('hit: ', obj.name)
				if obj.has_method('take_damage'):
					obj.take_damage(self)
	else:
		.check_attack()
	if not is_attacking:
		used_atk = false

func get_enemies_hit():
	if facing == 'north':
		return atk_north.get_overlapping_areas()
	elif facing == 'south':
		return atk_south.get_overlapping_areas()
	elif facing == 'east':
		return atk_east.get_overlapping_areas()
	elif facing == 'west':
		return atk_west.get_overlapping_areas()

func _control_animation():
	if not is_dragging:
		._control_animation()
	else:
		# face_dragging()
		sprite.play('drag_' + facing)

func turn_around():
	if facing == 'north':
		facing = 'south'
	elif facing == 'south':
		facing = 'north'
	elif facing == 'east':
		facing = 'west'
	elif facing == 'west':
		facing = 'east'

func face_dragging():
	var difference = dragging_obj.position - position
	difference = difference.abs()
	var abs_vel = velocity.abs()
	if abs_vel.x > abs_vel.y:
		if dragging_obj.position.x < position.x:
			facing = 'west'
		elif dragging_obj.position.x > position.x:
			facing = 'east'
	else:
		if dragging_obj.position.y < position.y:
			facing = 'north'
		elif dragging_obj.position.y > position.y:
			facing = 'south'

func on_offering_completed():
	offerings_completed += 1
	if offerings_completed >= offerings_to_win:
		get_tree().change_scene("res://Ending/Ending.tscn")
	update_offerings_ui()
	max_health += 1
	health = max_health
	update_health_ui()

func update_offerings_ui():
	offeringUI.text = 'offerings: ' + str(offerings_completed) + ' / ' + str(offerings_to_win)

func play(string):
	sprite.play(string)

func on_no_health():
		get_tree().change_scene("res://UI/GameOver.tscn")