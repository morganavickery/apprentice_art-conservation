shader_type canvas_item;
// Paints a condition texture over the item (normal alpha blending), in
// patches where the mask is above a severity-driven threshold.
// For conditions that cover the surface, such as losses or fills.
// Severity 0 shows nothing; severity 1 covers the whole mask at full opacity.

#include "res://core/items/condition_mask.gdshaderinc"

// Width of the fade at the mask's edge. 0 gives a hard edge.
uniform float mask_softness : hint_range(0.0, 0.5) = 0.15;
// How much severity also scales opacity (0 = mask extent only).
uniform float severity_opacity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 overlay = sample_overlay(UV);

	float threshold = 1.0 - severity;
	float coverage = smoothstep(threshold - mask_softness, threshold + mask_softness, sample_mask(UV));
	coverage *= step(0.001, severity);
	float opacity = mix(1.0, severity, severity_opacity);

	COLOR = vec4(overlay.rgb, overlay.a * coverage * opacity);
}
