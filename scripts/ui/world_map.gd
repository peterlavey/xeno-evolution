extends Control

var country_scene = preload("res://scripts/resources/country.gd")

@onready var country_list = $VBoxContainer/CountryList
@onready var details_label = $VBoxContainer/DetailsLabel

var countries: Array[Country] = []

func _ready():
	setup_mock_countries()
	refresh_list()

func setup_mock_countries():
	var c1 = Country.new()
	c1.country_name = "USA"
	c1.difficulty = 3
	c1.description = "Highly defended by super-heroes."
	
	var c2 = Country.new()
	c2.country_name = "Brazil"
	c2.difficulty = 1
	c2.description = "Lush jungles, moderate resistance."
	
	countries = [c1, c2]

func refresh_list():
	for child in country_list.get_children():
		child.queue_free()
	
	for country in countries:
		var btn = Button.new()
		btn.text = country.country_name
		btn.pressed.connect(_on_country_selected.bind(country))
		country_list.add_child(btn)

func _on_country_selected(country: Country):
	details_label.text = "Country: %s\nDifficulty: %d\n%s" % [country.country_name, country.difficulty, country.description]
	print("Selected country: ", country.country_name)
	
	# Botón para iniciar la invasión
	if not has_node("VBoxContainer/InvasionButton"):
		var inv_btn = Button.new()
		inv_btn.name = "InvasionButton"
		inv_btn.text = "INVASION!"
		inv_btn.pressed.connect(func(): GameManager.start_invasion(country))
		$VBoxContainer.add_child(inv_btn)
		
	# Botón para ir a la cámara de evolución
	if not has_node("VBoxContainer/EvolveButton"):
		var ev_btn = Button.new()
		ev_btn.name = "EvolveButton"
		ev_btn.text = "EVOLUTION CHAMBER"
		ev_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/evolution_ui.tscn"))
		$VBoxContainer.add_child(ev_btn)
