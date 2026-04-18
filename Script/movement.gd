extends CharacterBody2D

@onready var dummy_bass_player = $AudioStreamPlayer2D 
@onready var main_music_player = $MainMusicPlayer 
@onready var canvas_layer = $"../CanvasLayer"
@onready var sprite = $AnimatedSprite2D
@onready var Asprite = $AnimationPlayer

var gravty = ProjectSettings.get_setting("physics/2d/default_gravity")

var bpm: float = 120.0
var seconds_per_beat: float 
var hit_tolerance: float = 0.17 
#	var combo --> art arda 5 kombo olursa eğer +1 süre eklenir 
# 1. Mesafe Artırıldı: Karakterin daha uzun ilerlemesi için değeri yükselttik (Örn: 64 yerine 128)
var move_distance: float = 70 

# 2. Hareket Süresi: Karakterin yeni konuma kaç saniyede kayacağını belirliyoruz
var move_duration: float = 0.4 
var last_hit_beat = -1.0

var is_moving_with_tween: bool = false

var can_jump: bool = true # Başlangıçta zıplayabiliriz

func _physics_process(delta: float) -> void:

		
	# Eğer havadaysak VE şu an ritimle (Tween ile) uçmuyorsak (Yani serbest düşüşteysek)
	if not is_on_floor() and not is_moving_with_tween:
		
		# DİKKAT: "=" yerine "+=" kullandık. Yerçekimi her saniye ivme kazandırarak artmalı!
		velocity.y += gravty * delta 
		
		# Artık velocity.y sadece serbest düşüşte > 0 olur.
		if velocity.y > 0 and sprite.animation != "dusma":
			sprite.play("dusma")
			
	# Eğer yerdeysek yerçekimini biriktirme, sıfırla
	elif is_on_floor():
		velocity.y = 0
		can_jump = true


	# Bütün bu matematiği harekete dök
	move_and_slide()

		

func _ready():
	seconds_per_beat = 60.0 / bpm
	dummy_bass_player.play()
	main_music_player.play()
	
	$AnimationPlayer.play("RESET")

func _input(event):
	if event.is_action_pressed("ui_right"):
		try_move(Vector2.RIGHT)
		
		
	elif event.is_action_pressed("ui_left"):
		try_move(Vector2.LEFT)
		
		
	elif event.is_action_pressed("ui_up"):
		try_move(Vector2.UP)
	#elif event.is_action_pressed("ui_down"):
	#	try_move(Vector2.DOWN)
	

func try_move(direction: Vector2):
	if direction == Vector2.UP and not can_jump:
		print("Zıplama hakkın yok! Önce sağa/sola git veya yere değ.")
		return # Fonksiyonu burada kes, yukarı zıplama

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
			if direction == Vector2.UP:
				can_jump = false # Zıpladık, artık hakkımız bitti
				sprite.play("ziplama")
			
			elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
				can_jump = true # Sağa veya sola başarılı gidiş hakkı geri verir
				# (Zaten sprite.play("desh") kodun aşağıda var)
			# 1. TWEEN BAŞLIYOR: Fiziksel düşüşü durdur!
			is_moving_with_tween = true 
			

			if direction == Vector2.RIGHT:
				sprite.play("desh")
				sprite.flip_h = false
			elif direction == Vector2.LEFT:
				sprite.play("desh")
				sprite.flip_h = true
			elif direction == Vector2.UP:
				can_jump = false
				sprite.play("ziplama")
			elif direction == Vector2.DOWN:
				sprite.play("dusma")
				# Zıplama animasyonu burada oynar
			print("Ritim yakalandı! Sapma: ", time_difference)
			
			last_hit_beat = closest_beat_time 
			
			var target_position = position + (direction * move_distance)
			var tween = create_tween()
			tween.tween_property(self, "position", target_position, move_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)
				
			# 2. TWEEN BİTTİ: Anahtarı geri kapat (lambda fonksiyonu ile tek satırda hallediyoruz)
			tween.finished.connect(func(): is_moving_with_tween = false)
			
			canvas_layer.combo_index += 1 
			# ... kodun geri kalanı aynı
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)
			
		else:
			print("Ritim kaçtı! Sapma: ", time_difference)
			canvas_layer.kalan_sure -= 1 
			canvas_layer.combo_index = 0
			canvas_layer.kombo_label.text = str(canvas_layer.combo_index)

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle")
	

		
