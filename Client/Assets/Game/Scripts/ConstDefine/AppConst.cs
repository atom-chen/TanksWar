using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
public class AppConst
{
    public const bool DebugMode = false;                       //调试模式-用于内部测试

    /// <summary>
    /// 如果开启更新模式，前提必须启动框架自带服务器端。
    /// 否则就需要自己将StreamingAssets里面的所有内容
    /// 复制到自己的Webserver上面，并修改下面的WebUrl。
    /// </summary>
    public const bool UpdateMode = false;                       //更新模式-默认关闭 true:使用WebUrl地址里的资源
    public const bool LuaByteMode = true;                       //Lua字节码模式-默认关闭 
    public const bool LuaBundleMode = false;                    //Lua代码AssetBundle模式    //这里打开就加载不到lua脚本了 有待研究
    public const bool PrefabBundleMod = false;                   //调试prefab 打包时必须改为true  false:直接用Resources下的UI预置体资源 true:用ui打包后的AssetBundles

    public const int TimerInterval = 1;
    public const int GameFrameRate = 30;                        //游戏帧频

    public const string AppName = "Game";               //应用程序名称
    public const string LuaTempDir = "Lua/";                    //临时目录
    public const string AppPrefix = AppName + "_";              //应用程序前缀
    public const string ExtName = ".unity3d";                   //素材扩展名
    public const string AssetDir = "StreamingAssets";           //素材目录 
    //public const string WebUrl = "http://localhost:6688/";      //测试更新地址
    //public const string WebUrl = "http://update.yushanziben.com/mahjong/test/StreamingAssets/";
    public const string WebUrl = "http://192.168.1.186:8080/";      //测试更新地址

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
