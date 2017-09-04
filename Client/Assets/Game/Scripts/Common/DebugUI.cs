#region Header
/**
 * 名称：调试用ui
 * 描述：
 **/
#endregion

using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System;
using System.Collections;
using System.Collections.Generic;

public class DebugUI : SingletonMonoBehaviour<DebugUI>
{
    //页信息
    class PageInfo
    {
        public delegate void DrawPage();

        public int idx;
        public string name;
        public DrawPage fun;
        public PageInfo(int idx, string name, DrawPage fun)
        {
            this.idx = idx;
            this.name = name;
            this.fun = fun;
        }

        public void Draw()
        {
            if (fun == null)
                return;
            fun();
        }
    }

    #region Fields
    static List<PageInfo> s_pages = new List<PageInfo>();
    int curPage = 0;
    bool isShow = false;

    //用于计算帧率
    int curFrameRate = 60;
    int frameCounter = 0;
    float frameTimeCounter = 0f;
    string lastLog = "";
    string errorLog = "";
    string gmCmd = "";
    string scriptName = "";
    int fontSizeTemp = 24;
    public string gmCmdResult = "";
    public bool IsDrawDebug = true;

    #endregion


    #region Properties



    #endregion

    #region Mono Frame
    void Start()
    {

    }

    void OnGUI()
    {
        if (!IsDrawDebug)
            return;

        //做下分辨率适配，以免控件在不同设备上太小
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;

        //适配字体
        using (new AutoFontSize((int)(22 * s)))
        {
            DrawAlways();
            DrawTemp();//临时测试用的东西，测试完即删
            if (GUI.Button(new Rect(50 * s, 0 * s, 90 * s, 40 * s), "TestUI"))
            {
                isShow = !isShow;
            }
            if (isShow == false)
            {
                return;
            }
            DrawGM();


            //绘制要显示的页
            string[] pageNames = new string[s_pages.Count];
            for (int i = 0; i < s_pages.Count; ++i)
            {
                pageNames[i] = s_pages[i].name;
            }
            curPage = GUI.Toolbar(new Rect((width - pageNames.Length * 120 - 100) * s, 35 * s, pageNames.Length * 120 * s, 50 * s), curPage, pageNames);
            s_pages[curPage].Draw();
        }




    }
    #endregion



    #region Private Methods

    //一直显示的东西
    void DrawAlways()
    {
        //做下分辨率适配，以免控件在不同设备上太小
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;

        //帧率相关
        if (Time.unscaledDeltaTime < 5f)
        {
            frameTimeCounter += Time.unscaledDeltaTime;
            ++frameCounter;
        }
        if (frameTimeCounter >= 1f)
        {
            curFrameRate = frameCounter - 1;
            frameCounter = 1;
            frameTimeCounter = frameTimeCounter - 1f;
        }
        GUI.Label(new Rect(150 * s, 0 * s, 300 * s, 30 * s), "帧率:" + curFrameRate);
        if (CaptureAvi.IsExist && CaptureAvi.instance.IsCapturing())
            GUI.Label(new Rect(300 * s, 0 * s, 100 * s, 30 * s), "录屏中");
        if (Time.timeScale != 1)
            GUI.Label(new Rect(150 * s, 35 * s, 300 * s, 30 * s), "时间缩放:" + Time.timeScale);



    }
    void DrawGM()
    {
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;

        //提示框，显示最后一条log
        GUI.Label(new Rect(20 * s, (height - 50) * s, (width - 20) * s, 50 * s), lastLog);

        int oldLabelFontSize = GUI.skin.label.fontSize;
        GUI.skin.textField.fontSize = fontSizeTemp;
        GUI.SetNextControlName("gmCmd");
        gmCmd = GUI.TextField(new Rect(400 * s, 0 * s, 200 * s, 30 * s), gmCmd);
        GUI.skin.label.fontSize = oldLabelFontSize;
        if (GUI.Button(new Rect(610 * s, 0 * s, 90 * s, 30 * s), "GM"))
        {
            //NetMgr.instance.GMHandler.SendProcessGMCmd(gmCmd);
        }
        if (Event.current.isKey && GUI.GetNameOfFocusedControl() == "gmCmd")
        {
            switch (Event.current.keyCode)
            {
                case KeyCode.Return:
                    //NetMgr.instance.GMHandler.SendProcessGMCmd(gmCmd);
                    break;
                case KeyCode.UpArrow:
                    //gmCmd = NetMgr.instance.GMHandler.GetCmdInHistory(true);
                    break;
                case KeyCode.DownArrow:
                    //gmCmd = NetMgr.instance.GMHandler.GetCmdInHistory(false);
                    break;
            }
        }
        if (gmCmdResult != "")
        {
            GUI.Label(new Rect(400 * s, 32 * s, 200 * s, 30 * s), gmCmdResult);
        }
        if (GUI.Button(new Rect(710 * s, 0 * s, 90 * s, 30 * s), "Help"))
        {
            errorLog += @"
增加道具:addItem itemId 数量
打开测试模式：opentestmode
充值钻石：recharge 钻石数量
";
            curPage = 0;//切换到日志那一页
        }
        if (GUI.Button(new Rect(810 * s, 0 * s, 90 * s, 30 * s), "Test"))
        {
            Util.CallMethod("util", "Test");
        }
    }


