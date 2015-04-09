#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;
uniform sampler2D uImage1; // light map

void main(void)
{
    vec4 color = texture2D(uImage0, vTexCoord);
    vec4 light = texture2D(uImage1, vTexCoord);
    gl_FragColor = light * color;
}
