
using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;


public class Sprite2DFormatWindow : EditorWindow
{
    public static void ShowWnd()
    {
        Sprite2DFormatWindow wnd = EditorWindow.GetWindow<Sprite2DFormatWindow>();
        wnd.minSize = new Vector2(300.0f, 200.0f);
        wnd.titleContent = new GUIContent("ui图片格式设置");
        wnd.autoRepaintOnSceneChange = true;

        //找到所有选中的图片
        wnd.m_texs.Clear();
        TextureImporter textureImporter;
        //foreach (UnityEngine.Object o in Selection.objects)
        //{
        //    string path =AssetDatabase.GetAssetPath(o);
        foreach (string o in Selection.assetGUIDs)
        {
            string path = AssetDatabase.GUIDToAssetPath(o);
            if (string.IsNullOrEmpty(path))
                continue;
            if (File.Exists(path))
            {
                // 是个文件
                textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                wnd.Add(textureImporter);

            }
            else
            {
                path = path.Substring(7);//把asset/去掉
                List<string> files = Util.GetAllFileList(Application.dataPath + "/" + path, "Assets/" + path + "/");
                foreach (string assetPath in files)
                {
                    textureImporter = AssetImporter.GetAtPath(assetPath) as TextureImporter;
                    wnd.Add(textureImporter);
                }

                if (string.IsNullOrEmpty(wnd.m_atlasName))
                {
                    string[] ss = path.Split('/');
                    wnd.m_atlasName = ss[ss.Length - 1];
                }
            }
        }

        ////如果是big那么不要
        //if(wnd.m_atlasName=="big")
        //    wnd.m_atlasName ="";
    }

    public List<TextureImporter> m_texs = new List<TextureImporter>();
    public string m_atlasName = "";//图集名字



    #region 各类事件监听
    public void Awake()
    {


    }

    //更新
    void Update()
    {

    }

    void OnEnable()
    {
        //Debuger.Log("当窗口enable时调用一次");
        //初始化
        //GameObject go = Selection.activeGameObject;
    }

    void OnDisable()
    {
        //Debuger.Log("当窗口disable时调用一次");
    }
    void OnFocus()
    {
        //Debuger.Log("当窗口获得焦点时调用一次");
    }

    void OnLostFocus()
    {
        //Debuger.Log("当窗口丢失焦点时调用一次");
    }

    void OnHierarchyChange()
    {
        //        Debuger.Log("当Hierarchy视图中的任何对象发生改变时调用一次");
    }

    void OnProjectChange()
    {
        //      Debuger.Log("当Project视图中的资源发生改变时调用一次");
    }

    void OnInspectorUpdate()
    {
        //Debuger.Log("窗口面板的更新");
        //这里开启窗口的重绘，不然窗口信息不会刷新
        this.Repaint();
    }

    void OnDestroy()
    {
        //Debuger.Log("当窗口关闭时调用");
    }
    #endregion

    void OnSelectionChange()
    {
        //当窗口处于开启状态，并且在Hierarchy视图中选择某游戏对象时调用
        //foreach (Transform t in Selection.transforms)
        //{
        //   //有可能是多选，这里开启一个循环打印选中游戏对象的名称
        //    Debuger.Log("OnSelectionChange" + t.name);
        //}

    }


    Vector2 selScroll = Vector2.zero;
    //绘制窗口时调用
    void OnGUI()
    {
        EditorGUIUtility.labelWidth = 80f;
        //找到所有选中的图片
        using (new AutoBeginHorizontal())
        {
            m_atlasName = EditorGUILayout.TextField("图集名", m_atlasName);
            string[] ns = UnityEditor.Sprites.Packer.atlasNames;
            if (ns.Length != 0)
            {
                int i = Array.IndexOf(ns, m_atlasName);
                i = EditorGUILayout.Popup(i, ns, GUILayout.Width(80));
                if (i != -1 && ns[i] != m_atlasName)
                {
                    m_atlasName = ns[i];
                }
            }


            if (GUILayout.Button("设置", GUILayout.Width(50)))
            {
                Set();
            }
        }

        //是否改前缀
        bool isChangePrefix = EditorPrefs.GetInt("change_atlas_prefix") == 0;
        bool after = EditorGUILayout.Toggle("重命名前缀", isChangePrefix);
        if (after != isChangePrefix)
        {
            isChangePrefix = after;
            EditorPrefs.SetInt("change_atlas_prefix", isChangePrefix ? 0 : 1);
        }

        //要设置成的图集的名字
        using (new AutoBeginHorizontal())
        {
            EditorGUILayout.PrefixLabel("选中的图片");
            using (AutoBeginScrollView a = new AutoBeginScrollView(selScroll, GUILayout.ExpandWidth(true), GUILayout.ExpandHeight(true)))
            {
                selScroll = a.Scroll;
                foreach (TextureImporter tex in m_texs)
                {
                    string path = AssetDatabase.GetAssetPath(tex);
                    if (string.IsNullOrEmpty(path))
                        continue;
                    EditorGUILayout.LabelField(path);
                }

            }
        }
    }

    public void Add(TextureImporter tex)
    {
        if (tex == null)
            return;

        if (string.IsNullOrEmpty(m_atlasName) && !string.IsNullOrEmpty(tex.spritePackingTag))
            m_atlasName = tex.spritePackingTag;

        if (m_texs.Contains(tex))
            return;
        m_texs.Add(tex);
    }

