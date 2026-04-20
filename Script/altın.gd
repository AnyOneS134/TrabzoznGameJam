extends Area2D

@onready var ses =$AudioStreamPlayer
@onready var canvas_layer = $"../CanvasLayer"
var colay = 5
var zor = 3
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# tmor (Area2D) scripti içinde
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# 1. Sayıyı artır
		canvas_layer.tmor_index += 1
		
		# 2. Ekranda görünen yazıyı güncelle (Yeni eklenen satır)
		canvas_layer.tmor_lable.text = str(canvas_layer.tmor_index)
		
		# 3. Ses çıkar
		ses.play()
		
		# 4. Ses bitene kadar bekle ve sonra objeyi sil
		await ses.finished
		queue_free()
