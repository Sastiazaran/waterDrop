using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*

    @author: Sebastián Astiazarán
    Script: waterDrop;

    This script is used to handle the drop of water

*/

public class waterDrop : MonoBehaviour
{
    
    Rigidbody rigidBody; //RigidBody of the gameObject
    public Material material; //Shader of the drop of water
    private float gravity = 9.81f; //Constant of gravity
    public GameObject drop; //Game object

    // Start is called before the first frame update
    void Start()
    {
        rigidBody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        //Sets the Velocity of the game object so it can affect the shader
        material.SetFloat("_Velocity", -rigidBody.velocity.y / gravity);
    }

    void OnCollisionEnter(Collision col) 
    {
        //Instantiate of the new object in another part of the world set in the range so it can generate infinite drops
        Instantiate(drop, new Vector3(Random.Range(-8, 8), 100, Random.Range(-8, 8)), Quaternion.identity);
        //destruction of the drops that hit the plane
        Destroy(gameObject);
        
    }
}