    void Set()
    {
        int i = 0;

        foreach (TextureImporter tex in m_texs)
        {
            CheckRename(tex, m_atlasName);
            //if (string.IsNullOrEmpty(m_atlasName))
            //    tex.textureType = TextureImporterType.Sprite;
            //else
            //    tex.textureType = TextureImporterType.Default;
            tex.textureType = TextureImporterType.Sprite;
            tex.npotScale = TextureImporterNPOTScale.None;
            tex.spriteImportMode = SpriteImportMode.Single;
            tex.spritePackingTag = m_atlasName;
            tex.borderMipmap = false;
            tex.sRGBTexture = true;
            tex.alphaIsTransparency = true;
            tex.isReadable = false;
            tex.mipmapEnabled = false;
            tex.wrapMode = TextureWrapMode.Clamp;
            tex.filterMode = FilterMode.Bilinear;
            tex.anisoLevel = 1;

            //if (string.IsNullOrEmpty(m_atlasName) && IsNpot(tex))
            //{//单张图而且不是2的n次方的话，自动压缩
            //    SetFormat(tex, "Standalone", TextureImporterFormat.AutomaticCompressed);
            //    SetFormat(tex, "Android", TextureImporterFormat.AutomaticCompressed);
            //    SetFormat(tex, "iPhone", TextureImporterFormat.AutomaticCompressed);
            //}
            //else
            //{
            //SetFormat(tex, "", TextureImporterFormat.ARGB32);
            //tex.textureFormat = TextureImporterFormat.ARGB32;
            //SetFormat(tex,  "Standalone", TextureImporterFormat.ARGB32);
            tex.ClearPlatformTextureSettings("Standalone");

            //SetFormat(tex, "Android", TextureImporterFormat.ETC2_RGBA8);
            //SetFormat(tex, "iPhone", TextureImporterFormat.PVRTC_RGBA4);
            EditorUtil.SetDirty(tex);
            //}
            ++i;
            EditorUtility.DisplayProgressBar("Loading", string.Format("正在修改格式和重命名，{0}/{1}", i, m_texs.Count), ((float)i / m_texs.Count) * 0.9f);
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        //检查是不是要重新打包
        EditorUtility.DisplayProgressBar("Loading", string.Format("检查打包中"), 0.9f);
        EditorUtility.ClearProgressBar();
        UnityEditor.Sprites.Packer.kDefaultPolicy = "DefaultPackerPolicy";//TightPackerPolicy DefaultPackerPolicy
#if UNITY_ANDROID
        UnityEditor.Sprites.Packer.RebuildAtlasCacheIfNeeded(BuildTarget.Android, true);
#endif

#if UNITY_IPHONE
        UnityEditor.Sprites.Packer.RebuildAtlasCacheIfNeeded(BuildTarget.iOS,true);
#endif

#if UNITY_STANDALONE_WIN
        UnityEditor.Sprites.Packer.RebuildAtlasCacheIfNeeded(BuildTarget.StandaloneWindows,true);
#endif

        //打包进UI资源管理器中
        List<string> path = new List<string>();
        foreach (TextureImporter tex in m_texs)
        {
            //Debuger.Log("资源路径"+tex.assetPath);
            path.Add(tex.assetPath);
        }

        string modName = "";

        string pathStr = path[0];
        string[] pList = pathStr.Split('/');
        for (int n = 0; n < pList.Length; n++)
        {
            if (pList[n] == "Atlas")
                modName = pList[n + 1];
        }

        UIResMgr uiRes = UIResTool.Get(modName);
        if (Application.isPlaying)
        {
            Debug.LogError("运行中不能设置图片");
            return;
        }
        uiRes.PackByPath(path);
    }



    static bool IsNpot(TextureImporter ti)
    {
        Texture2D t2d = AssetDatabase.LoadAssetAtPath(ti.assetPath, typeof(Texture2D)) as Texture2D;
        if (t2d.width != t2d.height)
            return true;

        return false;
    }

    //static bool SetFormat(TextureImporter textureImporter, string platform, TextureImporterFormat format)
    //{

    //    int maxTextureSize;
    //    TextureImporterFormat textureFormat;
    //    textureImporter.GetPlatformTextureSettings(platform, out maxTextureSize, out textureFormat);
    //    if (textureFormat != format)
    //    {
    //        textureImporter.SetPlatformTextureSettings(platform, maxTextureSize, format);
    //        return true;
    //    }

    //    return false;
    //}

    //根据图集名重命名一个图片
    static void CheckRename(TextureImporter tex, string atlasName)
    {
        bool isChangePrefix = EditorPrefs.GetInt("change_atlas_prefix") == 0;
        if (!isChangePrefix || string.IsNullOrEmpty(atlasName))
            return;

        string path = tex.assetPath;
        int begin = path.LastIndexOf("/");
        int end = path.LastIndexOf(".");
        if (begin == -1 || end == -1 || end - 1 == begin)
        {
            Debuger.LogError("重命名图集图片出错:" + path);
            return;
        }
        //Debuger.Log(path.Substring(begin + 1, end - begin-1));
        List<string> ss = new List<string>(path.Substring(begin + 1, end - begin - 1).Split('_'));

        //添加"ui_atlasName"
        if (ss.Count <= 0)
            ss.Insert(0, "ui");
        else
        {
            bool isFind = ss[0].IndexOf("ui", StringComparison.OrdinalIgnoreCase) >= 0 && ss[0].Length == 2;
            if (isFind)
                ss[0] = "ui";
            else
                ss.Insert(0, "ui");
        }

        if (ss.Count <= 1)
            ss.Insert(0, atlasName);
        else
        {
            bool isFind = ss[1].IndexOf(atlasName, StringComparison.OrdinalIgnoreCase) >= 0 && ss[1].Length == atlasName.Length;
            if (isFind)
                ss[1] = atlasName;
            else
                ss.Insert(1, atlasName);
        }


        AssetDatabase.RenameAsset(tex.assetPath, string.Join("_", ss.ToArray()));
    }


}