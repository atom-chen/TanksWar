using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using System.Text;
using System.IO;
using UI;

public class ToolMenu
{
    [MenuItem("Tool/小工具/数学计算器")]
    static public void MathToolMenu()
    {
        MathToolWindow.ShowWnd();
    }

    [MenuItem("Tool/小工具/删除用户偏好数据")]
    static public void DelPlayerPrefs()
    {
        PlayerPrefs.DeleteAll();
    }

    [MenuItem("Tool/小工具/录屏")]
    static public void Capture()
    {
        if(!Application.isPlaying)
        {
            Debuger.LogError("只有游戏运行时才可以录屏");
            return;
        }

        Selection.activeGameObject = CaptureAvi.instance.gameObject;
        
    }

    [MenuItem("Assets/贴图/设置UI图片格式", false, -1)]
    static public void SetSprite2DFormatMenu()
    {
        Sprite2DFormatWindow.ShowWnd();
    }

    [MenuItem("GameObject/复制Mono属性到lua", false, -1)]
    static public void CopyMonoTableToLua()
    {
        if (Selection.objects.Length <= 0)
            return;

        GameObject go = Selection.objects[0] as GameObject;
        MonoTable monoTable = go.GetComponent<MonoTable>();
        if (monoTable == null)
            return;

        string copyStr = "";
        foreach(MonoTable.Param p in monoTable.ps)
        {
            if (p.obj == null)
            {
                Debug.LogError("属性：" + p.name + "没有对应GameObject");
                continue;
            }
            copyStr = copyStr + "self.m_comp." + p.name + " = \n";
        }
        TextEditor te = new TextEditor();
        te.text = copyStr;
        te.SelectAll();
        te.Copy();
    }

    //[MenuItem("Assets/贴图/优化空图片")]
    //static public void OptimizeEmptyImage()
    //{

    //    var s = UIResMgr.instance.GetSprite("ui_tongyong_icon_transparent");
    //    var s2 = UIResMgr.instance.GetSprite("ui_tongyong_di_09");
    //    if (s == null || s2 == null)
    //    {
    //        Debuger.LogError("找不到合适的通用透明图");
    //        return;
    //    }
    //    List<GameObject> prefabs = new List<GameObject>();
    //    EditorUtil.GetAssetAtPath("UI/Resources", ref prefabs);
    //    foreach (var uiPrefab in prefabs)
    //    {
    //        //if (uiPrefab.GetComponent<UIPanel>() == null)
    //        //    continue;


    //        Util.DoAllChild<Image>(uiPrefab.transform, (image) =>
    //        {
    //            if (image.sprite == null)
    //            {
    //                if (image.GetComponent<Mask>() != null)
    //                    image.sprite = s2;
    //                else
    //                    image.sprite = s;
    //            }

    //        });

    //        EditorUtil.SetDirty(uiPrefab);
    //    }
    //    UnityEditor.AssetDatabase.Refresh();
    //    UnityEditor.AssetDatabase.SaveAssets();

    //}
    //[MenuItem("Assets/贴图/查找图片引用")]
    //static public void FindSpreiteRef()
    //{
    //    if(Selection.activeObject == null || !(Selection.activeObject is Sprite))
    //    {
    //        Debuger.LogError("当前没有选中图片，不能查找引用");
    //        return;
    //    }

    //    List<string> paths = new List<string>();
    //    List<GameObject> prefabs = new List<GameObject>();
    //    EditorUtil.GetAssetAtPath("UI/Resources", ref prefabs);
    //    foreach (var uiPrefab in prefabs)
    //    {
    //        //if (uiPrefab.GetComponent<UIPanel>() == null)
    //        //    continue;

    //        Util.DoAllChild<Image>(uiPrefab.transform, (image) =>
    //        {
    //            if (image.sprite == Selection.activeObject)
    //                paths.Add(Util.GetGameObjectPath(image.gameObject));
    //        });
    //    }
    //    Debuger.Log(string.Format("引用数量：{0} \n{1}", paths.Count, string.Join("\n", paths.ToArray())));
    //}

