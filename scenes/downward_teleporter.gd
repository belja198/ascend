extends Node2D

var player_reference: Player = null;
var is_player_present: bool = false;

@onready var raycast: RayCast2D = $RayCast2D;
@export var segment_size: float = 16.0;
@export var max_length: float = 14.0 * segment_size;

@onready var teleport_collision_shape: CollisionShape2D = $TeleportArea/CollisionShape2D
@onready var teleport_sprite: Sprite2D = $TeleportArea/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#resize_telport_shape_and_sprite()
	#call_deferred("resize_telport_shape_and_sprite")
	pass;


func resize_telport_shape_and_sprite() -> void:
	if not is_inside_tree():
		return;


	raycast.target_position = Vector2(0.0, 0.0);

	var curr_length: float = 0;

	while curr_length <= max_length:
		
		curr_length += segment_size;
		raycast.target_position = Vector2(0, - curr_length);
		raycast.force_raycast_update();
		if raycast.is_colliding():
			#print ("collided");
			break;
	
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(16, curr_length / 1.0);
	teleport_collision_shape.shape = rect;
	teleport_collision_shape.position = Vector2(0, -curr_length / 2.0 + segment_size / 2);

	teleport_sprite.scale = Vector2(1 * 0.25, 0.25 * curr_length / segment_size);
	teleport_sprite.position.y = - curr_length / 2 + segment_size / 2; 
	#print (0.25 * curr_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	call_deferred("resize_telport_shape_and_sprite")
		

func teleport_player(body: Node2D) -> void:
	body.position.y = position.y - 0.001;
	#body.position.x = position.x;
	
func _on_area_2d_body_entered(body:Node2D) -> void:
	call_deferred("teleport_player", body);
	is_player_present = true;
	modulate.a = 0.5;



func _on_area_2d_body_exited(body:Node2D) -> void:
	is_player_present = false;
	modulate.a = 1.0;


