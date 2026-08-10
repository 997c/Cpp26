#version 450

layout(push_constant) uniform PC {
    int mode;
} pc;

layout(location = 0) in vec3 fragNormal;
layout(location = 1) in vec2 fragTexCoord;

layout(location = 0) out vec4 outColor;

void main()
{
    if (pc.mode == 0) {
        // 4-color gradient background
        vec3 topColor = mix(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), fragTexCoord.x);
        vec3 bottomColor = mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), fragTexCoord.x);
        vec3 backgroundColor = mix(topColor, bottomColor, fragTexCoord.y);

        outColor = vec4(backgroundColor, 1.0);
    } else {
        // White torus with simple directional light
        vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
        float diff = max(dot(normalize(fragNormal), lightDir), 0.3);
        outColor = vec4(vec3(diff), 1.0);
    }
}