extends Node2D


@onready var camera: Camera2D = $Camera2D;
@onready var end_timer: Timer = $EndTimer;
@onready var end_pause_timer: Timer = $EndPauseTimer;
var should_darken: bool = false;
var darken_speed: float = 2.0;
var darken_degre: float = 0.0;

var should_follow_player: bool = false;
var end_game: bool = false;
var camera_speed: float = 30.0;
var lerp_speed: float = 2.0;
#{ffb25b , e9c100, 00eb69, 27adff, a6a5ff};
var colors: Array[Color] = [
	Color("ff1d30"),  # Crvena        0
	Color("ffb25b"),  # Narandzasta   1
	Color("e9c100"),   # Zuta         2
	Color("00eb69"),  # Zelena        3
	Color("27adff"),   # Plava        4
	Color("a6a5ff"),   # Ljubicasta   5
	Color("ffffff"),   # Bela         6
	Color("000000")   # Crna          7
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# 0 -32 -64 ... -265

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GlobalScript.player_ref.position.y <= 0.0):
		should_follow_player = true;
		var index: int = - int(GlobalScript.player_ref.position.y / 32.0);
		if (index >= 0 && index <= 7):
				GlobalScript.player_ref.float_sprite.modulate = colors[index];

	if (GlobalScript.player_ref.position.y <= -256.0) && !end_game:
		end_game = true;
		GlobalScript.player_ref.visible = false;
		GlobalScript.player_ref.set_physics_process(false);
		# start end pause timer
		end_pause_timer.start();
		print("first timer started")

	

	if (should_follow_player == true):
		var target_y: float = GlobalScript.player_ref.position.y
		camera.position.y = lerp(camera.position.y, target_y, lerp_speed * delta)

	if (should_darken == true):
		modulate = lerp(modulate, Color(0,0,0), lerp_speed * delta);



func _on_end_pause_timer_timeout() -> void:
	end_timer.start();
	should_darken = true;
	print("first timer ended")


func _on_end_timer_timeout() -> void:
	print("second timer ended")
	modulate = Color(0,0,0);
	get_tree().quit();
