extends KinematicBody2D
class_name Actor

var is_attacking : bool = false
# var waiting_on_animation : bool = false
var is_recovering : bool = false

var velocity = Vector2()
var facing = 'south'
var sprite : AnimatedSprite
var is_enabled : bool

var damageArea : Area2D

export var max_health = 20
var health : int

var camera : Camera2D

func _ready():
	# camera = get_parent().get_parent().get_node('Camera2D')
	# print(camera)
	camera = get_tree().root.find_node('Camera2D', true, false)
	health = max_health
	sprite = $AnimatedSprite
	damageArea = $DamageArea
	if damageArea:
		# print(name + ' damage area connected')
		var _s = damageArea.connect('body_entered', self, 'take_damage')
	else:
		print(name + ' damage area is null!')

func take_damage(obj):
	# print(obj)
	# print(obj.collider)
	if 'damage' in obj:
		health -= obj.damage
		# print(name + ' took ' + str(obj.damage) + ' damage')
		# print(name + ' health: ' + str(health) + ' / ' + str(max_health))
	if health <= 0:
		on_no_health()
	if obj.has_method('on_did_damage'):
		obj.on_did_damage()

func on_no_health():
	queue_free()


func disable():
	is_enabled = false

func enable():
	is_enabled = true

func _control_animation():
	# var abs_vel = Vector2(abs(velocity.x), abs(velocity.y))
	var abs_vel = velocity.abs()
	var anim = ''
	check_recovery()
	check_attack()
	if is_recovering:
		anim = 'recover'
	elif is_attacking:
		anim = 'attack'
	elif abs_vel.x < 0.001 and abs_vel.y < 0.001:
		anim = 'idle'
	elif abs_vel.y > abs_vel.x:
		anim = 'walk'
		if velocity.y < 0:
			facing = 'north'
		else:
			facing = 'south'
	else:
		anim = 'walk'
		if velocity.x < 0:
			facing = 'west'
		else:
			facing = 'east'
	sprite.play(anim + '_' + facing)

# func determine_facing():

	# TODO use signals
func check_attack():
	if is_attacking and sprite.frame == 3:
		is_attacking = false

func check_recovery():
	if is_recovering and sprite.frame == 3:
		is_recovering = false

func is_on_screen():
	var resolution = Vector2(
		ProjectSettings.get_setting('display/window/size/width'),
		ProjectSettings.get_setting('display/window/size/height'))
	var min_x = camera.position.x - resolution.x / 2
	var max_x = camera.position.x + resolution.x / 2 
	var min_y = camera.position.y - resolution.y / 2
	var max_y = camera.position.y + resolution.y / 2
	return position.x >= min_x and position.x <= max_x and position.y >= min_y and position.y <= max_y
