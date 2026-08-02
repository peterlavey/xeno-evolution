extends Node2D

var alien_res = preload("res://scripts/resources/alien_unit.gd")
var hero_res = preload("res://scripts/resources/hero.gd")
var unit_scene = preload("res://scenes/characters/battle_unit.tscn")

func _ready():
	if GameManager.selected_squad.is_empty():
		setup_mock_battle()
	else:
		setup_real_battle()

func setup_real_battle():
	print("CombatTest: Setting up real battle")
	# Instanciar escuadrón del jugador
	var units_node = $Units
	if not units_node:
		push_error("CombatTest: No child node 'Units' found!")
		return
		
	# Asegurar que haya un NavigationPolygon si no existe
	var nav_region = $NavigationRegion2D
	if nav_region and nav_region.navigation_polygon == null:
		print("CombatTest: Creating default NavigationPolygon")
		var new_poly = NavigationPolygon.new()
		# Añadir un contorno básico (puedes ajustarlo según tu nivel)
		var outline = PackedVector2Array([
			Vector2(0, 0),
			Vector2(1152, 0),
			Vector2(1152, 648),
			Vector2(0, 648)
		])
		new_poly.add_outline(outline)
		
		# Forma moderna de generar polígonos (Godot 4.x)
		NavigationServer2D.bake_from_source_geometry_data(new_poly, NavigationMeshSourceGeometryData2D.new())
		
		nav_region.navigation_polygon = new_poly
		print("CombatTest: NavigationPolygon baked. Bounds: 1152x648")
		
	var i = 0
	for unit_data in GameManager.selected_squad:
		var unit = unit_scene.instantiate()
		unit.data = unit_data
		# Posicionamiento más centrado en la cámara
		unit.position = Vector2(250, 200 + (i * 100))
		unit.add_to_group("units")
		units_node.add_child(unit)
		print("CombatTest: Instantiated alien: ", unit_data.unit_name)
		i += 1
	
	# Instanciar enemigos basados en el país (por ahora fijos para el test)
	var hero_data = hero_res.new()
	hero_data.hero_name = "Guardian of " + (GameManager.current_country.country_name if GameManager.current_country else "Earth")
	hero_data.max_hp = 150
	hero_data.attack = 10
	
	var hero = unit_scene.instantiate()
	hero.data = hero_data
	hero.is_hero = true
	# Posición enemiga más centrada
	hero.position = Vector2(850, 324)
	hero.add_to_group("units")
	units_node.add_child(hero)
	print("CombatTest: Instantiated hero: ", hero_data.hero_name)

func _process(_delta):
	check_battle_status()

func check_battle_status():
	var units = get_tree().get_nodes_in_group("units")
	var aliens_alive = 0
	var heroes_alive = 0
	
	for u in units:
		if u is BattleUnit and u.current_state != BattleUnit.State.DEAD:
			if u.is_hero:
				heroes_alive += 1
			else:
				aliens_alive += 1
	
	if heroes_alive == 0:
		print("VICTORY!")
		set_process(false)
		await get_tree().create_timer(2.0).timeout
		GameManager.finish_invasion(true)
	elif aliens_alive == 0:
		print("DEFEAT!")
		set_process(false)
		await get_tree().create_timer(2.0).timeout
		GameManager.finish_invasion(false)

func setup_mock_battle():
	# Crear recursos de prueba
	var alien_data = alien_res.new()
	alien_data.unit_name = "Xenomorph Test"
	alien_data.max_hp = 50
	alien_data.attack = 10
	
	var hero_data = hero_res.new()
	hero_data.hero_name = "Archer Hero"
	hero_data.max_hp = 80
	hero_data.attack = 8
	
	# Instanciar unidades
	var alien = unit_scene.instantiate()
	alien.data = alien_data
	alien.is_hero = false
	alien.position = Vector2(100, 100)
	alien.add_to_group("units")
	$Units.add_child(alien)
	
	var hero = unit_scene.instantiate()
	hero.data = hero_data
	hero.is_hero = true
	hero.attack_range = 300.0 # Rango largo para probar proyectiles
	hero.position = Vector2(400, 400)
	hero.add_to_group("units")
	$Units.add_child(hero)
	
	print("Combat test initialized: Alien vs Hero")
