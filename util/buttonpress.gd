extends Button
# test0

export(String) var button_name = "button_name"
export(String, FILE, "*.tscn") var load_scene
export(NodePath) var signal_target = self

func _ready():
	if typeof(signal_target) == TYPE_NODE_PATH:
		signal_target = get_node(signal_target)

	self.connect("button_up", signal_target, "_on_button_activate", [ button_name ])

	if load_scene:
		self.connect("button_up", self, "_on_loadscene_request", [ load_scene ])

	print("[util->buttonpress]: Loaded")

func _on_button_activate(button):
	print("button default booped: ", button)

func _on_loadscene_request(scenepath):
	get_tree().change_scene(scenepath)
