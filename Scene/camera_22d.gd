extends Camera2D

# Kameranın yukarı çıkma hızı (Bunu Inspector panelinden de değiştirebilirsin)
@export var scroll_speed: float = 100.0 

func _process(delta: float) -> void:
	# DİKKAT: Godot'un 2D dünyasında Y ekseni aşağı doğru BÜYÜR, yukarı doğru KÜÇÜLÜR.
	# Bu yüzden yukarı çıkmak için pozisyondan eksi (-) çıkarıyoruz.
	position.y -= scroll_speed * delta
