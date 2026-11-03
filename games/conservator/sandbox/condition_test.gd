extends Control
## Sandbox for tuning condition overlays on the Vos base image.
## Not part of the game: a test bench for ASSET_PLAN.md Steps 2 and 3.
## Every overlay under Painting gets its own severity controls, built here.

const PRESETS: Array[float] = [0.3, 0.6, 0.9]
const DEFAULT_SEED := 1894

@onready var _base: TextureRect = %Base
@onready var _layer_controls: VBoxContainer = %LayerControls
@onready var _seed_box: SpinBox = %SeedBox

var _overlays: Array[ColorRect] = []


func _ready() -> void:
	for child in %Painting.get_children():
		if child is ColorRect and child.material is ShaderMaterial:
			_overlays.append(child)
			_setup_overlay(child)

	_seed_box.value = DEFAULT_SEED
	_seed_box.value_changed.connect(_on_seed_changed)
	_on_seed_changed(DEFAULT_SEED)


func _setup_overlay(overlay: ColorRect) -> void:
	var material := overlay.material as ShaderMaterial
	var base_size := _base.texture.get_size()
	var texture := material.get_shader_parameter("overlay_texture") as Texture2D
	var tile_size := texture.get_size() if texture else base_size
	material.set_shader_parameter("tile_count", base_size / tile_size)
	material.set_shader_parameter("base_texture", _base.texture)
	if not _mask_noise(overlay):
		var mask := material.get_shader_parameter("mask_texture") as Texture2D
		material.set_shader_parameter("mask_tile_count", base_size / mask.get_size())

	var title := Label.new()
	title.text = overlay.name
	_layer_controls.add_child(title)

	var row := HBoxContainer.new()
	var slider := HSlider.new()
	slider.max_value = 1.0
	slider.step = 0.01
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var value_label := Label.new()
	value_label.custom_minimum_size.x = 48
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(slider)
	row.add_child(value_label)
	_layer_controls.add_child(row)

	var presets := HBoxContainer.new()
	for preset in PRESETS:
		var button := Button.new()
		button.text = str(preset)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(slider.set_value.bind(preset))
		presets.add_child(button)
	_layer_controls.add_child(presets)

	var show := CheckBox.new()
	show.text = "Show %s" % overlay.name.to_lower()
	show.button_pressed = overlay.visible
	show.toggled.connect(overlay.set_visible)
	_layer_controls.add_child(show)

	slider.value_changed.connect(func(value: float) -> void:
		material.set_shader_parameter("severity", value)
		value_label.text = "%.2f" % value)
	slider.value = material.get_shader_parameter("severity")
	value_label.text = "%.2f" % slider.value


## Each layer gets a different seed derived from the box, so their masks
## don't line up. Noise masks are regenerated; tileable map masks are shifted.
func _on_seed_changed(value: float) -> void:
	for i in _overlays.size():
		var layer_seed := int(value) + i * 101
		var noise := _mask_noise(_overlays[i])
		if noise:
			noise.seed = layer_seed
		else:
			var rng := RandomNumberGenerator.new()
			rng.seed = layer_seed
			var offset := Vector2(rng.randf(), rng.randf())
			(_overlays[i].material as ShaderMaterial).set_shader_parameter("mask_offset", offset)


## The overlay's generated noise, or null if its mask is a library map.
func _mask_noise(overlay: ColorRect) -> FastNoiseLite:
	var material := overlay.material as ShaderMaterial
	var mask := material.get_shader_parameter("mask_texture") as NoiseTexture2D
	return mask.noise as FastNoiseLite if mask else null