    [MenuItem("Assets/贴图/贴图浏览器", false, -1)]
    static public void ShowTextreBrower()
    {
        TextureBrowser.ShowWindow();
    }

    public static bool SaveRenderTextureToPNG(Texture inputTex/*, Shader outputShader*/, string contents, string pngName)
    {
        RenderTexture temp = RenderTexture.GetTemporary(inputTex.width, inputTex.height, 0, RenderTextureFormat.ARGB32);
        //Material mat = new Material(outputShader);
        //Graphics.Blit(inputTex, temp, mat);
        Graphics.Blit(inputTex, temp);
        bool ret = SaveRenderTextureToPNG(temp, contents, pngName);
        RenderTexture.ReleaseTemporary(temp);
        return ret;

    }

    //将RenderTexture保存成一张png图片  
    public static bool SaveRenderTextureToPNG(RenderTexture rt, string contents, string pngName)
    {
        RenderTexture prev = RenderTexture.active;
        RenderTexture.active = rt;
        Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
        png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        byte[] bytes = png.EncodeToPNG();
        contents = Application.dataPath + "/" + contents;
        if (!Directory.Exists(contents))
            Directory.CreateDirectory(contents);
        FileStream file = File.Open(contents + "/" + pngName + ".png", FileMode.Create);
        BinaryWriter writer = new BinaryWriter(file);
        writer.Write(bytes);
        file.Close();
        Texture2D.DestroyImmediate(png);
        png = null;
        RenderTexture.active = prev;
        return true;

    }

    [MenuItem("GameObject/UI/ImageEx")]
    static public void AddImageEx()
    {
        GameObject go2 = new GameObject("image",typeof(ImageEx));
        if (Selection.activeGameObject!=null && Selection.activeGameObject.transform!= null)
        {
            go2.transform.SetParent(Selection.activeGameObject.transform,false);
            go2.transform.localPosition =Vector3.zero;
            go2.transform.localEulerAngles = Vector3.zero;
            go2.transform.localScale =Vector3.one;
            go2.layer = Selection.activeGameObject.layer;
        }
        go2.GetComponent<ImageEx>().raycastTarget = false;
        Selection.activeGameObject = go2;
        EditorUtility.SetDirty(go2);
    }

    [MenuItem("GameObject/UI/TextEx")]
    static public void AddTextEx()
    {
        GameObject go2 = new GameObject("txt", typeof(TextEx));
        if (Selection.activeGameObject != null && Selection.activeGameObject.transform != null)
        {
            go2.transform.SetParent( Selection.activeGameObject.transform,false);
            go2.transform.localPosition = Vector3.zero;
            go2.transform.localEulerAngles = Vector3.zero;
            go2.transform.localScale = Vector3.one;
            go2.layer = Selection.activeGameObject.layer;
        }
        AddTextEx(go2,"默认文本");
        Selection.activeGameObject = go2;
        EditorUtility.SetDirty(go2);
    }

    static TextEx AddTextEx(GameObject go2, string txt)
    {
        RectTransform rt = go2.GetComponent<RectTransform>();
        rt.sizeDelta = new Vector2(200, 24);
        TextEx t = go2.AddComponentIfNoExist<TextEx>();
        t.raycastTarget = false;
        t.font = AssetDatabase.LoadAssetAtPath<Font>("Assets/Game/UI/Fonts/hkhw5.TTF");
        t.fontSize = 22;
        t.color = Color.white;
        t.text = txt;
        
        return t;
    }
    static GameObject CreateUIObject(string name, GameObject parent)
    {
        GameObject gameObject = new GameObject(name);
        gameObject.AddComponent<RectTransform>();
        gameObject.transform.SetParent(parent.transform,false);
        return gameObject;
    }

