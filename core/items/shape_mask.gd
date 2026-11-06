class_name ShapeMask
extends RefCounted
## Builds a distribution mask by stamping shape images into an item-sized
## image, following a region preset. Only the shapes' alpha matters, so they
## can be drawn in any color on transparent.
## Severity sets how many shapes are placed and how large; the seed makes the
## layout repeatable (fixed per campaign case, random in infinite mode).

const EDGES := "edges"


static func build(shapes: Array[Texture2D], size: Vector2i, region: String, layout_seed: int, severity: float) -> ImageTexture:
	var mask := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	if severity > 0.0 and not shapes.is_empty():
		var rng := RandomNumberGenerator.new()
		rng.seed = layout_seed
		match region:
			EDGES:
				_stamp_edges(mask, shapes, rng, severity)
			_:
				push_warning("ShapeMask: unknown region preset '%s'" % region)
	return ImageTexture.create_from_image(mask)


## Shapes are drawn with their flat side along the bottom of the canvas; each
## stamp is rotated so that side lies against the edge it is placed on.
static func _stamp_edges(mask: Image, shapes: Array[Texture2D], rng: RandomNumberGenerator, severity: float) -> void:
	var width := mask.get_width()
	var height := mask.get_height()
	var short_side := mini(width, height)

	# Sides in order: bottom, left, top, right.
	for side in 4:
		var edge_length := width if side % 2 == 0 else height
		var count := roundi(severity * 3.0 * edge_length / short_side)
		for i in count:
			var stamp := _shape_image(shapes[rng.randi() % shapes.size()])
			if rng.randf() < 0.5:
				stamp.flip_x()
			var stamp_size := roundi(short_side * rng.randf_range(0.12, 0.3) * lerpf(0.6, 1.2, severity))
			stamp.resize(stamp_size, stamp_size, Image.INTERPOLATE_BILINEAR)
			var along := rng.randi_range(-stamp_size / 4, edge_length - stamp_size * 3 / 4)

			var position: Vector2i
			match side:
				0:
					position = Vector2i(along, height - stamp_size)
				1:
					stamp.rotate_90(CLOCKWISE)
					position = Vector2i(0, along)
				2:
					stamp.rotate_180()
					position = Vector2i(along, 0)
				3:
					stamp.rotate_90(COUNTERCLOCKWISE)
					position = Vector2i(width - stamp_size, along)
			mask.blend_rect(stamp, Rect2i(Vector2i.ZERO, stamp.get_size()), position)


static func _shape_image(shape: Texture2D) -> Image:
	var image := shape.get_image()
	if image.is_compressed():
		image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	return image
