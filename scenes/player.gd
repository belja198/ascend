extends CharacterBody2D
class_name Player

@export var speed: float = 100.0;

var is_floating: bool = false;
@onready var float_sprite: Sprite2D = $FloatSprite;
@onready var sprite: Sprite2D = $Sprite2D;

@onready var jump_raycast_1: RayCast2D = $JumpAllowRaycast1;
@onready var jump_raycast_2: RayCast2D = $JumpAllowRaycast2;
@onready var collision_shape_jumping: CollisionShape2D = $CollisionShapeJumping;
@onready var collision_shape_walking: CollisionShape2D = $CollisionShape2D;

@onready var floor_raycast_1: RayCast2D = $FloorRaycast1;
@onready var floor_raycast_2: RayCast2D = $FloorRaycast2;


@onready var position_label: RichTextLabel = $PositionLabel;

@export var jump_height: float = 72;
@export var jump_time_to_peak: float = 0.5;
@export var jump_time_to_fall: float = 0.5;

@onready var jump_velocity: float = - ((2 * jump_height) / jump_time_to_peak);
@onready var jump_gravity: float = - (- 2 * jump_height) / (jump_time_to_peak * jump_time_to_peak);
@onready var fall_gravity: float = - (- 2 * jump_height) / (jump_time_to_fall * jump_time_to_fall);

signal player_started_floating;
signal player_startef_walking;

func _ready() -> void:
	collision_shape_jumping.disabled = true;
	
	float_sprite.visible = false;
	is_floating = false;
	GlobalScript.player_ref = self;

	floor_constant_speed = true;
	floor_stop_on_slope = true;
	floor_max_angle = 0.0;
	#floor_block_on_wall = true;

# @BUG_A - walking in the level of the floor having the yellow blocks infront of the player
# the player collides with newly created blocks and when the user keeps pressing horizontal movement
# the character goes downwards for some reason

func _physics_process(delta: float) -> void:

	#if Input.is_action_just_pressed("move_down"):
	#	velocity.y -= 1;
	#	is_floating = false;
	#	float_sprite.visible = false;

	# Add the gravity.
	if !_is_on_floor() || velocity.y != 0:
		
		if velocity.y >= 0:
			velocity.y = 0;
			
			#collision_shape_jumping.disabled = true;
			is_floating = true;


		if !is_floating:
			velocity.y += jump_gravity * delta;
	else:
		is_floating = false;
		#velocity.y = 0;

	if (is_floating || _is_on_floor()):
		position.y = round(position.y) - 0.001;
		collision_shape_jumping.disabled = true;
		#collision_shape_walking.disabled = false;
		
	# Handle jump.
	if Input.is_action_just_pressed("move_up") && (_is_on_floor() || is_floating) && !jump_raycast_1.is_colliding() && !jump_raycast_2.is_colliding():
		velocity.y = jump_velocity;
		collision_shape_jumping.disabled = false;
		#collision_shape_walking.disabled = true;
		is_floating = false;

	float_sprite.visible = is_floating;
	
	var direction_x: float = 0;

	if Input.is_action_pressed("move_right"):
		direction_x += 1;
	if Input.is_action_pressed("move_left"):
		direction_x -= 1;

	velocity.x = direction_x * speed;

	#update_animations(direction_x);
	#print(position.y);


	if direction_x != 0:
		sprite.flip_h = (direction_x == -1);


	#move_and_collide(velocity * delta);
	move_and_slide();
	#if is_on_floor():
	#	if velocity.x != 0:
	#		var collision: KinematicCollision2D = get_last_slide_collision()
	#		if collision and (collision.get_normal() == Vector2.LEFT or collision.get_normal() == Vector2.RIGHT):
	#			velocity.y = 0;

	#if (velocity.y == 0):
	#position.y = round(position.y) - 0.001;
	#position.x = round(position.x);

	position_label.text = "vel_y" + str(velocity.y) + "\ny:" + str(position.y); 

func _is_on_floor() -> bool:
	return floor_raycast_1.is_colliding() || floor_raycast_2.is_colliding();