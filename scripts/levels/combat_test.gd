extends Node2D

var alien_res = preload("res://scripts/resources/alien_unit.gd")
var hero_res = preload("res://scripts/resources/hero.gd")
var unit_scene = preload("res://scenes/characters/battle_unit.tscn")

func _ready():
	# Crear recursos de prueba
	var alien_data = alien_res.new()
	alien_data.unit_name = "Xenomorph Test"
	alien_data.max_hp = 50
	alien_data.attack = 10
	
	var hero_data = hero_res.new()
	hero_data.hero_name = "Super Test"
	hero_data.max_hp = 100
	hero_data.attack = 5
	
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
	hero.position = Vector2(400, 400)
	hero.add_to_group("units")
	$Units.add_child(hero)
	
	print("Combat test initialized: Alien vs Hero")
