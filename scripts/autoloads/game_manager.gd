extends Node

signal invasion_started(country: Country, squad: Array[AlienUnit])
signal invasion_finished(success: bool)

var current_country: Country = null
var selected_squad: Array[AlienUnit] = []
var defeated_hero: Hero = null

func start_invasion(country: Country):
	print("GameManager: starting invasion for ", country.country_name if country else "NULL")
	current_country = country
	# Por ahora, simplemente cargamos la escena de selección de escuadrón
	var err = get_tree().change_scene_to_file("res://scenes/ui/squad_selection.tscn")
	if err != OK:
		print("GameManager: Error changing to squad selection: ", err)

func confirm_squad(squad: Array[AlienUnit]):
	print("GameManager: confirming squad, size: ", squad.size())
	selected_squad = squad
	invasion_started.emit(current_country, selected_squad)
	print("GameManager: changing scene to battle_scene.tscn")
	var err = get_tree().change_scene_to_file("res://scenes/levels/battle_scene.tscn")
	if err != OK:
		print("GameManager: Error changing scene: ", err)

func finish_invasion(success: bool):
	invasion_finished.emit(success)
	
	if success:
		# Si hay éxito, vamos a la pantalla de abducción
		get_tree().change_scene_to_file("res://scenes/ui/abduction_screen.tscn")
	else:
		# Volver al mapa mundial en caso de derrota
		get_tree().change_scene_to_file("res://scenes/ui/world_map.tscn")

func back_to_map():
	get_tree().change_scene_to_file("res://scenes/ui/world_map.tscn")
