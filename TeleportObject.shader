Shader "Custom/TeleportObject"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        sliceCentre("sliceCentre", Vector) = (0,0,0,0)
        sliceNormal("sliceNormal", Vector) = (0,0,0,0)
        toggle("toggle", Int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BaseLight noambient noshadow

        sampler2D _MainTex;
        float3 sliceCentre;
        float3 sliceNormal;
        int toggle;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            if (toggle == 1) {
                float sliceSide = dot(sliceNormal, IN.worldPos - sliceCentre);
                clip(-sliceSide);
            }
            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            //o.Emission = c.rgb;
            //o.Alpha = c.a;
        }

        float4 LightingBaseLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
            float rim = abs(dot(s.Normal, viewDir));
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float4 ramp = tex2D(_MainTex, float2(ndotl, rim));
            ramp.a = s.Alpha;
            return ramp;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
