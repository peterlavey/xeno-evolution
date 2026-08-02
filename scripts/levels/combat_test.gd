extends Node2D

var alien_res = preload("res://scripts/resources/alien_unit.gd")
var hero_res = preload("res://scripts/resources/hero.gd")
var human_res = preload("res://scripts/resources/human_unit.gd")
var unit_scene = preload("res://scenes/characters/battle_unit.tscn")

func _ready():
	if GameManager.selected_squad.is_empty():
		setup_mock_battle()
	else:
		setup_real_battle()

func setup_real_battle():
	print("CombatTest: Setting up real battle with large armies")
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
		var outline = PackedVector2Array([
			Vector2(0, 0),
			Vector2(1152, 0),
			Vector2(1152, 648),
			Vector2(0, 648)
		])
		new_poly.add_outline(outline)
		NavigationServer2D.bake_from_source_geometry_data(new_poly, NavigationMeshSourceGeometryData2D.new())
		nav_region.navigation_polygon = new_poly
		
	# Spawning 30 Aliens (Player side)
	# Usamos las unidades del squad seleccionadas, si hay pocas, las repetimos para el test de volumen
	var squad = GameManager.selected_squad
	for i in range(30):
		var unit_data = squad[i % squad.size()]
		var unit = unit_scene.instantiate()
		unit.data = unit_data
		# Posicionamiento en cuadrícula en el lado izquierdo
		var row = i % 10
		var col = i / 10
		unit.position = Vector2(100 + col * 50, 100 + row * 50)
		unit.add_to_group("units")
		units_node.add_child(unit)
	
	# Spawning Enemies (Human Army)
	# 1 Hero + 29 Humans
	var country_name = GameManager.current_country.country_name if GameManager.current_country else "Earth"
	
	# The Hero
	var hero_data = hero_res.new()
	hero_data.hero_name = "Guardian of " + country_name
	hero_data.max_hp = 200
	hero_data.attack = 25
	hero_data.visual_scale = 0.8
	
	var hero = unit_scene.instantiate()
	hero.data = hero_data
	hero.is_hero = true
	hero.position = Vector2(1000, 324)
	hero.add_to_group("units")
	units_node.add_child(hero)
	
	# The Human Army (29 soldiers)
	for i in range(29):
		var human_data = human_res.new()
		human_data.unit_name = "Soldier " + str(i + 1)
		human_data.max_hp = 40
		human_data.attack = 5
		human_data.visual_scale = 0.5
		
		var soldier = unit_scene.instantiate()
		soldier.data = human_data
		soldier.is_hero = true # Pertenecen al bando de los humanos
		# Posicionamiento en cuadrícula en el lado derecho
		var row = i % 10
		var col = i / 10
		soldier.position = Vector2(900 - col * 50, 100 + row * 50)
		soldier.add_to_group("units")
		units_node.add_child(soldier)
	
	print("CombatTest: Spawned 30 Aliens vs 1 Hero and 29 Human Soldiers")

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
