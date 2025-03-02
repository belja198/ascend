extends StaticBody2D
class_name YellowBlock;

@onready var active_sprite: Sprite2D = $ActiveSprite;
@onready var inactive_sprite: Sprite2D = $InactiveSprite;
var is_active: bool = false;
var is_player_present: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (GlobalScript.player_ref != null):
		is_active = !GlobalScript.player_ref.is_floating;
	else:
		is_active = true;
		
	set_collision_layer_value(1, is_active);
	set_collision_layer_value(3, is_active);
	active_sprite.visible = is_active;
	inactive_sprite.visible = !is_active;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#is_active = !GlobalScript.player_ref.is_floating;

	if (GlobalScript.player_ref != null):
		is_active = !GlobalScript.player_ref.is_floating;
	else:
		is_active = true;
		
	set_collision_layer_value(1, is_active);
	set_collision_layer_value(3, is_active);
	active_sprite.visible = is_active;
	inactive_sprite.visible = !is_active;

	#print("collision is on");

	#if is_player_present && is_active && !GlobalScript.player_ref.is_on_floor():
	#	print("collision is on and death is activated");
	#	call_deferred("kill_player");

	call_deferred("check_death");

func _on_area_2d_body_exited(body:Node2D) -> void:
	if body is Player:
		is_player_present = false;

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body is Player:
		is_player_present = true;


func check_death() -> void:
	if is_player_present && is_active && !GlobalScript.player_ref.is_on_floor():
		#print("DEATH!!!!!!!!");
		#modulate = Color(0,0,0);
		GlobalScript.restart_level();
		GlobalScript.player_ref.die();

func kill_player() -> void:
	print("DEATH!!!!!!!!");
	#GlobalScript.restart_level();
	modulate = Color(0,0,0);
