﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class SoundManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(SoundManager), typeof(Manager));
		L.RegFunction("GetUIAudio", GetUIAudio);
		L.RegFunction("Get2DAudio", Get2DAudio);
		L.RegFunction("GetBGAudio", GetBGAudio);
		L.RegFunction("LoadAudioClip", LoadAudioClip);
		L.RegFunction("CanPlayBackSound", CanPlayBackSound);
		L.RegFunction("CanPlaySoundEffect", CanPlaySoundEffect);
		L.RegFunction("Play", Play);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, set_instance);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUIAudio(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			UnityEngine.AudioSource o = obj.GetUIAudio();
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Get2DAudio(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			UnityEngine.AudioSource o = obj.Get2DAudio();
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBGAudio(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			UnityEngine.AudioSource o = obj.GetBGAudio();
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadAudioClip(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			string arg0 = ToLua.CheckString(L, 2);
			UnityEngine.AudioClip o = obj.LoadAudioClip(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CanPlayBackSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			bool o = obj.CanPlayBackSound();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CanPlaySoundEffect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			bool o = obj.CanPlaySoundEffect();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			SoundManager obj = (SoundManager)ToLua.CheckObject(L, 1, typeof(SoundManager));
			UnityEngine.AudioClip arg0 = (UnityEngine.AudioClip)ToLua.CheckUnityObject(L, 2, typeof(UnityEngine.AudioClip));
			UnityEngine.Vector3 arg1 = ToLua.ToVector3(L, 3);
			obj.Play(arg0, arg1);
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
	static int get_instance(IntPtr L)
	{
		try
		{
			ToLua.Push(L, SoundManager.instance);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_instance(IntPtr L)
	{
		try
		{
			SoundManager arg0 = (SoundManager)ToLua.CheckUnityObject(L, 2, typeof(SoundManager));
			SoundManager.instance = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

