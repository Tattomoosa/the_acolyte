extends Actor
var player

export (int) var speed : int = 20
export (int) var run_speed : int = 28
export (int) var cooldown : int = 3
export (bool) var is_knocked_out : bool = false

var target_distance_from_player = 10 * 16
var run_distance = 7 * 16

var last_attack = 0.0

var recovery_time = 30.0
var current_recovery_time = 0.0

var is_being_offered = false
var offering_started = false
onready var shape : CollisionShape2D = $CollisionShape2D

var is_casting = false
var cast_time = 1.5
var current_cast_time = 0.0

onready var timer_sprite = $TimerSprite

func _ready():
	cooldown *= 1000
	player = get_parent().get_parent().get_node('Player')

	if is_knocked_out:
		on_no_health()

	timer_sprite.visible = false


	var vis_notifier : VisibilityNotifier2D = $VisibilityNotifier2D
	var _r = vis_notifier.connect('screen_entered', self, 'enable')
	_r = vis_notifier.connect('screen_exited', self, 'disable')
	if vis_notifier.is_on_screen():
		enable()

func act():
	if is_casting:
		return
	var direction = player.position - position
	var distance = direction.length()
	velocity = direction.normalized()
	if distance > target_distance_from_player:
		velocity = move_and_slide(velocity * speed)
	elif distance < run_distance:
		velocity = move_and_slide(-velocity * run_speed)
	else:
		velocity = Vector2()
	if velocity.length() < 1:
		if OS.get_ticks_msec() > last_attack + cooldown and is_on_screen():
			print(name, ' is on screen')
			start_attack()
			# attack(player.position)

func attack(location: Vector2):
	var fireball_scene : PackedScene = load("res://Projectiles/FireBall.tscn")
	var fireball = fireball_scene.instance()
	fireball.direction = location - position
	add_child(fireball)
	last_attack = OS.get_ticks_msec()
	is_casting = false

func start_attack():
	is_casting = true
	current_cast_time = cast_time
	$FireballSound.play()
	$ChantSound.play()


func _physics_process(delta):
	if is_enabled:
		if is_being_offered:
			sprite.play('fall')
		elif is_knocked_out:
			sprite.play('knocked_out')
			recovery_tick(delta)
		elif is_casting:
			sprite.play('attack')
			current_cast_time -= delta
			if current_cast_time < 0:
				attack(player.position)
		else:
			act()
			_control_animation()
	else:
		if is_knocked_out:
			recovery_tick(delta)


func on_no_health():
	is_knocked_out = true
	sprite.play('knocked_out')
	set_collision_layer_bit(10, false)
	set_collision_layer_bit(11, false)
	set_collision_mask_bit(0, false)
	start_recovery()

func set_being_offered():
	is_being_offered = true
	var scream : AudioStreamPlayer2D = $ScreamSound
	scream.play()
	sprite.connect('animation_finished', self, 'queue_free')

func start_recovery():
	current_recovery_time = 0.0
	timer_sprite.frame = 0
	timer_sprite.visible = true

func recovery_tick(delta):
	current_recovery_time += delta
	var slice = recovery_time / 17
	if current_recovery_time >= slice:
		if current_recovery_time > recovery_time:
			recover()
		else:
			for i in range(0, 18):
				var val = slice * (i + 1)
				if current_recovery_time < val:
					timer_sprite.frame = i
					break

func recover():
	timer_sprite.visible = false
	is_knocked_out = false
	set_collision_layer_bit(10, true)
	set_collision_layer_bit(11, true)
	set_collision_mask_bit(0, true)
	if player.dragging_obj == self:
		player.end_dragging()

func take_damage(obj):
	is_casting = false
	$FireballSound.stop()
	.take_damage(obj)
	$OnHitSound.play()
