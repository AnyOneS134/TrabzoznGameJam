extends CanvasLayer

# Label düğümünü tutacak değişken (Adını karışmaması için değiştirdik)
@onready var sayac_label = $Sayac/Label
@onready var kombo_label = $Kombo/Label
@onready var tmor_lable = $tmor/Label
var combo_index = 0
var tmor_index = 0
@export var tmor_hedef = 5
# Sayacı (zamanı) tutacak sayısal değişkenimiz
@export var kalan_sure: float = 30
var oyun_bitti: bool = false # "Kaybettin" yazısının saniyede 60 kere çalışmasını engellemek için

func _ready() -> void:
	kombo_label.text = "0"
	tmor_lable.text = "0"
	sayac_label.text = str(int(kalan_sure))

func _process(delta: float) -> void:
	
	tmor_lable.text = str(int(tmor_index))
	if tmor_index == tmor_hedef:
		get_tree().change_scene_to_file("res://Scene/son.tscn")
		

	if combo_index == 5:
				kalan_sure += 2 
				combo_index = 0
	if kalan_sure > 0:
		kalan_sure -= delta
		# Ekranda 59.8764 gibi küsuratlı sayılar görmek istemiyorsan int() ile tam sayıya çevirebilirsin
		sayac_label.text = str(int(kalan_sure)) 
	# Süre bittiğinde çalışacak kısım
	elif not oyun_bitti: 
		kalan_sure = 0
		sayac_label.text = "0"
		oyun_bitti = true
		print("Kaybettin")
		
		# Sahneyi anında baştan başlatır
		get_tree().reload_current_scene()
		
	# Süre bittiğinde çalışacak kısım
	elif not oyun_bitti: 
		kalan_sure = 0
		sayac_label.text = "0"
		oyun_bitti = true
		print("Kaybettin")
