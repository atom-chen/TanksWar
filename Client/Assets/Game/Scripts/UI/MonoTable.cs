using UnityEngine;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace UI
{
    public class MonoTable: MonoBehaviour
    {
        [System.Serializable]
        public class Param
        {
            public string name; // �ű���
            public GameObject obj; 
        }

        [SerializeField]
        public Param[] ps ;

        public GameObject getv(string valueName) 
        {   
            foreach (var p in ps)
            {
                if (p.name == valueName)
                    return p.obj;
            }

            return null;
        }
    }
}