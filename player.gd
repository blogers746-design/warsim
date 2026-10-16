extends CharacterBody3D
var hp=100.0
var cam:Camera3D; var yaw=0.0; var pitch=0.0
var drone:Node3D; var dcam:Camera3D; var in_drone=false; var dyaw=0.0; var dpitch=0.0
var mv=Vector2.ZERO; var look_t=-1; var move_t=-1; var move_o=Vector2.ZERO
var firing=false; var cd=0.0
var hud:Label; var btns=[]
func _ready():
	add_to_group("player")
	var cs=CollisionShape3D.new(); var b=CapsuleShape3D.new(); b.radius=0.4; b.height=1.8
	cs.shape=b; cs.position.y=0.9; add_child(cs)
	cam=Camera3D.new(); cam.position.y=1.6; add_child(cam); cam.make_current()
	drone=Node3D.new(); drone.top_level=true
	drone.add_child(Game.mesh_box(Vector3(0.6,0.15,0.6),Color(0.1,0.1,0.1)))
	dcam=Camera3D.new(); drone.add_child(dcam); add_child(drone)
	var cl=CanvasLayer.new(); add_child(cl)
	hud=Label.new(); hud.position=Vector2(20,10); hud.add_theme_font_size_override("font_size",28); cl.add_child(hud)
	var sz=get_viewport().get_visible_rect().size
	var ch=ColorRect.new(); ch.size=Vector2(8,8); ch.position=sz/2-Vector2(4,4); cl.add_child(ch)
	_btn(cl,"ОГОНЬ",Vector2(-180,-200),func(): firing=true,func(): firing=false)
	_btn(cl,"ПРЫЖОК",Vector2(-180,-310),func(): if is_on_floor(): velocity.y=7.0)
	_btn(cl,"ДРОН",Vector2(-340,-200),_toggle)
	_btn(cl,"БОМБА",Vector2(-340,-310),_bomb)
	_btn(cl,"УЛУЧШИТЬ",Vector2(-340,-420),_upg)
func _btn(cl,t,off,down,up=Callable()):
	var b=Button.new(); b.text=t; b.custom_minimum_size=Vector2(150,90); b.focus_mode=Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size",24)
	b.position=get_viewport().get_visible_rect().size+off; cl.add_child(b)
	b.button_down.connect(down)
	if up.is_valid(): b.button_up.connect(up)
	btns.append(b)
func _on_btn(p):
	for b in btns:
		if b.get_global_rect().has_point(p): return true
	return false
func _input(e):
	var w=get_viewport().get_visible_rect().size.x*0.4
	if e is InputEventScreenTouch:
		if e.pressed and not _on_btn(e.position):
			if e.position.x<w and move_t<0: move_t=e.index; move_o=e.position
			elif e.position.x>=w and look_t<0: look_t=e.index
		elif not e.pressed:
			if e.index==move_t: move_t=-1; mv=Vector2.ZERO
			if e.index==look_t: look_t=-1
	elif e is InputEventScreenDrag:
		if e.index==move_t: mv=((e.position-move_o)/80.0).limit_length(1.0)
		elif e.index==look_t: _look(e.relative*0.004)
func _look(r):
	if in_drone: dyaw-=r.x; dpitch=clamp(dpitch-r.y,-1.4,1.4)
	else: yaw-=r.x; pitch=clamp(pitch-r.y,-1.4,1.4)
func _toggle():
	in_drone=not in_drone
	if in_drone:
		drone.global_position=global_position+Vector3(0,3,0); dyaw=yaw; dpitch=0.0; dcam.make_current()
	else: cam.make_current()
func _bomb():
	if not in_drone: return
	var b=preload("res://bomb.gd").new(); b.dmg=250.0+100.0*Game.drone_lvl; b.radius=6.0+2.0*Game.drone_lvl
	get_parent().add_child(b); b.global_position=drone.global_position-Vector3(0,0.5,0)
func _upg():
	var c=300*Game.drone_lvl
	if Game.money>=c: Game.money-=c; Game.drone_lvl+=1
func _shoot():
	var q=PhysicsRayQueryParameters3D.create(cam.global_position,cam.global_position-cam.global_transform.basis.z*150.0,0xFFFFFFFF,[get_rid()])
	var r=get_world_3d().direct_space_state.intersect_ray(q)
	if r and r.collider.has_method("damage"): r.collider.damage(25.0,r.position)
func _physics_process(dt):
	var v=(mv+Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_up","ui_down"))).limit_length(1.0)
	velocity.y-=20*dt
	if in_drone:
		velocity.x=0; velocity.z=0
		drone.rotation=Vector3(dpitch,dyaw,0)
		var bs=drone.global_transform.basis
		drone.global_position+=(-bs.z*-v.y+bs.x*v.x)*(12.0+4.0*Game.drone_lvl)*dt
		drone.global_position.y=max(drone.global_position.y,1.0)
	else:
		rotation.y=yaw; cam.rotation.x=pitch
		var dir=global_transform.basis*Vector3(v.x,0,v.y)*6.0
		velocity.x=dir.x; velocity.z=dir.z
	move_and_slide()
	cd-=dt
	if firing and not in_drone and cd<=0: cd=0.1; _shoot()
func _process(_d):
	hud.text="HP %d   $%d   Дрон ур.%d (улучшение $%d)   Врагов: %d" % [hp,Game.money,Game.drone_lvl,300*Game.drone_lvl,get_tree().get_nodes_in_group("enemy").size()]
func damage(d,_p=Vector3.ZERO):
	hp-=d
	if hp<=0: hp=1e9; get_tree().reload_current_scene.call_deferred()
