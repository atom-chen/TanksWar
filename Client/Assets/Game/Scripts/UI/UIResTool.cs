using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIResTool {
    //保存各个游戏模块存放图片的预置体
    static Dictionary<string, UIResMgr> m_resMgrs = new Dictionary<string, UIResMgr>();
    static UIResMgr m_commonRes;

    public static UIResMgr Get(string modName)
    {
        if (!Application.isPlaying)
        {
            GameObject prefab = Resources.Load<GameObject>("Prefab/" + modName + "/UIResMgr");
            UIResMgr resMgr = prefab.GetComponent<UIResMgr>();
            return resMgr;
        }
        else
        {
            if (m_resMgrs.ContainsKey(modName))
                return m_resMgrs[modName];
            
            Debuger.LogError("未获取到 " + modName + " 模块的资源管理文件");
        }
        return null;
    }

    public static bool HasMod(string modName)
    {
        return m_resMgrs.ContainsKey(modName);
    }

    public static void Add(UIResMgr uiRes, string modName)
    {
        if (m_resMgrs.ContainsKey(modName))
        {
            Debug.Log("重复加载了UIResMgr 模块 ： " + modName);
            return;
        }

        m_resMgrs.Add(modName, uiRes);
    }

    public static Sprite GetSprite(string spriteName)
    {
        if (m_commonRes == null)
        {
            m_commonRes = Get("Common");
        }
        //现在common里取
        Sprite sprite = m_commonRes.GetSprite(spriteName);
        if (sprite == null)
        {
            //没有就在当前模块的图集里取
            UIResMgr uiRes = Get(GameManager.GetCurMod());
            sprite = uiRes.GetSprite(spriteName);
        }

        if (sprite == null)
            Debug.LogError("没有找到图片--" + spriteName);

        return sprite;
    }
    
}
