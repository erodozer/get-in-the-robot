extends KinematicBody

var location = 0
var shift = 0
var power = 300 # start with 5 minutes worth of power
const MAX_POWER = 300
const MOVE_SPEED = 200  # should take 10 seconds to move around the whole ring
var hp = 100
const MAX_HP = 100

# SIGNALS
signal moved  # emit when the player moves around the area
signal updateStats
signal attack

var facing = 1
var attacking = false
onready var animation_player = $Spatial/AnimationPlayer
onready var mesh = $Spatial/Armature

func _ready():
	set_process(true)
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	# disable other input driven actions when attacking
	if attacking:
		return
		
	if event.is_action_pressed("ui_down"):
		if facing != -1:
			$Tween.interpolate_property($Spatial, "rotation", $Spatial.rotation, Vector3(0, PI, 0), .4, 0, 0)
			$Tween.start()
		facing = -1
		animation_player.play("run", .2, 3)
	if event.is_action_pressed("ui_up"):
		if facing != 1:
			$Tween.interpolate_property($Spatial, "rotation", $Spatial.rotation, Vector3(0, 0, 0), .4, 0, 0)
			$Tween.start()
		facing = 1
		animation_player.play("run", .2, 3)
	if (event.is_action_released("ui_down") and not Input.is_action_pressed("ui_up")) or \
		(event.is_action_released("ui_up") and not Input.is_action_pressed("ui_down")):
		animation_player.play("idle", .2)
	if event.is_action_pressed("attack"):
		animation_player.play("punch", .1, 1.5)
		
func _handle_movement(delta):
	var shift = 0
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		shift = 1

	#var strafe = 0
	if Input.is_action_pressed("ui_left"):
		#strafe = -1
		rotate_y(PI/2 * delta)
	elif Input.is_action_pressed("ui_right"):
		#strafe = 1
		rotate_y(-PI/2 * delta)
	
	if shift > 0:
		var forward = (
			get_global_transform().basis[2].normalized() * facing *
			MOVE_SPEED * delta
		)
		self.move_and_slide(
			forward,
			Vector3(0, -1, 0)
		)

func _process(delta):
	self.power -= delta
	emit_signal("updateStats", power / MAX_POWER)
	
	if animation_player.get_current_animation() != "punch":
		_handle_movement(delta)

func fight():
	attacking = true

func become_vulnerable():
	attacking = false
