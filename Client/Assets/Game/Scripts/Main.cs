using UnityEngine;
using System.Collections;

/// <summary>
/// </summary>
public class Main : MonoBehaviour
{
    public static Main instance;

    private void Awake()
    {
        instance = this;
    }
    void Start()
    {
        ////本地日志，先启动,内部会监听所有的Debug.log
        //LogUtil.Init();
        StartCoroutine(CoInit());
    }

    IEnumerator CoInit()
    {
        //获取配置
#if !UNITY_EDITOR
        WWW www = new WWW(AppConst.ConfigURL); yield return www;
        if (www.error == null)
        {
            SetCfg(www.text);
        }
        else
        {
            Debug.LogWarning("未找到配置:" + AppConst.ConfigURL);
        }
#endif

        DebugUI.instance.Init();
        AppFacade.Instance.StartUp();   //启动游戏
        yield break;
    }

    void SetCfg(string configStr)
    {
        Debug.Log("config : \n" + configStr);
        try
        {
            configStr = configStr.Replace("\n", string.Empty);
            configStr = configStr.Replace("\r", string.Empty);
            if (configStr.EndsWith(";"))
            {
                configStr = configStr.Substring(0, configStr.Length-1);
            }
            string[] cfgList = configStr.Split(';');
            foreach (var s in cfgList)
            {
                string[] param = s.Split('=');
                Debug.Log(param[0] + " = " + param[1]);

                if (param[1] == "")
                    continue;

                string k = param[0];
                switch (k)
                {
                    case "UpdateMode":
                        {
                            bool val;
                            bool.TryParse(param[1], out val);
                            AppConst.UpdateMode = val;
                        }
                        break;
                    case "GameFrameRate":
                        {
                            int val;
                            int.TryParse(param[1], out val);
                            AppConst.GameFrameRate = val;
                        }
                        break;
                    case "TimerInterval":
                        {
                            int val;
                            int.TryParse(param[1], out val);
                            AppConst.TimerInterval = val;
                        }
                        break;
                    case "DebugUI":
                        {
                            bool val;
                            bool.TryParse(param[1], out val);
                            DebugUI.instance.IsDrawDebug = val;
                        }
                        break;
#if UNITY_ANDROID
                    case "ResUrlAndroid":
                        AppConst.WebUrl = param[1];
                        break;
#elif UNITY_IOS || UNITY_IPHONE
                    case "ResUrlIOS":
                        AppConst.WebUrl = param[1];
                        break;
#endif
                    default:
                        break;
                }
            }
        }
        catch
        {
            Debug.LogError("解析配置数据出错");
        }
    }

    void OnDisable()
    {
    }

    void OnApplicationQuit()
    {
        //LogUtil.Close();
    }
}
