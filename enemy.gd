extends CharacterBody3D
var hp=60.0; var cd=1.0
func setup(col:Color):
	add_to_group("enemy")
	var m=Game.mesh_box(Vector3(0.6,1.7,0.4),col); m.position.y=0.85; add_child(m)
	var cs=CollisionShape3D.new(); var b=CapsuleShape3D.new(); b.radius=0.4; b.height=1.8
	cs.shape=b; cs.position.y=0.9; add_child(cs)
func _physics_process(dt):
	var p=get_tree().get_first_node_in_group("player")
	if p==null: return
	var to=p.global_position-global_position; to.y=0
	var d=to.length()
	velocity.y-=20*dt
	if d<50 and d>12:
		var n=to.normalized(); velocity.x=n.x*3; velocity.z=n.z*3
	else:
		velocity.x=0; velocity.z=0
	move_and_slide()
	cd-=dt
	if d<50 and cd<=0:
		cd=1.2
		if randf()<0.35: p.damage(5)
func damage(d,_p=Vector3.ZERO):
	hp-=d
	if hp<=0: Game.money+=50; queue_free()
