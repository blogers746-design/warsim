extends Node
var COUNTRIES = [
	{"n":"США (реальная)","c":Color(0.2,0.3,0.6)},
	{"n":"Россия (реальная)","c":Color(0.5,0.2,0.2)},
	{"n":"Аркадия (вымышленная)","c":Color(0.2,0.5,0.3)},
	{"n":"Нордрия (вымышленная)","c":Color(0.6,0.5,0.2)}]
var mine=0; var enemy=1; var quality=1; var map_id=0
var money=0; var drone_lvl=1; var districts=0
func apply(vp:Viewport, light:DirectionalLight3D):
	vp.scaling_3d_scale=[0.6,0.8,1.0][quality]
	vp.msaa_3d=Viewport.MSAA_2X if quality==2 else Viewport.MSAA_DISABLED
	light.shadow_enabled=quality>0
func mat(c:Color)->StandardMaterial3D:
	var m=StandardMaterial3D.new(); m.albedo_color=c; return m
func mesh_box(s:Vector3,c:Color)->MeshInstance3D:
	var mi=MeshInstance3D.new(); var b=BoxMesh.new(); b.size=s; b.material=mat(c); mi.mesh=b; return mi