    void SystemLogCallback(string condition, string stackTrace, LogType type)
    {
        if (LogType.Log == type)
        {
            lastLog = condition;
        }
        else if (LogType.Warning == type)
        {
            //警告太多了，不提醒
        }
        else
        {
            lastLog = string.Format("Error:{1}", stackTrace, condition);
            if (errorLog.Length > 50000)
                errorLog = errorLog.Substring(errorLog.Length - 10000, 10000);
            errorLog += stackTrace + condition;
        }
    }

    Vector2 logScroll = Vector2.zero;
    void DrawLog()
    {
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;


        GUILayout.BeginArea(new Rect(20 * s, 100 * s, (width - 40) * s, (height - 200) * s));
        logScroll = GUILayout.BeginScrollView(logScroll);
        int oldLabelFontSize = GUI.skin.label.fontSize;
        GUI.skin.label.fontSize = (int)(14 * s);
        //Color PreviousColor = GUI.backgroundColor;
        //GUI.backgroundColor = Color.red * 0.1f;
        GUILayout.TextField(errorLog);
        //GUI.backgroundColor = PreviousColor;
        GUI.skin.label.fontSize = oldLabelFontSize;
        GUILayout.EndScrollView();
        GUILayout.EndArea();
        if (GUI.Button(new Rect(500 * s, 550 * s, 90 * s, 30 * s), "清理"))
        {
            errorLog = "";
        }
    }

    //刷脚本
    bool isBtnDown = false;
    void DrawDebug()
    {
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;

        GUI.Label(new Rect((width - 380) * s, 140 * s, 100 * s, 30 * s), "脚本名:");

        int oldLabelFontSize = GUI.skin.label.fontSize;
        GUI.skin.textField.fontSize = fontSizeTemp;
        scriptName = GUI.TextField(new Rect((width - 300) * s, 140 * s, 170 * s, 30 * s), scriptName);
        GUI.skin.label.fontSize = oldLabelFontSize;
        //Unity Bug 在OnGUI里 Input获取键盘输入每帧会触发两次 这里做下判断
        if (GUI.Button(new Rect((width - 100) * s, 140 * s, 60 * s, 30 * s), "刷新") || (!isBtnDown && Input.GetKeyDown(KeyCode.F5)))
        {
            if (string.IsNullOrEmpty(scriptName))
                return;
            Util.CallMethod("util", "OnRefresh", scriptName);
            isBtnDown = true;
        }
        else if (isBtnDown && Input.GetKeyDown(KeyCode.F5))
        {
            isBtnDown = false;
        }
    }

    bool hideScene = false;
    bool hideUI = false;
    string[] antiStr = new string[] { "无", "2倍", "4倍", "8倍" };
    string[] frameRateStr = new string[] { "不限帧", "30帧", "60帧" };
    string[] resolutionStr = new string[] { "原始值", "640", "320" };
    int AntiToInt(int anti)
    {
        switch (anti)
        {
            case 0: return 0;
            case 2: return 1;
            case 4: return 2;
            case 8: return 3;
            default: Debuger.LogError("未知的抗锯齿类型:{0}", anti); return 0;
        }
    }

