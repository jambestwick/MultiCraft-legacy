uniform highp mat4 mWorld;

varying mediump vec4 varColor;
varying mediump vec2 varTexCoord;
varying mediump vec3 eyeVec;

const float e = 2.718281828459;
const float BS = 10.0;

void main(void)
{
	varTexCoord = inTexCoord0.xy;
	gl_Position = mWorldViewProj * inVertexPosition;
	eyeVec = -(mWorldView * inVertexPosition).xyz;
#if GL_ES
	varColor = inVertexColor.bgra;
#else
	varColor = inVertexColor;
#endif
}