    [MenuItem("GameObject/UI/Input FieldEx")]
    static public void AddInputFieldEx()
    {
        
        GameObject gameObject = new GameObject("input");
        RectTransform t =gameObject.AddComponent<RectTransform>();
        if (Selection.activeGameObject != null && Selection.activeGameObject.transform != null)
        {
            t.SetParent(Selection.activeGameObject.transform, false);
            t.localPosition = Vector3.zero;
            t.localEulerAngles = Vector3.zero;
            t.localScale = Vector3.one;
            gameObject.layer = Selection.activeGameObject.layer;
        }
         
        t.sizeDelta = new Vector2(160,35);
        GameObject gameObject2 = CreateUIObject("Placeholder", gameObject);
        GameObject gameObject3 = CreateUIObject("Text", gameObject);
        Image image = gameObject.AddComponent<ImageEx>();
        //image.sprite = AssetDatabase.GetBuiltinExtraResource<Sprite>("UI/Skin/InputFieldBackground.psd");
        image.sprite = AssetDatabase.LoadAssetAtPath<Sprite>("Assets/UI/Atlas/commonOld/ui_common_bk_02.png");
        image.type = Image.Type.Sliced;
        
        
        InputField inputField = gameObject.AddComponent<InputField>();
        Text text = AddTextEx(gameObject3,"");
        text.color = new Color(0.3f,0.3f,0.3f,1f);
        text.supportRichText = false;

        Text text2 = AddTextEx(gameObject2, "Enter text...");
        text2.fontStyle = FontStyle.Italic;
        Color color = text.color;
        color.a *= 0.5f;
        text2.color = color;

        RectTransform component = gameObject3.GetComponent<RectTransform>();
        component.anchorMin = Vector2.zero;
        component.anchorMax = Vector2.one;
        component.sizeDelta = Vector2.zero;
        component.offsetMin = new Vector2(10f, 6f);
        component.offsetMax = new Vector2(-10f, -7f);
        RectTransform component2 = gameObject2.GetComponent<RectTransform>();
        component2.anchorMin = Vector2.zero;
        component2.anchorMax = Vector2.one;
        component2.sizeDelta = Vector2.zero;
        component2.offsetMin = new Vector2(10f, 6f);
        component2.offsetMax = new Vector2(-10f, -7f);
        inputField.textComponent = text;
        inputField.placeholder = text2;
        Selection.activeGameObject = gameObject;
        EditorUtility.SetDirty(gameObject);
    }

    [MenuItem("Tool/Handle/SimpleHandle", true)]
    static bool IsAddSimpleHandle(MenuCommand command) { return Selection.activeGameObject != null && Selection.activeGameObject.GetComponent<SimpleHandle>() == null; }


    [MenuItem("Tool/Handle/SimpleHandle", false)]
    static void AddSimpleHandle(MenuCommand command)
    {
        SimpleHandle s =Selection.activeGameObject.AddComponent<SimpleHandle>();
        EditorUtility.SetDirty(Selection.activeGameObject);
    }

    [MenuItem("GameObject/UI/ButtonEx")]
    static public void AddButtonEx()
    {
        GameObject go2 = new GameObject("Button", typeof(ImageEx));
        if (Selection.activeGameObject != null && Selection.activeGameObject.transform != null)
        {
            go2.transform.SetParent( Selection.activeGameObject.transform,false);
            go2.transform.localPosition = Vector3.zero;
            go2.transform.localEulerAngles = Vector3.zero;
            go2.transform.localScale = Vector3.one;
            go2.layer = Selection.activeGameObject.layer;
        }

        AddStateButton(go2);

        Selection.activeGameObject = go2;
        EditorUtility.SetDirty(go2);
    }

    [MenuItem("Tool/Handle/StateHandle")]
    static void AddStateHandle(MenuCommand command)
    {
        StateHandle s = Selection.activeGameObject.AddComponent<StateHandle>();
        //s.transition = UnityEngine.UI.Selectable.Transition.None;
        //var nav = s.navigation;
        //nav.mode = UnityEngine.UI.Navigation.Mode.None;
        //s.navigation = nav;
        EditorUtility.SetDirty(Selection.activeGameObject);
    }

