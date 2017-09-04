﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UI_AnimatorHandleWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UI.AnimatorHandle), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Play", Play);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("m_curAni", get_m_curAni, set_m_curAni);
		L.RegVar("m_playOnEnable", get_m_playOnEnable, set_m_playOnEnable);
		L.RegVar("m_ani", get_m_ani, set_m_ani);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)ToLua.CheckObject(L, 1, typeof(UI.AnimatorHandle));
			obj.Play();
			return 0;
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
	static int get_m_curAni(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			string ret = obj.m_curAni;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_curAni on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_playOnEnable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			bool ret = obj.m_playOnEnable;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_playOnEnable on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_ani(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			UnityEngine.Animator ret = obj.m_ani;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_ani on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_curAni(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.m_curAni = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_curAni on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_playOnEnable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.m_playOnEnable = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_playOnEnable on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_ani(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UI.AnimatorHandle obj = (UI.AnimatorHandle)o;
			UnityEngine.Animator arg0 = (UnityEngine.Animator)ToLua.CheckUnityObject(L, 2, typeof(UnityEngine.Animator));
			obj.m_ani = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index m_ani on a nil value" : e.Message);
		}
	}
}
