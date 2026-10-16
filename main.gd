extends Node3D
var done=false; var spawned=0; var lbl:Label
func _ready():
	var rng=RandomNumberGenerator.new(); rng.seed=Game.map_id*77+Game.districts
	var m=Game.map_id
	var n=[6,5,4][m]; var sp=[24,17,34][m]; var ext=n*sp/2.0
	var light=DirectionalLight3D.new(); light.rotation_degrees=Vector3(-50,30,0); add_child(light)
	var env=Environment.new(); env.background_mode=Environment.BG_SKY
	env.sky=Sky.new(); env.sky.sky_material=ProceduralSkyMaterial.new()
	env.ambient_light_source=Environment.AMBIENT_SOURCE_SKY; env.fog_enabled=true; env.fog_density=0.003
	var we=WorldEnvironment.new(); we.environment=env; add_child(we)
	var g=StaticBody3D.new(); var gc=CollisionShape3D.new(); var gb=BoxShape3D.new(); gb.size=Vector3(400,1,400)
	gc.shape=gb; g.add_child(gc); var gm=Game.mesh_box(Vector3(400,1,400),Color(0.3,0.5,0.25)); g.add_child(gm)
	g.position.y=-0.5; add_child(g)
	for i in n:
		for j in n:
			if m==2 and rng.randf()<0.4: continue
			var h=preload("res://house.gd").new()
			var hh=[rng.randf_range(4,6),rng.randf_range(10,25),rng.randf_range(3,5)][m]
			h.setup(Vector3(rng.randf_range(7,11),hh,rng.randf_range(7,11)),Color.from_hsv(rng.randf(),0.15,0.8))
			add_child(h); h.position=Vector3((i-n/2.0+0.5)*sp,0,(j-n/2.0+0.5)*sp)
	for k in [8,14,8][m]:
		var en=preload("res://enemy.gd").new(); en.setup(Game.COUNTRIES[Game.enemy].c)
		add_child(en); en.position=Vector3((rng.randi_range(0,n)-n/2.0)*sp,1,rng.randf_range(-ext,ext)); spawned+=1
	var p=preload("res://player.gd").new(); add_child(p); p.position=Vector3(0,2,ext+10)
	Game.apply(get_viewport(),light)
	var cl=CanvasLayer.new(); add_child(cl)
	lbl=Label.new(); lbl.add_theme_font_size_override("font_size",40); lbl.position=Vector2(400,250); cl.add_child(lbl)
func _process(_d):
	if not done and spawned>0 and get_tree().get_nodes_in_group("enemy").size()==0:
		done=true; Game.districts+=1; Game.map_id=(Game.map_id+1)%3
		lbl.text="Район захвачен! Захвачено: %d" % Game.districts
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
