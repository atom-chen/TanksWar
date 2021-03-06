﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class SDKManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(SDKManager), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Authorize", Authorize);
		L.RegFunction("CallMethod", CallMethod);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, set_instance);
		L.RegVar("ssdk", get_ssdk, set_ssdk);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Authorize(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(SDKManager), typeof(cn.sharesdk.unity3d.PlatformType)))
			{
				SDKManager obj = (SDKManager)ToLua.ToObject(L, 1);
				cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.ToObject(L, 2);
				obj.Authorize(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(SDKManager), typeof(int)))
			{
				SDKManager obj = (SDKManager)ToLua.ToObject(L, 1);
				int arg0 = (int)LuaDLL.lua_tonumber(L, 2);
				obj.Authorize(arg0);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: SDKManager.Authorize");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CallMethod(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			SDKManager obj = (SDKManager)ToLua.CheckObject(L, 1, typeof(SDKManager));
			string arg0 = ToLua.CheckString(L, 2);
			object[] arg1 = ToLua.ToParamsObject(L, 3, count - 2);
			object[] o = obj.CallMethod(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_instance(IntPtr L)
	{
		try
		{
			ToLua.Push(L, SDKManager.instance);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ssdk(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SDKManager obj = (SDKManager)o;
			cn.sharesdk.unity3d.ShareSDK ret = obj.ssdk;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ssdk on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_instance(IntPtr L)
	{
		try
		{
			SDKManager arg0 = (SDKManager)ToLua.CheckUnityObject(L, 2, typeof(SDKManager));
			SDKManager.instance = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ssdk(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SDKManager obj = (SDKManager)o;
			cn.sharesdk.unity3d.ShareSDK arg0 = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckUnityObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK));
			obj.ssdk = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ssdk on a nil value" : e.Message);
		}
	}
}