    [MenuItem("Tool/Handle/StateButton")]
    static void AddStateButton(MenuCommand command)
    {
        AddStateButton(Selection.activeGameObject);        
    }

    static void AddStateButton(GameObject go)
    {
        if(!go || go.GetComponent<StateHandle>())
            return;

        //CanvasGroup g = go.GetComponent<CanvasGroup>();
        //if(!g)
        //    g = go.AddComponent<CanvasGroup>();
        //g.interactable = true;
        //g.blocksRaycasts = true;
        //g.ignoreParentGroups = true;


        StateHandle s = go.AddComponent<StateHandle>();

        ////初始化Selectable不需要用的地方
        //s.transition = UnityEngine.UI.Selectable.Transition.None;
        //var nav = s.navigation;
        //nav.mode = UnityEngine.UI.Navigation.Mode.None;
        //s.navigation = nav;

        s.AddPublicHandle(Handle.Type.scale);
        //设置提起状态
        Handle h1 = s.m_states[0].publicHandles[0];
        s.m_states[0].isDuration = true;
        h1.m_vEnd = Vector3.one;
        h1.m_go = s.gameObject;

        //设置按下状态
        Handle h2 = s.m_states[1].publicHandles[0];
        s.m_states[1].isDuration = true;
        h2.m_vEnd = Vector3.one * 0.85f;
        h2.m_go = s.gameObject;

        //设置控制器类型为按钮
        s.m_ctrlType = StateHandle.CtrlType.button;

        EditorUtility.SetDirty(go);
    }
    [MenuItem("Tool/小工具/转换所有Button为StateButton")]
    static public void ChangeToStateButton()
    {
        GameObject[] gos = GameObject.FindObjectsOfType<GameObject>();//注意不能找到inactive的游戏对象
        Button btn;
        foreach (var go in gos)
        {
            btn = go.GetComponent<Button>();
            if(!btn)
                continue;

            UnityEngine.Object.DestroyImmediate(btn);
            AddStateButton(go);    
        }
    }

    [MenuItem("Tool/小工具/检查UI层")]
    static public void CheckUILayer()
    {
        DirectoryInfo dir = new DirectoryInfo(System.IO.Path.Combine(Application.dataPath, "UI/Resources"));
        var uiLayer = LayerMask.NameToLayer("UI");
        var uiHightLayer = LayerMask.NameToLayer("UIHight");
        var extension = ".prefab";
        var excluded = new HashSet<string> { "UIResMgr", "UIRoot" };
        var errStrs = new List<string>();
        foreach (var file in dir.GetFiles())
        {
            if (!file.Extension.Equals(extension, StringComparison.OrdinalIgnoreCase))
                continue;
            if (excluded.Contains(System.IO.Path.GetFileNameWithoutExtension(file.Name)))
                continue;
            GameObject panelObj = AssetDatabase.LoadAssetAtPath<GameObject>(System.IO.Path.Combine("Assets/UI/Resources", file.Name));
            var panelLayer = panelObj.layer;
            var panelLayerStr = LayerMask.LayerToName(panelLayer);
            if (panelLayer != uiLayer && panelLayer != uiHightLayer)
            {
                errStrs.Add(string.Format("发现Panel层不对，名字：{0}，层次：{1}\r\n", panelObj.name, panelLayerStr));
                continue;
            }
            var childrens = panelObj.GetComponentsInChildren<Transform>(true);
            foreach (var child in childrens)
            {
                var childLayer = child.gameObject.layer;
                var childLayerStr = LayerMask.LayerToName(childLayer);
                if (childLayer != panelLayer)
                    errStrs.Add(string.Format("发现UI子控件不跟Panel同层，Panel名字：{0}，控件路径：{1}，Panel层次：{2}，控件层次：{3}\r\n", panelObj.name, Util.GetGameObjectPath(child.gameObject), panelLayerStr, childLayerStr));
            }
        }
        if (errStrs.Count > 0)
        {
            var temp = "";
            for (var i = 0; i < errStrs.Count; ++i)
            {
                var str = errStrs[i];
                temp += str;
                if ((i + 1) % 30 == 0)
                {
                    Debuger.Log(temp);
                    temp = "";
                }                    
            }
            if (temp.Length > 0)
                Debuger.Log(temp);
        }
        else
        {
            Debuger.Log("没有检查出问题");
        }
    }

