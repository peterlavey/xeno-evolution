extends Node2D

func match_skeleton(skeleton: Skeleton2D):
	for bone in skeleton.get_children():
		if bone is Bone2D:
			_apply_to_rigid_body(bone)

func _apply_to_rigid_body(bone: Bone2D):
	# Look for a RigidBody2D with the same name in the ragdoll
	var rb = find_child(bone.name, true)
	if rb and rb is RigidBody2D:
		rb.global_transform = bone.global_transform
		# Inherit linear velocity if possible from the character controller
		if get_parent().has_method("get_real_velocity"):
			rb.linear_velocity = get_parent().get_real_velocity()
	
	for child in bone.get_children():
		if child is Bone2D:
			_apply_to_rigid_body(child)
