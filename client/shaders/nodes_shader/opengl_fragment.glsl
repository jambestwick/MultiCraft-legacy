uniform sampler2D baseTexture;
uniform sampler2D normalTexture;
uniform sampler2D textureFlags;

uniform vec4 skyBgColor;
uniform mediump float fogDistance;
uniform vec3 eyePosition;

varying mediump vec4 varColor;
varying mediump vec2 varTexCoord;
varying mediump vec3 eyeVec; // divided by fogDistance

const float e = 2.718281828459;
const float BS = 10.0;
const float fogStart = FOG_START;
const float fogShadingParameter = 1.0 / (1.0 - fogStart);

#ifdef ENABLE_TONE_MAPPING

/* Hable's UC2 Tone mapping parameters
	A = 0.22;
	B = 0.30;
	C = 0.10;
	D = 0.20;
	E = 0.01;
	F = 0.30;
	W = 11.2;
	equation used:  ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F
*/

vec3 uncharted2Tonemap(vec3 x)
{
	return ((x * (0.22 * x + 0.03) + 0.002) / (x * (0.22 * x + 0.3) + 0.06)) - 0.03333;
}

vec4 applyToneMapping(vec4 color)
{
	color = vec4(pow(color.rgb, vec3(2.2)), color.a);
	const float gamma = 1.6;
	const float exposureBias = 5.5;
	color.rgb = uncharted2Tonemap(exposureBias * color.rgb);
	// Precalculated white_scale from 
	//vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
	vec3 whiteScale = vec3(1.036015346);
	color.rgb *= whiteScale;
	return vec4(pow(color.rgb, vec3(1.0 / gamma)), color.a);
}
#endif

void main(void)
{
	vec3 color;
	vec4 bump;
	vec2 uv = varTexCoord.st;
	bool use_normalmap = false;

	vec4 base = texture2D(baseTexture, uv).rgba;
#ifdef USE_DISCARD
	if (base.a == 0.0)
		discard;
#endif
	vec4 col = vec4(base.rgb * varColor.rgb, 1.0);

#ifdef ENABLE_TONE_MAPPING
	col = applyToneMapping(col);
#endif

	// Due to a bug in some (older ?) graphics stacks (possibly in the glsl compiler ?),
	// the fog will only be rendered correctly if the last operation before the
	// clamp() is an addition. Else, the clamp() seems to be ignored.
	// E.g. the following won't work:
	//      float clarity = clamp(fogShadingParameter
	//		* (fogDistance - length(eyeVec)) / fogDistance), 0.0, 1.0);
	// As additions usually come for free following a multiplication, the new formula
	// should be more efficient as well.
	// Note: clarity = (1 - fogginess)
	if (fogDistance > 0.0) { // -1.0 means disabled
		float clarity = clamp(fogShadingParameter
			- fogShadingParameter * length(eyeVec), 0.0, 1.0);
		col = mix(skyBgColor, col, clarity);
	}
	col = vec4(col.rgb, base.a);

	gl_FragColor = col;
}
