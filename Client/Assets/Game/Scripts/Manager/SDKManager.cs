using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using cn.sharesdk.unity3d;

public class SDKManager : MonoBehaviour {

    public static SDKManager instance;

    public ShareSDK ssdk;

    private void Awake()
    {
        instance = this;
    }

    // Use this for initialization
    void Start () {
#if !UNITY_EDITOR
        //分享配置
        ssdk = gameObject.GetComponent<ShareSDK>();
        ssdk.authHandler = OnAuthResultHandler;
        ssdk.shareHandler = OnShareResultHandler;
        ssdk.showUserHandler = OnGetUserInfoResultHandler;
        ssdk.getFriendsHandler = OnGetFriendsResultHandler;
#endif
        DontDestroyOnLoad(gameObject);  //防止销毁自己

    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public bool IsClientValid(int platType)
    {
        return ssdk.IsClientValid((PlatformType)platType);
    }

    public void Authorize(int platType)
    {
#if !UNITY_EDITOR
        PlatformType type = (PlatformType)platType;
        ssdk.Authorize(type);
#endif      
    }

    public void Authorize(PlatformType platType)
    {
#if !UNITY_EDITOR
        ssdk.Authorize(platType);
#endif
    }

    void OnAuthResultHandler(int reqID, ResponseState state, PlatformType type, Hashtable result)
    {
        string wechatStr = "";
        if (state == ResponseState.Success)
        {
            Debuger.Log("authorize success !" + "Platform :" + type);

            Hashtable wechatInfo = ssdk.GetAuthInfo(PlatformType.WeChat);
            wechatStr = MiniJSON.jsonEncode(wechatInfo);
        }
        else if (state == ResponseState.Fail)
        {
            Debuger.LogError("fail! throwable stack  " + MiniJSON.jsonEncode(result));
#if UNITY_ANDROID
            //Debuger.Log("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            Debuger.Log("cancel !");
        }
        CallMethod("OnAuthResult", reqID, state, type, MiniJSON.jsonEncode(result), wechatStr);

    }

    void OnGetUserInfoResultHandler(int reqID, ResponseState state, PlatformType type, Hashtable result)
    {

        if (state == ResponseState.Success)
        {
            print("get user info result :");
            print(MiniJSON.jsonEncode(result));
            print("AuthInfo:" + MiniJSON.jsonEncode(ssdk.GetAuthInfo(PlatformType.SinaWeibo)));
            print("Get userInfo success !Platform :" + type);
        }
        else if (state == ResponseState.Fail)
        {
#if UNITY_ANDROID
            Debug.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debug.LogError("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            Debug.LogError("cancel !");
        }

        CallMethod("OnGetUserInfoResult", reqID, state, type, MiniJSON.jsonEncode(result));

    }



    void OnShareResultHandler(int reqID, ResponseState state, PlatformType type, Hashtable result)
    {

        if (state == ResponseState.Success)
        {
            Debuger.Log("share successfully - share result :");
            Debuger.Log(MiniJSON.jsonEncode(result));
        }
        else if (state == ResponseState.Fail)
        {
#if UNITY_ANDROID
            Debuger.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            Debuger.LogError("cancel !");
        }

        CallMethod("OnShareResult", reqID, state, type, MiniJSON.jsonEncode(result));

    }

    void OnGetFriendsResultHandler(int reqID, ResponseState state, PlatformType type, Hashtable result)
    {

        if (state == ResponseState.Success)
        {
            Debug.Log("get friend list result :");
            Debuger.Log(MiniJSON.jsonEncode(result));
        }
        else if (state == ResponseState.Fail)
        {
#if UNITY_ANDROID
            Debuger.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            Debuger.LogError("cancel !");
        }

        CallMethod("OnGetFriendsResult", reqID, state, type, MiniJSON.jsonEncode(result));

    }

    public object[] CallMethod(string func, params object[] args)
    {
        return Util.CallMethod("SDKMgr", func, args);
    }

    // 分享邀请码  到微信
    public void ShareWeChatFriend(string url, string text, string title, string imgURL, string site)
    {
        Debug.Log("ShareWeChatFriend   -------  ");

#if !UNITY_EDITOR
        ShareContent content = new ShareContent();
        content.SetText(text);
        content.SetImageUrl(imgURL);
        content.SetTitle(title);
        content.SetTitleUrl(url);
        content.SetSite(site);
        content.SetSiteUrl(url);
        content.SetUrl(url);
       
        content.SetShareType(ContentType.Webpage);
        ssdk.ShareContent(PlatformType.WeChat, content);
#endif
    }

    //分享邀请码 到朋友圈
    public void ShareWeChatMoments(string url, string text, string title, string imgURL, string site)
    {
        Debug.Log("ShareWeChatMoments   -------  ");

#if !UNITY_EDITOR
        ShareContent content = new ShareContent();
        content.SetText(text);
        content.SetImageUrl(imgURL);
        content.SetTitle(title);
        content.SetTitleUrl(url);
        content.SetSite(site);
        content.SetSiteUrl(url);
        
        content.SetUrl(url);
        //content.SetComment("test description");
        //content.SetMusicUrl("http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3");
        content.SetShareType(ContentType.Webpage);

        ssdk.ShareContent(PlatformType.WeChatMoments, content);
#endif
    }

}
