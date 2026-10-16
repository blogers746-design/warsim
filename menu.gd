extends Control
func _opt(v,items,sel):
	var o=OptionButton.new()
	for i in items: o.add_item(i)
	o.select(sel); v.add_child(o); return o
func _lab(v,t):
	var l=Label.new(); l.text=t; v.add_child(l)
func _ready():
	theme=Theme.new(); theme.default_font_size=30
	set_anchors_preset(PRESET_FULL_RECT)
	var c=CenterContainer.new(); c.set_anchors_preset(PRESET_FULL_RECT); add_child(c)
	var v=VBoxContainer.new(); v.custom_minimum_size=Vector2(600,0); c.add_child(v)
	var names=Game.COUNTRIES.map(func(x): return x.n)
	_lab(v,"WAR SIM — прототип")
	_lab(v,"Твоя страна"); var a=_opt(v,names,0)
	_lab(v,"Противник"); var e=_opt(v,names,1)
	_lab(v,"Карта"); var m=_opt(v,["Пригород","Город","Деревня"],0)
	_lab(v,"Графика"); var q=_opt(v,["Низкая","Средняя","Высокая"],1)
	var b=Button.new(); b.text="В БОЙ"; v.add_child(b)
	b.pressed.connect(_start.bind(a,e,q,m))
func _start(a,e,q,m):
	Game.mine=a.selected; Game.enemy=e.selected
	if Game.enemy==Game.mine: Game.enemy=(Game.mine+1)%4
	Game.quality=q.selected; Game.map_id=m.selected
	Game.money=0; Game.drone_lvl=1; Game.districts=0
	get_tree().change_scene_to_file("res://main.tscn")
