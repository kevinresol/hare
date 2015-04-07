#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void)
{
    vec4 color = texture2D(uImage0, vTexCoord);
    gl_FragColor = vec4(vec3(0.3, 0.3, 0.7) * color.rgb, color.a);
}
