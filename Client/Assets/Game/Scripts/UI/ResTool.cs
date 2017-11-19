using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResTool {
    //保存各个游戏模块存放图片的预置体
    static Dictionary<string, ResMgr> m_resMgrs = new Dictionary<string, ResMgr>();
    static ResMgr m_commonRes;

    public static ResMgr Get(string modName)
    {
        if (!Application.isPlaying)
        {
            GameObject prefab = Resources.Load<GameObject>("Prefab/" + modName + "/ResMgr");
            ResMgr resMgr = prefab.GetComponent<ResMgr>();
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

    public static void Add(ResMgr res, string modName)
    {
        if (m_resMgrs.ContainsKey(modName))
        {
            Debug.Log("重复加载了UIResMgr 模块 ： " + modName);
            return;
        }

        m_resMgrs.Add(modName, res);
    }

    public static Sprite GetSprite(string spriteName)
    {
        if (m_commonRes == null)
            m_commonRes = Get("Common");

        //现在common里取
        Sprite sprite = m_commonRes.GetSprite(spriteName);
        if (sprite == null)
        {
            //没有就在当前模块的图集里取
            ResMgr res = Get(GameManager.GetCurMod());
            sprite = res.GetSprite(spriteName);
        }

        if (sprite == null)
            Debug.LogError("没有找到图片--" + spriteName);

        return sprite;
    }

    public static AudioClip GetAudioClip(string audioName)
    {
        if (m_commonRes == null)
            m_commonRes = Get("Common");

        //现在common里取
        AudioClip audioClip = m_commonRes.GetAudioClip(audioName);
        if (audioClip == null)
        {
            //没有就在当前模块的资源里取
            ResMgr res = Get(GameManager.GetCurMod());
            audioClip = res.GetAudioClip(audioName);
        }

        if (audioClip == null)
            Debug.LogError("没有找到音效资源--" + audioName);

        return audioClip;
    }
    
}
