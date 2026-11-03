shader_type canvas_item;
// A film lying on the item's surface, such as dirt or varnish: it dims and
// tints light areas (multiply) and veils dark ones toward a haze color. The
// film is everywhere, with thickness varied by the mask and by the item's
// relief, estimated from the base image.
// Reads what is already drawn underneath, so films stack on other layers.
// Without an overlay texture the film is a plain color, set by film_tint.

#include "res://core/items/condition_mask.gdshaderinc"

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
// The item's base image, used only to estimate relief.
uniform sampler2D base_texture : filter_linear;

// Film thickness at severity 1, in layers of the overlay texture. Each layer
// dims what is under it again, so 3 means the texture applied three times.
uniform float max_thickness : hint_range(1.0, 8.0) = 4.0;
// Shapes how thickness grows with severity. Higher keeps low severities
// light and saves the heavy build-up for the top of the range.
uniform float severity_curve : hint_range(1.0, 4.0) = 2.0;
// How much the mask varies the film's thickness (0 = even everywhere).
uniform float mask_variation : hint_range(0.0, 1.0) = 0.8;
// Multiplied with the overlay texture: the color one layer of film filters
// the item through.
uniform vec3 film_tint : source_color = vec3(1.0);
// How far each layer pulls toward haze_color, lifting or tinting dark areas.
uniform float haze : hint_range(0.0, 1.0) = 0.15;
uniform vec3 haze_color : source_color = vec3(0.73, 0.70, 0.65);
// How much more film collects in recesses (locally darker spots) than on
// raised highlights. 0 ignores relief.
uniform float relief_strength : hint_range(0.0, 1.0) = 0.5;
// Size of the brushwork the relief estimate looks at, in base image pixels.
uniform float relief_radius : hint_range(1.0, 32.0) = 6.0;

float luminance(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

// Positive where the base image is darker than its surroundings (recesses,
// shadows of brushwork); negative on highlights.
float recess(vec2 uv) {
	vec2 px = relief_radius / vec2(textureSize(base_texture, 0));
	float center = luminance(texture(base_texture, uv).rgb);
	float around = 0.0;
	for (int i = 0; i < 8; i++) {
		float angle = float(i) * TAU / 8.0;
		vec2 offset = vec2(cos(angle), sin(angle)) * px;
		around += luminance(texture(base_texture, uv + offset).rgb);
		around += luminance(texture(base_texture, uv + offset * 0.5).rgb);
	}
	return around / 16.0 - center;
}

void fragment() {
	vec4 film = sample_overlay(UV);

	float thickness = max_thickness * pow(severity, severity_curve);
	thickness *= mix(1.0, 2.0 * sample_mask(UV), mask_variation);
	thickness *= 1.0 + relief_strength * 4.0 * recess(UV);
	float layers = film.a * max(thickness, 0.0);

	vec3 below = texture(screen_texture, SCREEN_UV).rgb;
	vec3 dimmed = below * pow(film.rgb * film_tint, vec3(layers));
	float veil = 1.0 - pow(1.0 - haze, layers);
	COLOR = vec4(mix(dimmed, haze_color, veil), 1.0);
}
