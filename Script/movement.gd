extends CharacterBody2D

@onready var dummy_bass_player = $AudioStreamPlayer2D 
@onready var main_music_player = $MainMusicPlayer 
@onready var canvas_layer = $"../CanvasLayer"
@onready var sprite = $AnimatedSprite2D

var gravty = ProjectSettings.get_setting("physics/2d/default_gravity")

var bpm: float = 120.0
var seconds_per_beat: float 
var hit_tolerance: float = 0.13 
#	var combo --> art arda 5 kombo olursa eğer +1 süre eklenir 
# 1. Mesafe Artırıldı: Karakterin daha uzun ilerlemesi için değeri yükselttik (Örn: 64 yerine 128)
var move_distance: float = 70 

# 2. Hareket Süresi: Karakterin yeni konuma kaç saniyede kayacağını belirliyoruz
var move_duration: float = 0.4 
var last_hit_beat = -1.0

func _process(delta: float) -> void:
	if velocity.y > 0:
		print("-")
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
		
		# --- 1. SPAM KONTROLÜ ---
		# Eğer hesapladığımız en yakın vuruş zamanı, zaten daha önce başarılı
		# olup içine yazdığımız vuruş zamanıyla aynıysa:
		if closest_beat_time == last_hit_beat:
			print("Bu vuruş zaten kullanıldı! Uçma engellendi.")
			return # Fonksiyonu anında burada iptal et, aşağı okumaya devam etme.
		
		var time_difference = abs(current_time - closest_beat_time)
		
	
		if time_difference <= hit_tolerance:
			if direction == Vector2.RIGHT:
				sprite.play("desh")
				sprite.flip_h = false
			elif direction == Vector2.LEFT:
				sprite.play("desh")
				sprite.flip_h = true
			elif direction == Vector2.UP:
				sprite.play("ziplama")
				sprite.flip_h = true
				sprite.animation_finished
			print("Ritim yakalandı! Sapma: ", time_difference)
			
			# --- 2. VURUŞU MÜHÜRLEME ---
			# Madem hareketi başardık, bu vuruşun zamanını kaydedelim ki 
			# bir sonraki tuş basımında yukarıdaki if bloğuna takılsın.
			last_hit_beat = closest_beat_time 
			
			# (Buradan sonrası senin eski hareket kodların, aynı kalıyor)
			
			var target_position = position + (direction * move_distance)
			var tween = create_tween()
			tween.tween_property(self, "position", target_position, move_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)
				
			canvas_layer.combo_index += 1 
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)
			
		else:
			print("Ritim kaçtı! Sapma: ", time_difference)
			canvas_layer.kalan_sure -= 1 
			canvas_layer.combo_index = 0
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle")
	

		
