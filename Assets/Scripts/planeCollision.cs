using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*

    @author: Sebastián Astiazarán
    Script: planeCollision;

    This script is used to detect the collision of the drop of water with the plane
    It uses the water ripple shader to create a procedural animation that looks like a wave

*/

public class planeCollision : MonoBehaviour
{
    
    public Material shaderMaterial; //Shader
    public float damping = 0.5f; //Modifiable damping constant
    public float dampingnext = 0.5f;
    public float decreaser = 10f; //Decreasing factor
   

    // Start is called before the first frame update
    void Start()
    {
        //Starting conditions
        shaderMaterial.SetFloat("_Activate", 0);
        shaderMaterial.SetVector("_Center", new Vector3(0,0,0));
    }

    // Update is called once per frame
    void Update()
    {
        //Damping effect that decreases with time so it can generate the effect of the waves
        damping -= Time.deltaTime/decreaser;   
        shaderMaterial.SetFloat("_DampingConstant", damping);
        //This conditional is used when the damping hits 0 it resets the damping for a new drop to hit 
        if(damping <= 0.029)
        {       
            shaderMaterial.SetFloat("_Activate", 0);
            damping = dampingnext;
        }
        
    }

    private void OnCollisionEnter(Collision col)
    {
        //Activation of the effect when it collides with the plane
        shaderMaterial.SetFloat("_Activate", 1);
        //Geting the center of the vector so it can be put in every position this is sent to the waterRipple Shader
        //so it can obtain and apply the values to te equation of the ripple
        Vector3 center = new Vector3(col.transform.position.x, 0, col.transform.position.z);
        shaderMaterial.SetVector("_Center", center);
        
    } 
}
