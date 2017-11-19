-- SoundMgr.lua
-- Author : Dzq
-- Date : 2017-11-08
-- Last modification : 2017-11-08
-- Desc: 音效管理类

module(..., package.seeall)

local m_audioUI = false
local m_audioBG = false
local m_audio2D = false

function OnLoadFinish()
	-- log("SoundMgr -------")
	m_audioUI = SoundManager.instance:GetUIAudio()
	m_audioBG = SoundManager.instance:GetBGAudio()
	m_audio2D = SoundManager.instance:Get2DAudio()
end

function PlayUI(name)
	-- util.Log("PlayUI---"..name)
	local clip = ResTool.GetAudioClip(name)
	if clip then
		m_audioUI.loop = false
		m_audioUI.clip = clip
		m_audioUI:Play()
	else
		m_audioUI.loop = false
		m_audioUI:Stop()
		m_audioUI.clip = nil
		Util.ClearMemory()
	end
end

function Play2D(name)
	local clip = ResTool.GetAudioClip(name)
	if clip then
		m_audio2D.loop = false
		m_audio2D.clip = clip
		m_audio2D:Play()
	else
		m_audio2D.loop = false
		m_audioUI:Stop()
		m_audio2D.clip = nil
		Util.ClearMemory()
	end
end

function PlayBG(name, loop)
	local clip = ResTool.GetAudioClip(name)
	if clip then
		m_audioBG.loop = loop
		m_audioBG.clip = clip
		m_audioBG:Play()
	else
		m_audioBG.loop = false
		m_audioUI:Stop()
		m_audioBG.clip = nil
		Util.ClearMemory()
	end
end

function StopBG()
	m_audioBG.loop = false
	m_audioBG.clip = nil
	m_audioBG.Stop()
end

function PauseBG()
	m_audioBG.Pause()
end

function UnPauseBG()
	m_audioBG.UnPause()
end

function SetBGVol(num)
	m_audioBG.volume = num
end

function Set2DVol(num)
	m_audioUI.volume = num
	m_audio2D.volume = num
end

function SetMute(bMute)
	m_audioBG.mute = bMute
	m_audioUI.mute = bMute
	m_audio2D.mute = bMute
end

function GetBGVol()
	return m_audioBG.volume
end

function Get2DVol()
	return m_audio2D.volume
end

function CanPlay()
	if m_audioUI and m_audioBG and m_audio2D then
		return true
	end

	return false
end

function PlayStateHandleEnter(clipName, ctrlType, goName, curState)

	if not CanPlay() then
		return
	end

	if clipName == "" and ctrlType ~= 1 then
		return
	end

	if clipName == "" then	--如果有播放声音 但又没填声音名 默认播放common_click
		if curState == 1 then
			PlayUI(SoundCfg.common_click)
		end
	else
		PlayUI(clipName)
	end
end

function PlayStateHandleExit(clipName, ctrlType, goName, curState)

	if not CanPlay() then
		return
	end

	if clipName == "" then
		return
	end

	PlayUI(clipName)
end

