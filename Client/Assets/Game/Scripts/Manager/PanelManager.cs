using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

public class PanelManager : Manager
{
    Transform parent;

    RectTransform m_canvasRoot;
    Camera m_camera;
    Canvas m_canvas;
    GameObject m_topPanel;
    GameObject m_closingTopPanel; //正在关闭的顶层窗口。一个顶层窗口关闭的时候，在它下面的窗口变为顶层窗口，它变为正在关闭的顶层窗口
    Dictionary<string, GameObject> m_panels = new Dictionary<string, GameObject>();
    Dictionary<string, Sprite> m_sprites = new Dictionary<string, Sprite>();

    public RectTransform Root { get { return m_canvasRoot; } }
    public Canvas UICanvas { get { return m_canvas; } }
    public Camera UICamera { get { return m_camera; } }
    public GameObject TopPanel { get { return m_topPanel == null ? null : m_topPanel; } }

    Transform Parent
    {
        get
        {
            if (parent == null)
            {
                GameObject go = GameObject.Find("UIRoot");
                if (go != null) parent = go.transform;
            }
            return parent;
        }
    }

    void Awake()
    {
        Object.DontDestroyOnLoad(Parent.gameObject);//过场景保留
        m_topPanel = null;
        m_canvasRoot = Parent.Find("CanvasRoot") as RectTransform;
        m_canvas = m_canvasRoot.GetComponent<Canvas>();
        m_camera = Parent.Find("UICamera").GetComponent<Camera>();
    }

    /// <summary>
    /// 创建面板，请求资源管理器
    /// </summary>
    /// <param name="type"></param>
    public void CreatePanel(string modName, string panelName, LuaFunction func = null, LuaTable tab = null)
    {
        string assetName = panelName;
        string abName = modName.ToLower() + "_prefab" + AppConst.ExtName;
        if (m_panels.ContainsKey(assetName) && m_panels[assetName]) return;

#if ASYNC_MODE
        if (!AppConst.PrefabBundleMod)
        {
            StartCoroutine(LoadPrefab(modName, assetName, func, tab));
        }
        else
        {
            LoadPrefabAsync(modName, abName, assetName, func, tab);
        }
#else
            GameObject prefab = ResManager.LoadAsset<GameObject>(name, assetName);
            if (prefab == null) return;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            RectTransform rt = go.GetComponent<RectTransform>();
            rt.SetParent(m_canvasRoot, false);
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.localScale = Vector3.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.sizeDelta = Vector2.zero;
            go.AddComponent<LuaBehaviour>();

            m_panels[assetName] = go;
            if (func != null) func.Call(go);
            //Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
#endif
    }

    /// <summary>
    /// 关闭面板
    /// </summary>
    /// <param name="name"></param>
    public void ClosePanel(string name)
    {
        var panelName = name + "Panel";
        var panelObj = Parent.Find(panelName);
        if (panelObj == null) return;
        Destroy(panelObj.gameObject);
    }

    public void LoadUIPrefab(string modName)
    {
        string assetName = "UIResMgr";
        string abName = modName.ToLower() + "_prefab" + AppConst.ExtName;
        if (!AppConst.PrefabBundleMod)
        {
            StartCoroutine(LoadPrefab(modName, assetName));
        }
        else
        {
            LoadPrefabAsync(modName, abName, assetName);
        }
    }

    void LoadPrefabAsync(string modName, string abName, string assetName, LuaFunction func = null, LuaTable tab = null)
    {
        ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null) return;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            
            if (assetName == "UIResMgr")
            {
                UIResMgr uiResMgr = go.GetComponent<UIResMgr>();
                if (uiResMgr == null)
                {
                    Debug.LogError("abName : " + abName + "  assetName : " + assetName + " 没有UIResMgr脚本");
                    return;
                }

                if (modName == "Common" || modName == "Main")
                    uiResMgr.transform.SetParent(m_canvasRoot, false);

                UIResTool.Add(uiResMgr, modName);
                return;
            }

            RectTransform rt = go.GetComponent<RectTransform>();
            if (rt != null && m_canvasRoot != null)
            {
                rt.SetParent(m_canvasRoot, false);
                rt.anchorMin = Vector2.zero;
                rt.anchorMax = Vector2.one;
                rt.localScale = Vector3.one;
                rt.anchoredPosition3D = Vector3.zero;
                rt.sizeDelta = Vector2.zero;

                m_panels[assetName] = go;
                //AddSoundFX(panel);//添加UI音效
                if (func != null) func.Call(tab, go);
            }
        });
    }
        
    IEnumerator LoadPrefab(string modName, string assetName, LuaFunction func = null, LuaTable tab = null)
    {
        GameObject prefab = Resources.Load("Prefab/" + modName + "/" + assetName) as GameObject;
        while(prefab == null)
        {
            Debug.Log("加载资源-------" + assetName);
            yield return 1;
        }
        GameObject go = Instantiate(prefab) as GameObject;
        go.name = assetName;
        RectTransform rt = go.GetComponent<RectTransform>();
        if (rt != null && m_canvasRoot != null)
        {
            rt.SetParent(m_canvasRoot);
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.localScale = Vector3.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.sizeDelta = Vector2.zero;
            
            m_panels[assetName] = go;
            //AddSoundFX(panel);//添加UI音效
            if (func != null) func.Call(tab, go);
        }

        if (assetName == "UIResMgr")
        {
            UIResMgr uiResMgr = go.GetComponent<UIResMgr>();
            if (uiResMgr == null)
            {
                Debug.LogError("modName : " + modName + "  assetName : " + assetName + " 没有UIResMgr脚本");
                yield break;
            }
            if (modName == "Common" || modName == "Main")
                uiResMgr.transform.SetParent(m_canvasRoot, false);
            uiResMgr.gameObject.SetActive(false);
            UIResTool.Add(uiResMgr, modName);
        }
        yield break;
    }
}
