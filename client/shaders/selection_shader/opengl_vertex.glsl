varying mediump vec4 varColor;
varying mediump vec2 varTexCoord;

void main(void)
{
	varTexCoord = inTexCoord0.xy;
	gl_Position = mWorldViewProj * inVertexPosition;
	varColor = inVertexColor;
}
