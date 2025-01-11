extends StaticBody2D
class_name RedBlock;

@onready var active_sprite: Sprite2D = $ActiveSprite;
@onready var inactive_sprite: Sprite2D = $InactiveSprite;
var is_active: bool = false;
var is_player_present: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (GlobalScript.player_ref != null):
		is_active = GlobalScript.player_ref.is_floating;
	else:
		is_active = false;

	set_collision_layer_value(1, is_active);
	set_collision_layer_value(3, is_active);
	active_sprite.visible = is_active;
	inactive_sprite.visible = !is_active;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if (GlobalScript.player_ref != null):
		is_active = GlobalScript.player_ref.is_floating;
	else:
		is_active = false;

	
	call_deferred("check_death");

	#if is_player_present && is_active:
		#print("DEATH!!!!!!!!");
		#modulate = Color(0,0,0);
		#GlobalScript.restart_level();

	set_collision_layer_value(1, is_active);
	set_collision_layer_value(3, is_active);
	active_sprite.visible = is_active;
	inactive_sprite.visible = !is_active;

func check_death() -> void:
	if is_player_present && is_active && !GlobalScript.player_ref.is_on_floor():
		print("DEATH!!!!!!!!");
		modulate = Color(0,0,0);
		#GlobalScript.restart_level();

func _on_area_2d_body_exited(body:Node2D) -> void:
	if body is Player:
		is_player_present = false;

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body is Player:
		is_player_present = true;
