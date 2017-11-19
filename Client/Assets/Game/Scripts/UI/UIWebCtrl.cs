using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using System.Collections.Generic;
using System.Collections;


public class UIWebCtrl:MonoBehaviour
{
    private UniWebView webView;
    public string url = "";
    private RectTransform Content;
    private Canvas mCanvas;

    private void Awake()
    {
        webView = this.transform.GetComponentInChildren<UniWebView>();
        mCanvas = this.transform.GetComponentInParent<Canvas>();
        Content = this.transform.GetComponent<RectTransform>();
    }

    private void Start()
    {           
        LoadWebView();
    }


    void LoadWebView()
    {
        if (url=="")
        {
            Debug.LogError(this.transform.parent.gameObject.name  +"   :  webview  url 为空    ");
            return;
        }

        webView.Load(url);
        webView.Show(true);
        webView.InsetsForScreenOreitation += InsetsForScreenOreitation;
        webView.SetHorizontalScrollBarShow(false);
    }


    private void OnEnable()
    {
        ShowOrHide(true);
    }

    private void OnDisable()
    {
        ShowOrHide(false);
    }


    /// <summary>
    /// WebView 界面的显示隐藏
    /// </summary>
    /// <param name="flag"></param>
    public void ShowOrHide(bool flag)
    {

        if (flag)
        {
            webView.Show(true);
        }
        else
        {
            webView.Hide();        
        }           
    }

    //销毁WebView
    public void DestoryWebView()
    {
        webView.Hide();
        UnityEngine.Object.Destroy(webView.gameObject);
        webView.InsetsForScreenOreitation -= InsetsForScreenOreitation;
        webView = null;
    }

    UniWebViewEdgeInsets InsetsForScreenOreitation(UniWebView webView, UniWebViewOrientation orientation)
    {
        Vector3[] fourCornersArray = new Vector3[4];
        Content.GetWorldCorners(fourCornersArray);
        Camera cameraTmp = null;
        if (mCanvas.renderMode == RenderMode.ScreenSpaceOverlay)
        {
        }
        else
        {
            cameraTmp = mCanvas.worldCamera;
        }
        Vector2 bottomLeft = RectTransformUtility.WorldToScreenPoint(cameraTmp, fourCornersArray[0]);
        //Vector2 pos1 = cameraTmp.WorldToScreenPoint(fourCornersArray[1]);
        Vector2 topRight = RectTransformUtility.WorldToScreenPoint(cameraTmp, fourCornersArray[2]);
        //  Vector2 pos3 = cameraTmp.WorldToScreenPoint(fourCornersArray[3]);

        float _top = Screen.height - topRight.y;
        float _left = bottomLeft.x;
        float _bottom = bottomLeft.y;
        float _right = Screen.width - topRight.x;

        if (orientation == UniWebViewOrientation.Portrait)  //竖屏
        {
            int offset = 0;
            return new UniWebViewEdgeInsets(
            ConvertPixelToPoint(_top, false) + offset,
            ConvertPixelToPoint(_left, true) + offset,
            ConvertPixelToPoint(_bottom, false) + offset,
            ConvertPixelToPoint(_right, true) + offset);
        }
        else//横屏
        {
            int offset = 0;

            return new UniWebViewEdgeInsets(
            ConvertPixelToPoint(_top, false) + offset,
            ConvertPixelToPoint(_left, true) + offset,
            ConvertPixelToPoint(_bottom, false) + offset,
            ConvertPixelToPoint(_right, true) + offset);
        }
    }


    public static int ConvertPixelToPoint(float pixel, bool width)
    {
#if UNITY_IOS && !UNITY_EDITOR
	float scale = 0;
	if (width)
	{
		scale = 1f * UniWebViewHelper.screenWidth / Screen.width;
	}
	else
	{
		scale = 1f * UniWebViewHelper.screenHeight / Screen.height;
	}

	return (int)(pixel * scale);
#endif

        return (int)pixel;
    }

}
