using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UI;

public class UILoading : View {

    public ImageEx m_progressBar;
    public TextEx m_percent;
    public TextEx m_desc;
    private string message;

    float m_progressWidth;
    static string DescStr;
    static string DataStr;

    public static UILoading Instance;
    ///<summary>
    /// 监听的消息
    ///</summary>
    List<string> MessageList
    {
        get
        {
            return new List<string>()
            {
                NotiConst.UPDATE_MESSAGE,
                NotiConst.UPDATE_EXTRACT,
                NotiConst.UPDATE_DOWNLOAD,
                NotiConst.UPDATE_PROGRESS,
            };
        }
    }

    void Awake()
    {
        Instance = this;
        RemoveMessage(this, MessageList);
        RegisterMessage(this, MessageList);
        var rect = m_progressBar.transform.parent.GetComponent<RectTransform>();
        m_progressWidth = rect.sizeDelta.x;
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        UpdateProgress(DataStr, DescStr);
    }

    /// <summary>
    /// 处理View消息
    /// </summary>
    /// <param name="message"></param>
    public override void OnMessage(IMessage message)
    {
        string name = message.Name;
        object body = message.Body;

        //Debug.Log("UILoading OnMessage name --- " + name);
        //Debug.Log("UILoading OnMessage body --- " + body.ToString());

        switch (name)
        {
            case NotiConst.UPDATE_MESSAGE:      //更新消息
                //UpdateMessage(body.ToString());
                DescStr = body.ToString();
                break;
            case NotiConst.UPDATE_EXTRACT:      //更新解压
                //UpdateExtract(body.ToString());
                DescStr = body.ToString();
                break;
            case NotiConst.UPDATE_DOWNLOAD:     //更新下载
                //UpdateDownload(body.ToString());
                DescStr = body.ToString();
                break;
            case NotiConst.UPDATE_PROGRESS:     //更新下载进度
                DataStr = body.ToString();
                //UpdateProgress(body.ToString());
                break;
        }
    }
    
    public void UpdateExtract(string data)
    {
        this.message = data;
        m_desc.text = data;
    }

    public void UpdateDownload(string data)
    {
        this.message = data;
        m_desc.text = data;
    }

    public void UpdateProgress(string dataStr, string descStr)
    {
        if (dataStr == null || descStr == null)
            return;

        this.message = dataStr;
        m_percent.text = dataStr + "%";
        m_desc.text = descStr;
        var rect = m_progressBar.GetComponent<RectTransform>();
        rect.sizeDelta = new Vector2(int.Parse(dataStr) / 100.0f * m_progressWidth, rect.sizeDelta.y);
    }

    public void LoadEnd()
    {
        gameObject.SetActive(false);
    }
}
