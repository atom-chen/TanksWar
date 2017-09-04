using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using UnityEditor.SceneManagement;
using System.Collections.Generic;

[InitializeOnLoad]
public class HierarchyActiveEditor
{
    static GUIStyle toggleStyle;

    static HierarchyActiveEditor()
    {
        EditorApplication.hierarchyWindowItemOnGUI += HierarchyItemOnGUI;
    }

    static void HierarchyItemOnGUI(int instanceID, Rect selectionRect)
    {
        GameObject go = EditorUtility.InstanceIDToObject(instanceID) as GameObject;
        if (go != null && !go.Equals(null))
        {
            if (toggleStyle == null || toggleStyle.Equals(null) || string.IsNullOrEmpty(toggleStyle.name))
            {
                toggleStyle = null;
                GUISkin customSkin = AssetDatabase.LoadAssetAtPath("Assets/Editor/Res/custom.guiskin", typeof(GUISkin)) as GUISkin;
                if (customSkin != null)
                    toggleStyle = customSkin.GetStyle("ToggleEye");
            }

            if (go.tag == "EditorOnly")
                GUI.color = Color.red;
            else
                GUI.color = Color.white;

            bool bActive = false;
            if (toggleStyle != null && !string.IsNullOrEmpty(toggleStyle.name))
            {
                Rect rect = new Rect(selectionRect);
                rect.x += selectionRect.width;
                rect.x -= 35;
                rect.width = 30;
                bool active = GUI.Toggle(rect, go.activeSelf, "", toggleStyle);
                if (active != go.activeSelf)
                    go.SetActive(active);
                if (active)
                    bActive = true;
            }
            else
            {
                Rect rect = new Rect(selectionRect);
                rect.x += selectionRect.width;
                rect.x -= 20;
                rect.width = 15;
                bool active = GUI.Toggle(rect, go.activeSelf, "");
                if (active != go.activeSelf)
                    go.SetActive(active);
                if (active)
                    bActive = true;
            }

            Scene scene = EditorSceneManager.GetActiveScene();
            if (scene.name == "ui_editor")
            {
                if (go.transform.parent != null && go.transform.parent.name == "CanvasRoot" && bActive)
                {
                    int count = go.transform.parent.childCount;
                    for (int i =0; i < count; i++)
                    {
                        Transform tr = go.transform.parent.GetChild(i);
                        if (tr.name != go.name)
                            tr.gameObject.SetActive(false);
                    }
                }
            }

            GUI.color = Color.white;
        }
    }
}