    int IntToAnti(int i)
    {
        switch (i)
        {
            case 0: return 0;
            case 1: return 2;
            case 2: return 4;
            case 3: return 8;
            default: Debuger.LogError("未知的抗锯齿索引:{0}", i); return 0;
        }
    }

    int FrameRateToInt(int rate)
    {
        switch (rate)
        {
            case -1: return 0;//不限制帧率
            case 30: return 1;
            case 60: return 2;
            default: return 0;
        }
    }

    int IntToFrameRate(int i)
    {
        switch (i)
        {
            case 0: return -1;
            case 1: return 30;
            case 2: return 60;
            default: return 60;
        }
    }


    void DrawPerformance()
    {
        float height = 640f;
        float width = Screen.width * height / Screen.height;
        float s = Screen.height / height;
        bool b;

        //全局雾
        //b = GUI.Toggle(new Rect((width - 500) * s, 140 * s, 100 * s, 30 * s), RenderSettings.fog, "全局雾");
        //if (RenderSettings.fog != b)
        //{
        //    RenderSettings.fog = b;
        //}

        //内存相关
#if ENABLE_PROFILER
        GUI.Label(new Rect((50) * s, 80 * s, 300 * s, 30 * s), string.Format("mono 堆大小:{0:f0}", (UnityEngine.Profiling.Profiler.GetMonoHeapSizeLong() / 1024f) / 1024f));
        GUI.Label(new Rect((50) * s, 120 * s, 300 * s, 30 * s), string.Format("mono 使用到的大小:{0:f0}", (UnityEngine.Profiling.Profiler.GetMonoUsedSizeLong() / 1024f) / 1024f));
        GUI.Label(new Rect((50) * s, 160 * s, 300 * s, 30 * s), string.Format("总内存大小:{0:f}", (UnityEngine.Profiling.Profiler.GetTotalReservedMemoryLong() / 1024f) / 1024f));
        GUI.Label(new Rect((50) * s, 200 * s, 300 * s, 30 * s), string.Format("预留中的:{0:f0}", (UnityEngine.Profiling.Profiler.GetTotalUnusedReservedMemoryLong() / 1024f) / 1024f));



#endif
        //抗锯齿
        GUI.Label(new Rect((width - 900) * s, 140 * s, 100 * s, 30 * s), "抗锯齿");
        int idx = GUI.Toolbar(new Rect((width - 800) * s, 140 * s, 280 * s, 30 * s), AntiToInt(QualitySettings.antiAliasing), antiStr);
        if (idx != AntiToInt(QualitySettings.antiAliasing))
            QualitySettings.antiAliasing = IntToAnti(idx);

        //帧率
        GUI.Label(new Rect((width - 900) * s, 180 * s, 100 * s, 30 * s), "帧率");
        idx = GUI.Toolbar(new Rect((width - 800) * s, 180 * s, 280 * s, 30 * s), FrameRateToInt(Application.targetFrameRate), frameRateStr);
        if (idx != FrameRateToInt(Application.targetFrameRate))
            Application.targetFrameRate = IntToFrameRate(idx);


        //网络消息整齐打印
        //NetCore.MessageHandle.s_prettyPrint = GUI.Toggle(new Rect((width - 900) * s, 260 * s, 300 * s, 30 * s), NetCore.MessageHandle.s_prettyPrint, "网络消息整齐打印");

    }

    #endregion

    public void Init()
    {
        //注册页面
        s_pages.Add(new PageInfo(s_pages.Count, "日志", DrawLog));
        s_pages.Add(new PageInfo(s_pages.Count, "性能", DrawPerformance));
        s_pages.Add(new PageInfo(s_pages.Count, "调试", DrawDebug));

        curPage = s_pages.Count - 1;

        Application.logMessageReceived += SystemLogCallback;
    }


    //临时测试用的东西，测试完即删
    public void DrawTemp()
    {

    }

}
