extends StaticBody2D

@onready var active_sprite: Sprite2D = $ActiveSprite;
@onready var inactive_sprite: Sprite2D = $InactiveSprite;
var is_active: bool = false;
var is_player_present: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_sprite.visible = false;
	inactive_sprite.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	is_active = GlobalScript.player_ref.is_floating;

	if is_player_present && is_active:
		print("DEATH!!!!!!!!");
		GlobalScript.restart_level();

	set_collision_layer_value(1, is_active);
	active_sprite.visible = is_active;
	inactive_sprite.visible = !is_active;


func _on_area_2d_body_exited(body:Node2D) -> void:
	if body is Player:
		is_player_present = false;

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body is Player:
		is_player_present = true;
