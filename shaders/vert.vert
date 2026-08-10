#version 450

layout(push_constant) uniform PC {
    int mode;
} pc;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;

layout(location = 0) out vec3 fragNormal;
layout(location = 1) out vec2 fragTexCoord;

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

void main()
{
    if (pc.mode == 0) {
        // Background full-screen triangle
        vec2 positions[3] = vec2[](
            vec2(-1.0, -1.0),
            vec2( 3.0, -1.0),
            vec2(-1.0,  3.0)
        );

        vec2 texCoords[3] = vec2[](
            vec2(0.0, 0.0),
            vec2(2.0, 0.0),
            vec2(0.0, 2.0)
        );

        gl_Position = vec4(positions[gl_VertexIndex], 0.0, 1.0);
        fragTexCoord = texCoords[gl_VertexIndex];
        fragNormal = vec3(0.0);
    } else {
        // Torus wireframe
        gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 1.0);
        fragNormal = mat3(ubo.model) * inNormal;
        fragTexCoord = vec2(0.0);
    }
}