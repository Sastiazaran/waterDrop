Shader "Custom/dropWater"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Velocity ("Velocity", float) = 0 //Velocity has to be equal to 0 so it can start as a sphere
    }
    SubShader
    {

        /*
        
        @author: Sebastián Astiazarán
        Shader: dropWater
        This shader is used to handle the drop of water

        */

        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

       
        fixed4 _Color;
        float _Velocity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v)
        {    
            //Dot product to elevate de y vertex in a factor of 1 to make it look like a drop of water
            v.vertex.y += dot(v.normal, float3(0,1,0)) * _Velocity;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
              // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
