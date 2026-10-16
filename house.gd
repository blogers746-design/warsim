extends StaticBody3D
var hp=100.0; var sz=Vector3.ONE
func setup(s:Vector3,c:Color):
	sz=s; hp=s.y*30.0
	add_to_group("destructible")
	var m=Game.mesh_box(s,c); m.position.y=s.y/2; add_child(m)
	var cs=CollisionShape3D.new(); var b=BoxShape3D.new(); b.size=s; cs.shape=b; cs.position.y=s.y/2; add_child(cs)
func damage(d,_p=Vector3.ZERO):
	hp-=d
	if hp<=0 and is_inside_tree(): hp=1e9; _collapse.call_deferred()
func _collapse():
	Game.money+=100
	var par=get_parent()
	for i in 14:
		var r=RigidBody3D.new(); var cs=CollisionShape3D.new(); var b=BoxShape3D.new()
		b.size=Vector3.ONE*1.2; cs.shape=b; r.add_child(cs)
		r.add_child(Game.mesh_box(Vector3.ONE*1.2,Color(0.5,0.45,0.4)))
		par.add_child(r)
		r.global_position=global_position+Vector3(randf_range(-sz.x/2,sz.x/2),randf()*sz.y,randf_range(-sz.z/2,sz.z/2))
		r.apply_central_impulse(Vector3(randf_range(-3,3),randf()*4,randf_range(-3,3)))
		get_tree().create_timer(8.0).timeout.connect(r.queue_free)
	queue_free()
