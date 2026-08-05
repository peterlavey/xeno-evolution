extends Node2D

class_name GameFeelComponent

@export_group("Squash & Stretch")
@export var enable_squash_stretch: bool = true
@export var squash_amount: float = 0.2
@export var stretch_amount: float = 0.2
@export var recovery_speed: float = 10.0

@export_group("Impact Effects")
@export var enable_white_flash: bool = true
@export var flash_duration: float = 0.1
@export var shake_intensity: float = 5.0
@export var impact_particles: PackedScene

@export_group("Ragdoll")
@export var enable_ragdoll: bool = true
@export var ragdoll_scene: PackedScene

var _target: Node2D
var _base_scale: Vector2
var _current_scale_offset: Vector2 = Vector2.ZERO
var _flash_timer: float = 0.0
var _is_flashing: bool = false
var _mesh_nodes: Array[CanvasItem] = []

func _ready():
	_target = get_parent() as Node2D
	if _target:
		_base_scale = _target.scale
		_find_mesh_nodes(_target)

func _find_mesh_nodes(node: Node):
	if node is Sprite2D or node is Polygon2D:
		_mesh_nodes.append(node)
	for child in node.get_children():
		_find_mesh_nodes(child)

func _process(delta):
	if not _target: return
	
	if enable_squash_stretch:
		_apply_squash_stretch_recovery(delta)
	
	if _is_flashing:
		_flash_timer -= delta
		if _flash_timer <= 0:
			_stop_flash()

func _apply_squash_stretch_recovery(delta):
	# Smoothly return to base scale
	_current_scale_offset = _current_scale_offset.lerp(Vector2.ZERO, recovery_speed * delta)
	_target.scale = _base_scale + _current_scale_offset

func apply_impact(force: Vector2, impact_point: Vector2 = Vector2.ZERO):
	if enable_white_flash:
		_start_flash()
	
	# Reactive Squash & Stretch
	if enable_squash_stretch:
		var impact_dir = force.normalized()
		_current_scale_offset.x = -impact_dir.x * squash_amount
		_current_scale_offset.y = impact_dir.y * stretch_amount
	
	# Spawn particles
	if impact_particles:
		var p = impact_particles.instantiate()
		get_tree().current_scene.add_child(p)
		p.global_position = impact_point if impact_point != Vector2.ZERO else _target.global_position
		if p is GPUParticles2D or p is CPUParticles2D:
			p.emitting = true

	# Apply impulse to physics if parent has it
	if _target.has_method("apply_impulse"):
		_target.apply_impulse(force)
	
	# Trigger screen shake
	if shake_intensity > 0:
		_trigger_shake()

func _start_flash():
	_is_flashing = true
	_flash_timer = flash_duration
	for mesh in _mesh_nodes:
		if mesh.material and mesh.material is ShaderMaterial:
			mesh.material.set_shader_parameter("active", true)
		else:
			# Fallback if no shader material is assigned
			mesh.modulate = Color(10, 10, 10, 1)

func _stop_flash():
	_is_flashing = false
	for mesh in _mesh_nodes:
		if mesh.material and mesh.material is ShaderMaterial:
			mesh.material.set_shader_parameter("active", false)
		else:
			mesh.modulate = Color(1, 1, 1, 1)

func trigger_ragdoll():
	if not enable_ragdoll or not ragdoll_scene: return
	
	var ragdoll = ragdoll_scene.instantiate()
	get_tree().current_scene.add_child(ragdoll)
	ragdoll.global_position = _target.global_position
	ragdoll.rotation = _target.rotation
	
	# If the ragdoll has a script to match bones, we could call it here
	if ragdoll.has_method("match_skeleton"):
		var skeleton = _target.find_child("Skeleton2D", true)
		if skeleton:
			ragdoll.match_skeleton(skeleton)
	
	_target.queue_free()

func _trigger_shake():
	if _target.has_signal("impact_occurred"):
		_target.emit_signal("impact_occurred", shake_intensity)
