extends Area2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# 2. adımda bağladığın sinyal buraya geldi
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		# 1. Şarkıyı yükle (Burası zaten çalışıyor)
		var yeni_sarki = load("res://Ses/sonses/muzuk2.wav")
		
		# 2. KURŞUN GEÇİRMEZ YÖNTEM: Değen objenin (body) içindeki MainMusicPlayer'ı bul!
		var muzik_calar = body.get_node("MainMusicPlayer")
		
		# 3. Kaseti değiştir ve çal
		muzik_calar.stream = yeni_sarki
		muzik_calar.play()
		
		# 4. Alanı yok et
		queue_free()
