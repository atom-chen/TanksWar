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
        DebugUI.instance.Init();
        AppFacade.Instance.StartUp();   //启动游戏
    }

    void OnDisable()
    {
    }

    void OnApplicationQuit()
    {
        //LogUtil.Close();
    }
}
