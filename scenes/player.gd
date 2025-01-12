extends CharacterBody2D
class_name Player

@export var speed: float = 100.0;
@export var is_ascended: bool = true;
var is_floating: bool = false;
var old_is_floating: bool = is_floating;
@onready var float_sprite: Sprite2D = $FloatSprite;
@onready var sprite: Sprite2D = $Sprite2D;

@onready var jump_raycast_1: RayCast2D = $JumpAllowRaycast1;
@onready var jump_raycast_2: RayCast2D = $JumpAllowRaycast2;
@onready var collision_shape_jumping: CollisionShape2D = $CollisionShapeJumping;
@onready var collision_shape_walking: CollisionShape2D = $CollisionShape2D;

@onready var floor_raycast_1: RayCast2D = $FloorRaycast1;
@onready var floor_raycast_2: RayCast2D = $FloorRaycast2;

@onready var left_low_ray: RayCast2D = $LeftLowRay;
@onready var left_high_ray: RayCast2D = $LeftHighRay;
@onready var right_low_ray: RayCast2D = $RightLowRay;
@onready var right_high_ray: RayCast2D = $RightHighRay;

@onready var position_label: RichTextLabel = $PositionLabel;

@export var jump_height: float = 72;
@export var jump_time_to_peak: float = 0.5;
@export var jump_time_to_fall: float = 0.5;

@onready var jump_velocity: float = - ((2 * jump_height) / jump_time_to_peak);
@onready var jump_gravity: float = - (- 2 * jump_height) / (jump_time_to_peak * jump_time_to_peak);
@onready var fall_gravity: float = - (- 2 * jump_height) / (jump_time_to_fall * jump_time_to_fall);

signal player_started_floating;
signal player_startef_walking;

func _is_touching_left_wall() -> bool:
	return left_low_ray.is_colliding() || left_high_ray.is_colliding();

func _is_touching_right_wall() -> bool:
	return right_low_ray.is_colliding() || right_high_ray.is_colliding();

func _ready() -> void:
	collision_shape_jumping.disabled = true;
	
	float_sprite.visible = false;
	is_floating = false;
	GlobalScript.player_ref = self;

	floor_constant_speed = true;
	floor_stop_on_slope = true;
	floor_max_angle = 0.0;

	
	position.y = round(position.y) - 0.001;
	collision_shape_jumping.disabled = true;

	if is_ascended:
		sprite.modulate = Color(1, 0.62, 0.549);
	#floor_block_on_wall = true;

	#Engine.time_scale = 0.1	;


# @BUG_A - walking in the level of the floor having the yellow blocks infront of the player
# the player collides with newly created blocks and when the user keeps pressing horizontal movement
# the character goes downwards for some reason

func _physics_process(delta: float) -> void:

	#if Input.is_action_just_pressed("move_down"):
	#	velocity.y -= 1;
	#	is_floating = false;
	#	float_sprite.visible = false;


	if is_ascended:
		# Add the gravity.
		if !_is_on_floor() || velocity.y != 0 :
			#|| jump_raycast_1.is_colliding() || jump_raycast_2.is_colliding()
			if velocity.y >= 0:
				velocity.y = 0;
				
				#collision_shape_jumping.disabled = true;
				is_floating = true;
			if !is_floating :
				velocity.y += jump_gravity * delta;
		else:
			is_floating = false;
			#velocity.y = 0;
	else:
		if !_is_on_floor():
			if (velocity.y <= 0):
				velocity.y += jump_gravity * delta;
			else:
				velocity.y += fall_gravity * delta;
		else:
			is_floating = false;
			#velocity.y = 0;
			
	if (is_floating || _is_on_floor()):
		position.y = round(position.y) - 0.001;
		collision_shape_jumping.disabled = true;
		#collision_shape_walking.disabled = false;


	# Handle jump.
	#&& !jump_raycast_1.is_colliding() && !jump_raycast_2.is_colliding()
	if Input.is_action_just_pressed("move_up") && (_is_on_floor() || is_floating) && !jump_raycast_1.is_colliding() && !jump_raycast_2.is_colliding():
		velocity.y = jump_velocity;
		collision_shape_jumping.disabled = false;
		#collision_shape_walking.disabled = true;
		is_floating = false;

	float_sprite.visible = is_floating;
	
	var direction_x: float = 0;

	#&& !_is_touching_right_wall()
	if Input.is_action_pressed("move_right") && !_is_touching_right_wall():
		direction_x += 1;
	#&& !_is_touching_left_wall()
	if Input.is_action_pressed("move_left") && !_is_touching_left_wall():
		direction_x -= 1;

	if Input.is_action_pressed("move_right") && Input.is_action_pressed("move_left"):
		direction_x = 0;

	velocity.x = direction_x * speed;

	#update_animations(direction_x);
	#print(position.y);


	if direction_x != 0:
		sprite.flip_h = (direction_x == -1);


	if old_is_floating != is_floating:
		#print("FLOATING STATE CHANGED")
		pass;
	old_is_floating = is_floating;

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

	position_label.text = "vel_y" + str(velocity.y) + "\ny:" + str(position.y) + "\nx:" + str(position.x); 

func _is_colliding_with_red_block(raycast: RayCast2D) -> bool:
	var collider: Object = raycast.get_collider();
	return collider != null && collider is RedBlock;

func _is_on_floor() -> bool:
	if floor_raycast_1.is_colliding() && !_is_colliding_with_red_block(floor_raycast_1):
		return true;
	if floor_raycast_2.is_colliding() && !_is_colliding_with_red_block(floor_raycast_2):
		return true;
	return false;


#func _is_on_floor() -> bool:
#	return floor_raycast_1.is_colliding() || floor_raycast_2.is_colliding();
