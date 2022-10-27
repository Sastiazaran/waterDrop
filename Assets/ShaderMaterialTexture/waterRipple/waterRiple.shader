Shader "Custom/waterRiple"
{

    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Speed("Speed", Range(0,10)) = 1 //Speed of the wave
        _Amplitude("Amplitude", Range(0, 0.3)) = 0.05 //Amplitude of the wave
        _Period("Period", Range(0, 100)) = 1.0 //Period of the wave
        _CenterScaling("CenterScaling", float) = 20  //The factor of scaling of the plane
        _Activate("Activate", Range(0,1)) = 0.0 //Activation of the plane
        _DampingConstant("Damping Constant", Range(0, 0.99)) = 0.5 //Factor of diminishing
        _Center("Center", Vector) = (0,0,0,0) //Coordinates of the center were the drop of water hits
        
    }
    SubShader
    {

        /*
        
        @author: Sebastián Astiazarán
        Shader: waterRiple
        This shader is used to generate the ripple of water

        */

        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        //Variables
        fixed4 _Color, _Color2, _Center;
        float _Speed, _Amplitude, _Period, _Activate, _DampingConstant, _CenterScaling;
   
        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v)
        {
            float PI = 3.14159;
            float distance; //Distance of the center of were the drop hits
            float scalingX = _Center.x / _CenterScaling; //Scaling of the coordinates of the centerX
            float scalingZ = _Center.z / _CenterScaling; //Scaling of the coordinates of the centerZ
            
            distance = sqrt(pow((scalingX - v.vertex.x), 2) + pow((scalingZ - v.vertex.z), 2)); //formula to get the distance to the other points
            //This condition is used as a radio of the vertexes that are going to move on the shader


            if (distance < 0.4)
            {
                //Formula to generate the effect of waves with the drops of water

                /*
                
                    _Amplitude: Amplitude of the wave
                    _DampingConstant: Constant of decrease of the wave
                    This function works using a sin trigonometric function so it can generate a wave, because basically a wave is a sin function that decreases
                    the sin function multiplied by the formula of the circle (x-h)^2 + (y-k)^2 = r^2 so the wave that generates looks like a circle
                    Then it multiplies by the _Period
                    Finally it multiplies with the _Activate so if this variable is equal to 0 it doesnt generate a wave
                
                */

                v.vertex.y += _Amplitude 
                * _DampingConstant 
                * cos((_Time.y * -_Speed)
                + ((pow((scalingX - v.vertex.x), 2)) 
                + (pow((scalingZ - v.vertex.z), 2))) 
                * (_Period * 2.0 * PI)) * _Activate;
            }            
        }

        void surf (Input IN, inout SurfaceOutput o)
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
