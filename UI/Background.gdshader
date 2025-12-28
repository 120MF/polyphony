shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.1, 0.1, 0.2, 1.0); // 深夜蓝
uniform vec4 color_bottom : source_color = vec4(0.05, 0.05, 0.1, 1.0); //以此为基底
uniform float speed = 0.1;

void fragment() {
    // 获取 UV 坐标
    vec2 uv = UV;
    
    // 简单的正弦波扭曲，模拟流动
    float wave = sin(uv.x * 2.0 + TIME * speed) * 0.1;
    float wave2 = cos(uv.y * 3.0 + TIME * speed * 0.8) * 0.1;
    
    // 混合颜色
    // 基于 UV.y (垂直渐变) + 波浪扰动
    float mix_val = distance(uv, vec2(0.5, 0.5 + wave + wave2));
    
    // 让中间稍微亮一点，四周暗一点 (Vignette 效果)
    vec4 final_color = mix(color_top, color_bottom, mix_val * 1.5);
    
    // 增加一点点噪点防色带 (Dithering)
    float noise = fract(sin(dot(uv * TIME, vec2(12.9898, 78.233))) * 43758.5453);
    final_color.rgb += noise * 0.02;

    COLOR = final_color;
}