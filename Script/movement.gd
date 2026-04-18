extends CharacterBody2D

@onready var dummy_bass_player = $AudioStreamPlayer2D 
@onready var main_music_player = $MainMusicPlayer 
@onready var canvas_layer = $"../CanvasLayer"

var gravty = ProjectSettings.get_setting("physics/2d/default_gravity")

var bpm: float = 120.0
var seconds_per_beat: float 
var hit_tolerance: float = 0.12 
#	var combo --> art arda 5 kombo olursa eğer +1 süre eklenir 
# 1. Mesafe Artırıldı: Karakterin daha uzun ilerlemesi için değeri yükselttik (Örn: 64 yerine 128)
var move_distance: float = 128.0 

# 2. Hareket Süresi: Karakterin yeni konuma kaç saniyede kayacağını belirliyoruz
var move_duration: float = 0.3 

func _process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y = gravty * delta * 30 
		
	move_and_slide()
		
func _ready():
	seconds_per_beat = 60.0 / bpm
	dummy_bass_player.play()
	main_music_player.play()

func _input(event):
	if event.is_action_pressed("ui_right"):
		try_move(Vector2.RIGHT)
	elif event.is_action_pressed("ui_left"):
		try_move(Vector2.LEFT)
	elif event.is_action_pressed("ui_up"):
		try_move(Vector2.UP)
	elif event.is_action_pressed("ui_down"):
		try_move(Vector2.DOWN)

func try_move(direction: Vector2):
	if dummy_bass_player.playing:
		var current_time = dummy_bass_player.get_playback_position()
		var closest_beat_time = round(current_time / seconds_per_beat) * seconds_per_beat
		var time_difference = abs(current_time - closest_beat_time)
		
		if time_difference <= hit_tolerance:
			print("Ritim yakalandı! Sapma: ", time_difference)
			
			# --- YENİ HAREKET SİSTEMİ ---
			
			# Önce karakterin gideceği son noktayı (hedefi) hesaplıyoruz
			var target_position = position + (direction * move_distance)
			
			# Godot'un animasyon motoru olan Tween'i çağırıyoruz
			var tween = create_tween()
			
			# Pozisyonu 'target_position'a 'move_duration' süresinde yumuşakça çekiyoruz
			tween.tween_property(self, "position", target_position, move_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)
			canvas_layer.combo_index += 1 
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)
			
		else:
			print("Ritim kaçtı! Sapma: ", time_difference)
			print(canvas_layer.kalan_sure)
			print("Süre Azaldı... Diak et ")
			canvas_layer.kalan_sure -= 1 
			print(canvas_layer.kalan_sure)
			
			canvas_layer.combo_index = 0
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)
