extends CanvasLayer

# Label düğümünü tutacak değişken (Adını karışmaması için değiştirdik)
@onready var sayac_label = $Sayac/Label

# Sayacı (zamanı) tutacak sayısal değişkenimiz
var kalan_sure: float = 60.0 
var oyun_bitti: bool = false # "Kaybettin" yazısının saniyede 60 kere çalışmasını engellemek için

func _ready() -> void:
	# Başlangıç metnini ayarla
	sayac_label.text = str(int(kalan_sure))

func _process(delta: float) -> void:
	# Oyun bitmediyse ve süre 0'dan büyükse süreyi azalt
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
