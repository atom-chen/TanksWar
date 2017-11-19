using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SoundManager : Manager
{
    AudioSource m_audioUI;
    AudioSource m_audioBG;
    AudioSource m_audio2D;

    private Hashtable sounds = new Hashtable();

    public static SoundManager instance;

    private void Awake()
    {
    }

    void Start()
    {
        m_audioUI = this.gameObject.AddComponent<AudioSource>();
        m_audioBG = this.gameObject.AddComponent<AudioSource>();
        m_audio2D = this.gameObject.AddComponent<AudioSource>();
        instance = this;
    }

    /// <summary>
    /// 添加一个声音
    /// </summary>
    void Add(string key, AudioClip value)
    {
        if (sounds[key] != null || value == null) return;
        sounds.Add(key, value);
    }

    /// <summary>
    /// 获取一个声音
    /// </summary>
    AudioClip Get(string key)
    {
        if (sounds[key] == null) return null;
        return sounds[key] as AudioClip;
    }

    public AudioSource GetUIAudio()
    {
        return m_audioUI;
    }

    public AudioSource Get2DAudio()
    {
        return m_audio2D;
    }

    public AudioSource GetBGAudio()
    {
        return m_audioBG;
    }

    /// <summary>
    /// 载入一个音频
    /// </summary>
    public AudioClip LoadAudioClip(string path)
    {
        AudioClip ac = Get(path);
        if (ac == null)
        {
            ac = (AudioClip)Resources.Load(path, typeof(AudioClip));
            Add(path, ac);
        }
        return ac;
    }

    /// <summary>
    /// 是否播放背景音乐，默认是1：播放
    /// </summary>
    /// <returns></returns>
    public bool CanPlayBackSound()
    {
        string key = AppConst.AppPrefix + "BackSound";
        int i = PlayerPrefs.GetInt(key, 1);
        return i == 1;
    }
    

    /// <summary>
    /// 是否播放音效,默认是1：播放
    /// </summary>
    /// <returns></returns>
    public bool CanPlaySoundEffect()
    {
        string key = AppConst.AppPrefix + "SoundEffect";
        int i = PlayerPrefs.GetInt(key, 1);
        return i == 1;
    }

    /// <summary>
    /// 播放音频剪辑
    /// </summary>
    /// <param name="clip"></param>
    /// <param name="position"></param>
    public void Play(AudioClip clip, Vector3 position)
    {
        if (!CanPlaySoundEffect()) return;
        AudioSource.PlayClipAtPoint(clip, position);
    }
}
