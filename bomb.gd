extends RigidBody3D
var radius=8.0; var dmg=300.0; var done=false
func _ready():
	var cs=CollisionShape3D.new(); var s=SphereShape3D.new(); s.radius=0.3; cs.shape=s; add_child(cs)
	add_child(Game.mesh_box(Vector3.ONE*0.5,Color(0.1,0.1,0.1)))
	contact_monitor=true; max_contacts_reported=1
	body_entered.connect(func(_b): _boom.call_deferred())
func _boom():
	if done: return
	done=true
	for g in ["destructible","enemy"]:
		for n in get_tree().get_nodes_in_group(g):
			var rr=radius+(n.sz.x/2 if "sz" in n else 0.0)
			if n.global_position.distance_to(global_position)<rr: n.damage(dmg)
	var e=MeshInstance3D.new(); var sm=SphereMesh.new(); sm.radius=radius*0.6; sm.height=radius*1.2
	sm.material=Game.mat(Color(1,0.5,0)); e.mesh=sm
	get_parent().add_child(e); e.global_position=global_position
	get_tree().create_timer(0.25).timeout.connect(e.queue_free)
	queue_free()
