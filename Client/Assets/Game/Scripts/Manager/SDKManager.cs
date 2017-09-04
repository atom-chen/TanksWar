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

        if (state == ResponseState.Success)
        {
            Debuger.LogError("authorize success !" + "Platform :" + type);
        }
        else if (state == ResponseState.Fail)
        {
            Debuger.LogError("fail! throwable stack  " + MiniJSON.jsonEncode(result));
#if UNITY_ANDROID
            //Debuger.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError ("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            Debuger.LogError("cancel !");
        }
        CallMethod("OnAuthResult", reqID, state, type, MiniJSON.jsonEncode(result));

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
            print("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			print ("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
#endif
        }
        else if (state == ResponseState.Cancel)
        {
            print("cancel !");
        }

        CallMethod("OnGetUserInfoResult", reqID, state, type, MiniJSON.jsonEncode(result));

    }

    void OnShareResultHandler(int reqID, ResponseState state, PlatformType type, Hashtable result)
    {

        if (state == ResponseState.Success)
        {
            Debuger.LogError("share successfully - share result :");
            Debuger.LogError(MiniJSON.jsonEncode(result));
        }
        else if (state == ResponseState.Fail)
        {
#if UNITY_ANDROID
            Debuger.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError ("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
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
            print("get friend list result :");
            Debuger.LogError(MiniJSON.jsonEncode(result));
        }
        else if (state == ResponseState.Fail)
        {
#if UNITY_ANDROID
            Debuger.LogError("fail! throwable stack = " + result["stack"] + "; error msg = " + result["msg"]);
#elif UNITY_IPHONE
			Debuger.LogError ("fail! error code = " + result["error_code"] + "; error msg = " + result["error_msg"]);
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

}
