extends Control

@onready var hero_name_label = $VBoxContainer/HeroName
@onready var power_list = $VBoxContainer/PowerList
@onready var result_label = $VBoxContainer/ResultLabel
@onready var continue_button = $VBoxContainer/ContinueButton

var target_hero: Hero
var extraction_done: bool = false

func _ready():
	continue_button.visible = false
	if GameManager.defeated_hero:
		target_hero = GameManager.defeated_hero
	elif not target_hero:
		# Mock para pruebas si no viene del flujo real
		setup_mock_hero()
	
	display_hero()

func setup_mock_hero():
	target_hero = Hero.new()
	target_hero.hero_name = "Super Soldier"
	
	var p1 = StolenPower.new()
	p1.power_name = "Hardened Skin"
	p1.defense_bonus = 5
	
	var p2 = StolenPower.new()
	p2.power_name = "Adrenaline Rush"
	p2.attack_bonus = 10
	
	target_hero.available_powers.append(p1)
	target_hero.available_powers.append(p2)
	target_hero.extraction_chances[p1] = 0.5
	target_hero.extraction_chances[p2] = 0.3

func display_hero():
	hero_name_label.text = "CAPTURED: " + target_hero.hero_name
	
	for power in target_hero.available_powers:
		var btn = Button.new()
		var chance = target_hero.extraction_chances.get(power, 0.5) * 100
		btn.text = "%s (Chance: %d%%)" % [power.power_name, chance]
		btn.pressed.connect(_on_extract_power.bind(power))
		power_list.add_child(btn)

func _on_extract_power(power: StolenPower):
	if extraction_done: return
	
	extraction_done = true
	# Desactivar botones
	for child in power_list.get_children():
		if child is Button:
			child.disabled = true
	
	var chance = target_hero.extraction_chances.get(power, 0.5)
	var roll = randf()
	
	if roll <= chance:
		result_label.text = "SUCCESS! Extracted: " + power.power_name
		result_label.modulate = Color.GREEN
		CollectionManager.add_stolen_power(power)
	else:
		result_label.text = "FAILURE... The subject did not survive the extraction."
		result_label.modulate = Color.RED
	
	continue_button.visible = true

func _on_continue_pressed():
	# Podríamos ir directo al mapa o a la pantalla de evolución
	GameManager.back_to_map()