    [MenuItem("Tool/小工具/校正UI层")]
    static public void CorrectUILayer()
    {
        DirectoryInfo dir = new DirectoryInfo(System.IO.Path.Combine(Application.dataPath, "UI/Resources"));
        var uiLayer = LayerMask.NameToLayer("UI");
        var uiHightLayer = LayerMask.NameToLayer("UIHight");
        var extension = ".prefab";
        var excluded = new HashSet<string> { "UIResMgr", "UIRoot" };
        var errStrs = new List<string>();
        foreach (var file in dir.GetFiles())
        {
            if (!file.Extension.Equals(extension, StringComparison.OrdinalIgnoreCase))
                continue;
            if (excluded.Contains(System.IO.Path.GetFileNameWithoutExtension(file.Name)))
                continue;
            GameObject panelGo = AssetDatabase.LoadAssetAtPath<GameObject>(System.IO.Path.Combine("Assets/UI/Resources", file.Name));
            var panelLayer = panelGo.layer;
            var panelLayerStr = LayerMask.LayerToName(panelLayer);
            if (panelLayer != uiLayer && panelLayer != uiHightLayer)
            {
                errStrs.Add(string.Format("发现Panel层不对，名字：{0}，层次：{1}，由于是Panel，不自动校正，请手动校正后再执行本命令\r\n", panelGo.name, panelLayerStr));
                continue;
            }
            var changed = false;
            var childrens = panelGo.GetComponentsInChildren<Transform>(true);
            foreach (var child in childrens)
            {
                var childLayer = child.gameObject.layer;
                var childLayerStr = LayerMask.LayerToName(childLayer);
                if (childLayer != panelLayer)
                {
                    changed = true;
                    child.gameObject.layer = panelLayer;
                    errStrs.Add(string.Format("发现UI子控件不跟Panel同层，Panel名字：{0}，控件路径：{1}，Panel层次：{2}，控件层次：{3}，已校正\r\n", panelGo.name, Util.GetGameObjectPath(child.gameObject), panelLayerStr, childLayerStr));
                }
            }
            if (changed)
                UnityEditor.EditorUtility.SetDirty(panelGo);
        }
        
        UnityEditor.AssetDatabase.Refresh();
        UnityEditor.AssetDatabase.SaveAssets();
        if (errStrs.Count > 0)
        {
            var temp = "";
            for (var i = 0; i < errStrs.Count; ++i)
            {
                var str = errStrs[i];
                temp += str;
                if ((i + 1) % 30 == 0)
                {
                    Debuger.Log(temp);
                    temp = "";
                }
            }
            if (temp.Length > 0)
                Debuger.Log(temp);
        }
        else
        {
            Debuger.Log("没有检查出问题");
        }
    }

