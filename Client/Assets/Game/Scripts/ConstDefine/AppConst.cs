using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
public class AppConst
{
    public static string ConfigURL = "http://update.baicdn.com/cardsConfig.txt"; //先请求这个地址获取配置

    public static bool DebugMode = false;                       //调试模式-用于内部测试

    /// <summary>
    /// 如果开启更新模式，前提必须启动框架自带服务器端。
    /// 否则就需要自己将StreamingAssets里面的所有内容
    /// 复制到自己的Webserver上面，并修改下面的WebUrl。
    /// </summary>
#if UNITY_EDITOR
    public static bool UpdateMode = false;                       //更新模式-默认关闭 true:使用WebUrl地址里的资源
#else
    public static bool UpdateMode = true;                       //更新模式-默认关闭 true:使用WebUrl地址里的资源
#endif

    public static bool LuaByteMode = false;                       //Lua字节码模式-默认关闭  //MAC平台需设为false 不支持在mac下打包为byte
    public static bool LuaBundleMode = false;                    //Lua代码AssetBundle模式    //这里打开就加载不到lua脚本了 需要在LuaManager里加Assetbundle路径

#if UNITY_EDITOR
    public static bool PrefabBundleMod = false;                   //调试prefab false:直接用Resources下的UI预置体资源 true:用ui打包后的AssetBundles
    public static bool UpdateResource = true;                    //自动替换更新资源
    public static string TestResourceFolder = "../../Other/TestResource/";   //测试资源路径
#else
    public static bool PrefabBundleMod = true;
    public static bool UpdateResource = true;
    public static string TestResourceFolder = "../../Other/TestResource/";
#endif

    public static int TimerInterval = 1;
    public static int GameFrameRate = 30;                        //游戏帧频

    public static string AppName = "Game";               //应用程序名称
    public static string LuaTempDir = "Lua/";                    //临时目录
    public static string AppPrefix = AppName + "_";              //应用程序前缀
    public static string ExtName = ".unity3d";                   //素材扩展名
    public static string AssetDir = "StreamingAssets";           //素材目录 
    //public static string WebUrl = "http://localhost:6688/";      //测试更新地址
    //public static string WebUrl = "http://update.yushanziben.com/mahjong/test/StreamingAssets/";
    public static string WebUrl = "http://192.168.1.186:8080/";      //测试更新地址
    //public static string WebUrl = "https://up.awcdn.com/ahpgTest/";      //测试更新地址

    public static string UserId = string.Empty;                 //用户ID
    public static int SocketPort = 0;                           //Socket服务器端口
    public static string SocketAddress = string.Empty;          //Socket服务器地址

    public static string FrameworkRoot
    {
        get
        {
            return Application.dataPath + "/" + AppName;
        }
    }
}
