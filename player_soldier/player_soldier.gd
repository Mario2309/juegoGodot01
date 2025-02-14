extends CharacterBody2D

@export var gravity_scale = 2
@export var speed = 250
@export var acceleration = 500
@export var friction = 1500
@export var air_acceleration = 2000
@export var jump_force = -700
@export var air_friction = 700

@onready var ani_player = $ani_player_soldier

var targed = position

func apply_gravity(delta):
	if not is_on_floor():
		velocity+=get_gravity() * delta * gravity_scale

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, acceleration*delta)

func apply_friction(input_axis, delta):
	if input_axis==0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction*delta)
		

func handle_jump():
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = jump_force

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, air_acceleration *delta)

func update_animation(input_axis):
	if input_axis !=0:
		if Input.is_action_pressed("correr"):
			# velocidad de la animación será dependiente de la velocidad
			ani_player.speed_scale = velocity.length()/100
			ani_player.flip_h = (input_axis<0)
			ani_player.play("run")
		else:
			ani_player.play("walk")
	elif not is_on_floor():
		ani_player.play("jump")
	elif is_on_floor() and  Input.is_action_pressed("disparar_01"):
		ani_player.play("shot_01")
	elif is_on_floor() and  Input.is_action_pressed("disparar_02"):
		ani_player.play("shot_02")
	elif is_on_floor() and  Input.is_action_pressed("granada"):
		ani_player.play("granade")
	elif is_on_floor() and  Input.is_action_pressed("recargar"):
		ani_player.play("recharge")
	else:
		ani_player.speed_scale=1
		ani_player.play("idle")

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	
