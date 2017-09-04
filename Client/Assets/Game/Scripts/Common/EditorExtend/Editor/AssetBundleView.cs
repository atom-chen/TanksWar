using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;

// 资源包预览
class AssetBundleView : EditorWindow 
{
	Vector2 		    m_vScrollPos = Vector2.zero;

    string              m_path = "";
    AssetBundle         m_assetBundle = null;
    AssetBundle         m_encryptAssetBundle = null;

    List<System.Type>   m_listObjType = new List<System.Type>();
    List<string>        m_listObjName = new List<string>();

    string              m_curViewFileName = "";
    string              m_curViewFileContent = "";

	static void Init()
    {
        AssetBundleView wnd = ScriptableObject.CreateInstance<AssetBundleView>();
        wnd.ShowUtility();
        wnd.titleContent = new GUIContent("View asset bundle");
        wnd.position = new Rect(100, 50, Screen.currentResolution.width - 200 , Screen.currentResolution.height - 200);
    }

    void clear()
    {
        if (m_encryptAssetBundle != null)
        {
            m_encryptAssetBundle.Unload(true);
            m_encryptAssetBundle = null;
        }

        if (m_assetBundle != null)
        {
            m_assetBundle.Unload(true);
            m_assetBundle = null;
        }

        m_listObjType.Clear();
        m_listObjName.Clear();
    }

    void OnDestroy()
    {
        clear();
    }

	void OnGUI()
	{
        GUIStyle btnStyle = new GUIStyle(GUI.skin.button);
        btnStyle.alignment = TextAnchor.MiddleLeft;

        if (string.IsNullOrEmpty(m_path))
            GUILayout.Label("please drag and drop a .unity3d file to this window!");
        else
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label(m_path);
            GUI.color = Color.red;
            if (GUILayout.Button("Export..."))
            {
                string strSaveFolder = EditorUtility.SaveFolderPanel("Export all text file from .unity3d", "", "");
                if (!string.IsNullOrEmpty(strSaveFolder))
                {
                    for (int i = 0, len = m_listObjName.Count; i < len; i++)
                    {
                        System.Type objType = m_listObjType[i];
                        string objName = m_listObjName[i];
                        if (objType.Equals(typeof(TextAsset)))
                        {
                            TextAsset ta = null;
                            string fileName = null;
                            if (objName.StartsWith("en.u."))
                            {
                                fileName = objName.Substring(objName.IndexOf('.', 5) + 1);
                                ta = m_encryptAssetBundle.LoadAsset(fileName, objType) as TextAsset;
                            }
                            else
                            {
                                fileName = objName;
                                ta = m_assetBundle.LoadAsset(fileName, objType) as TextAsset;
                            }

                            if (ta == null)
                            {
                                EditorUtility.DisplayDialog("error", "AssetBundle not has .txt file: " + fileName, "ok");
                            }
                            else
                            {
                                if (ta.bytes != null && ta.bytes.Length > 0)
                                {
                                    System.IO.FileStream fs = System.IO.File.Create(strSaveFolder + "/" + fileName + ".bin");
                                    fs.Write(ta.bytes, 0, ta.bytes.Length);
                                    fs.Close();
                                }
                                else
                                {
                                    System.IO.StreamWriter sw = System.IO.File.CreateText(strSaveFolder + "/" + fileName + ".txt");
                                    sw.Write(ta.text);
                                    sw.Close();
                                }
                            }
                        }
                    }

                    EditorUtility.DisplayDialog("finish", "success done!", "ok");
                }
            }
            GUI.color = Color.white;
            GUILayout.EndHorizontal();
        }

        GUI.color = Color.white;
        m_vScrollPos = EditorGUILayout.BeginScrollView(m_vScrollPos, true, true);
        for (int i = 0, len = m_listObjName.Count; i < len; i++)
        {
            System.Type objType = m_listObjType[i];
            string objName = m_listObjName[i];

            GUILayout.BeginHorizontal();

            GUI.color = Color.white;
            GUILayout.Label(objType.ToString(), GUILayout.Width(300));

            if (objType.Equals(typeof(TextAsset)))
            {
                if (m_curViewFileName.Equals(objName))
                {
                    GUI.color = Color.yellow;
                }
                else
                {
                    GUI.color = Color.green;
                }
            }
            else
            {
                GUI.color = Color.white;
            }
            if (GUILayout.Button(objName, btnStyle))
            {
                if (objType.Equals(typeof(TextAsset)))
                {
                    if (m_curViewFileName.Equals(objName))
                    {
                        m_curViewFileName = "";
                        m_curViewFileContent = "";
                    }
                    else
                    {
                        TextAsset ta;

                        if (objName.StartsWith("en.u."))
                        {
                            string realName = objName.Substring(objName.IndexOf('.', 5) + 1);
                            ta = m_encryptAssetBundle.LoadAsset(realName, objType) as TextAsset;
                        }
                        else
                        {
                            ta = m_assetBundle.LoadAsset(objName, objType) as TextAsset;
                        }

                        if (ta == null)
                        {
                            EditorUtility.DisplayDialog("error", "AssetBundle not has .txt file: " + objName, "ok");
                        }
                        else
                        {
                            m_curViewFileName = objName;
                            m_curViewFileContent = ta.text;
                        }
                    }
                }
            }

            GUILayout.EndHorizontal();

            if (m_curViewFileName.Equals(objName))
            {
                GUI.color = Color.white;
                GUILayout.TextArea(m_curViewFileContent, GUILayout.Width(10000f));
            }
        }
        EditorGUILayout.EndScrollView();

        DragAndDrop.visualMode = DragAndDropVisualMode.Generic;
        if (Event.current.type == EventType.DragExited)
        {
            int len = DragAndDrop.paths.Length;
            if (len == 0)
            {
                EditorUtility.DisplayDialog("error", "please drag and drop a .unity3d file to this window!", "ok");
            }
            else
            {
                m_path = DragAndDrop.paths[0];

                clear();

                m_assetBundle = AssetBundle.LoadFromMemory(System.IO.File.ReadAllBytes(m_path));

                if (m_assetBundle != null)
                {
                    foreach (Object obj in m_assetBundle.LoadAllAssets())
                    {
                        if (obj.name.StartsWith("en.u.") && obj.GetType() == typeof(TextAsset))
                        {
                            TextAsset ta = obj as TextAsset;

                            //byte[] bytes = global.DecryptBytes(ta.bytes, global.EncryptAssetBundleKey);

                            m_encryptAssetBundle = AssetBundle.LoadFromMemory(ta.bytes);

                            foreach (Object obj2 in m_encryptAssetBundle.LoadAllAssets())
                            {
                                m_listObjType.Add(obj2.GetType());
                                m_listObjName.Add(obj.name + "." + obj2.name);
                            }
                        }
                        else
                        {
                            m_listObjType.Add(obj.GetType());
                            m_listObjName.Add(obj.name);
                        }
                    }
                }
            }
        }
	}
}
