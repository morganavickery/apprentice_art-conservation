// Shared by the condition overlay shaders: the tileable condition texture,
// the grayscale distribution mask, and severity.

// Opaque white when no texture is assigned.
uniform sampler2D overlay_texture : hint_default_white, repeat_enable, filter_linear_mipmap;
// Either a generated noise stretched once across the item, or a tileable
// library map (such as a varnish application map) repeated like the overlay.
uniform sampler2D mask_texture : repeat_enable, filter_linear_mipmap;
// How many times the overlay repeats across the item. Set from the item's
// pixel size divided by the overlay's, so texture detail stays the same size
// on every item.
uniform vec2 tile_count = vec2(1.0, 1.0);
// The same for the mask. 1 for a generated noise mask.
uniform vec2 mask_tile_count = vec2(1.0, 1.0);
// Shifts a tileable mask so the same map lands differently on each item
// (derived from the seed). Unused for noise masks, which have their own seed.
uniform vec2 mask_offset = vec2(0.0, 0.0);
// Read the mask's alpha instead of its red channel, for masks built from
// shapes drawn on transparent (see ShapeMask).
uniform bool mask_from_alpha = false;
uniform float severity : hint_range(0.0, 1.0) = 0.5;

vec4 sample_overlay(vec2 uv) {
	return texture(overlay_texture, uv * tile_count);
}

float sample_mask(vec2 uv) {
	vec4 mask = texture(mask_texture, uv * mask_tile_count + mask_offset);
	return mask_from_alpha ? mask.a : mask.r;
}
