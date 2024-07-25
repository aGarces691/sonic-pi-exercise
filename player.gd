extends CharacterBody2D

@export_category('Movement')
@export_range(100, 1000) var MAX_SPEED : float = 300
@export_range(0.1, 1500.00) var MAX_ACCELERATION : float = 1500
@export_range(0.1, 1500.00) var MAX_DECELERATION : float = 1000
@export_range(500, 5000.00) var MAX_TURN_SPEED : float = 5000

@export_category('Air Movement')
@export_range(0.1, 1500.00) var MAX_AIR_ACCELERATION : float = 500
@export_range(0.1, 1500.00) var MAX_AIR_DECELERATION : float = 333 
@export_range(500, 5000.00) var MAX_AIR_TURN_SPEED : float = 800

@export_category('Jump')
@export_range(100, 500) var jump_height : float = 170
@export_range(0.1, 0.99) var jump_time_to_peak : float = 0.35
@export_range(0.1, 0.99) var jump_time_to_descent : float = 0.25
@export var DOUBLE_JUMP = false


@export_category('ASSIST')
@export var COYOTE_TIME = 200.0
@export var JUMP_BUFFER = 200.0
@export var TERMINAL_VELOCITY = 200.0
@export_range(0, 20) var holaaa = 14
@export var VARIABLE_HEIGHT = 200.0

#JUMP CALCULATIONS
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

#MOVEMENT CALCULATIONS
@onready var acceleration
@onready var deceleration
@onready var turn_speed
@onready var max_speed_change = 0.0

func _physics_process(delta):
	#Validar si habra movimiento estatico o acelerado
	#Agregar jump variable height
	#Agregar jump buffer
	#Agregar coyote time
	run_with_acceleration(delta)
	velocity.y += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	move_and_slide()
	
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity
	
#MOVEMENT
func run_with_acceleration(delta):
	#print(desired_velocity)
	var horizontal_input := Input.get_axis("move_left", "move_right")
	acceleration = MAX_ACCELERATION if is_on_floor() else MAX_AIR_ACCELERATION
	deceleration = MAX_DECELERATION if is_on_floor() else MAX_AIR_DECELERATION
	turn_speed = MAX_TURN_SPEED if is_on_floor() else MAX_AIR_TURN_SPEED
	#print(velocity.x)
	if horizontal_input != 0.0:
		if sign(horizontal_input) != sign(velocity.x) and velocity.x != 0.0:
			var max_speed_change = turn_speed * delta
			velocity.x = move_toward(velocity.x, 0, max_speed_change)
		else:
			var max_speed_change = acceleration * delta
			velocity.x = move_toward(velocity.x, horizontal_input * MAX_SPEED, max_speed_change)
	else:
		var max_speed_change = deceleration * delta
		velocity.x = move_toward(velocity.x, 0, max_speed_change)
	
	


	print("Tu velocidad en X ES " + str(velocity.x))