    [MenuItem("Tool/小工具/检查Missing MonoBehaviour")]
    static public void CheckMissingMonoBehaviour()
    {
        DirectoryInfo dir = new DirectoryInfo(System.IO.Path.Combine(Application.dataPath, "UI/Resources"));
        var extension = ".prefab";
        var excluded = new HashSet<string> { "UIResMgr", "UIRoot" };
        var errStrs = new List<string>();
        foreach (var file in dir.GetFiles())
        {
            if (!file.Extension.Equals(extension, StringComparison.OrdinalIgnoreCase))
                continue;
            if (excluded.Contains(System.IO.Path.GetFileNameWithoutExtension(file.Name)))
                continue;
            GameObject panelObj = AssetDatabase.LoadAssetAtPath<GameObject>(System.IO.Path.Combine("Assets/UI/Resources", file.Name));

            var childrens = panelObj.GetComponentsInChildren<Transform>(true);
            foreach (var child in childrens)
            {
                MonoBehaviour[] bhs2 = child.GetComponents<MonoBehaviour>();
                foreach (MonoBehaviour bh in bhs2)
                {
                    if (bh == null)
                    {
                        errStrs.Add(string.Format("Panel Child Missing MonoBehaviour，Panel名字：{0}，控件路径：{1}\r\n", panelObj.name, Util.GetGameObjectPath(child.gameObject)));
                    }
                }
            }
        }
        if (errStrs.Count > 0)
        {
            var temp = "";
            for (var i = 0; i < errStrs.Count; ++i)
            {
                var str = errStrs[i];
                temp += str;
                if ((i + 1) % 30 == 0)
                {
                    Debuger.Log(temp);
                    temp = "";
                }
            }
            if (temp.Length > 0)
                Debuger.Log(temp);
        }
        else
        {
            Debuger.Log("没有检查出问题");
        }
    }

    [MenuItem("Tool/小工具/Unpack Asset")]
    static public void UnpackAsset()
    {
        AssetBundleView wnd = ScriptableObject.CreateInstance<AssetBundleView>();
        wnd.ShowUtility();
        wnd.titleContent = new GUIContent("View asset bundle");
        wnd.position = new Rect(100, 50, Screen.width - 600, Screen.height - 200);
    }

    //    [MenuItem("Assets/贴图/图标添加到富文本插件")]
    //    static public void AddItemIconsToRichText()
    //    {
    //#if !ART_DEBUG
    //        if (ItemCfg.m_cfgs.Count <= 0)
    //            ItemCfg.Init();

    //        var quadList = new List<HyperTextStyles.Quad>();
    //        quadList.Add(new HyperTextStyles.Quad(UIResMgr.instance.GetSprite("ui_tongyong_icon_jinbi"), "gold", 1.0f, -0.1f, false, "", ""));
    //        quadList.Add(new HyperTextStyles.Quad(UIResMgr.instance.GetSprite("ui_tongyong_icon_tili"), "stamina", 1.0f, -0.1f, false, "", ""));
    //        quadList.Add(new HyperTextStyles.Quad(UIResMgr.instance.GetSprite("ui_tongyong_icon_zuanshi"), "diamond", 1.0f, -0.1f, false, "", ""));
    //        quadList.Add(new HyperTextStyles.Quad(UIResMgr.instance.GetSprite("ui_jingji_jingbi"), "arenacoin", 1.0f, -0.1f, false, "", ""));
    //        quadList.Add(new HyperTextStyles.Quad(UIResMgr.instance.GetSprite("ui_tongyong_icon_xing"), "star", 1.0f, -0.1f, false, "", ""));
    //        foreach (var v in ItemCfg.m_cfgs.Values)
    //        {
    //            var sprite = UIResMgr.instance.GetSprite(v.icon);
    //            var className = v.id.ToString();
    //            var sizeScalar = 1.0f;
    //            var verticalOffset = -0.1f;
    //            var shouldRespectColorization = false;
    //            var linkId = "";
    //            var linkClassName = "";
    //            var quad = new HyperTextStyles.Quad(sprite, className, sizeScalar, verticalOffset, shouldRespectColorization, linkId, linkClassName);
    //            quadList.Add(quad);
    //        }
    //        var resObj = AssetDatabase.LoadAssetAtPath<HyperTextStyles>("Assets/UI/Font/htstyle1.asset");
    //        resObj.SetQuadStyles(quadList);
    //        EditorUtil.SetDirty(resObj);
    //        AssetDatabase.Refresh();
    //        AssetDatabase.SaveAssets();
    //#endif
    //    }
}