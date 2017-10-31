using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

//状态控件
public partial class StateHandle : MonoBehaviour,
    IPointerDownHandler,
    IPointerUpHandler,
    IPointerClickHandler
//IBeginDragHandler, 
//IDragHandler, 
//IEndDragHandler
//IPointerEnterHandler,
//IPointerExitHandler,
//IPointerClickHandler,
//IInitializePotentialDragHandler,
//IDropHandler,
//IScrollHandler,
//IUpdateSelectedHandler,
//ISelectHandler,
//IDeselectHandler,
//IMoveHandler,
//ISubmitHandler,
//ICancelHandler
{
    //控制器类型
    public enum CtrlType
    {
        none,
        button,//
        toggle,
        //funBool,//每个update检查一个函数，返回值true 1,false 0
        //funInt,//每个update检查一个函数，返回值int设置状态
    }
    public float m_pressHoldTime = 0.4f;
    public CtrlType m_ctrlType = CtrlType.none;


    bool m_enableCtrlState = true;//false就不会自己改变状态，但是消息仍然正常发送
    bool m_isPressing = false;//是不是在按紧状态
    bool m_isPressHoldThisTime = false;
    float m_lastPressTime;//最后一次按的时间
                          //public UnityEvent<bool> m_onFunBool;
                          //public UnityEvent<int> m_onFunInt;

    LuaTable m_luaTbl = null;     //lua对象 回调时用到

    #region 消息
    static Action<StateHandle> ms_globalClickHook;
    static Action<StateHandle> ms_globalHoldHook;
    static Action<PointerEventData> ms_globalDownHook;
    static Action<PointerEventData> ms_globalUpHook;
    static Action<PointerEventData> ms_globalDragBeginHook;
    static Action<PointerEventData> ms_globalDragEndHook;
    static Action<StateHandle, int> ms_globalStateHook;

    Action m_onClick;
    Action<LuaTable> m_onLuaClick;

    Action<StateHandle> m_onClickEx;
    Action<LuaTable, StateHandle> m_onLuaClickEx;

    Action<StateHandle> m_onPressHold;//按紧，如果有这个回调，那么按紧超过这个时间后就会调用，并且不触发onClick
    Action<LuaTable, StateHandle> m_onLuaPressHold;

    Action<StateHandle, int> m_onChangeState;
    Action<LuaTable, StateHandle, int> m_onLuaChangeState;

    Action<PointerEventData> m_onPointUp;
    Action<LuaTable, PointerEventData> m_onLuaPointUp;

    Action<PointerEventData> m_onPointDown;
    Action<LuaTable, PointerEventData> m_onLuaPointDown;

    Action<PointerEventData> m_onDragBegin;
    Action<LuaTable, PointerEventData> m_onLuaDragBegin;

    Action<PointerEventData> m_onDrag;
    Action<LuaTable, PointerEventData> m_onLuaDrag;

    Action<PointerEventData> m_onDragEnd;
    Action<LuaTable, PointerEventData> m_onLuaDragEnd;
    #endregion

    public bool EnableCtrlState { get { return m_enableCtrlState; } set { m_enableCtrlState = value; } }

    #region 消息
    public static void AddGlobalHook(Action<StateHandle> click = null, Action<StateHandle> hold = null, Action<PointerEventData> onPointDown = null, Action<PointerEventData> onPointUp = null, Action<PointerEventData> dragBegin = null, Action<PointerEventData> dragEnd = null, Action<StateHandle, int> onChangeState = null)
    {
        if (click != null)
            ms_globalClickHook += click;
        if (hold != null)
            ms_globalHoldHook += hold;
        if (onPointDown != null)
            ms_globalDownHook += onPointDown;
        if (onPointUp != null)
            ms_globalUpHook += onPointUp;
        if (dragBegin != null)
            ms_globalDragBeginHook += dragBegin;
        if (dragEnd != null)
            ms_globalDragEndHook += dragEnd;
        if (onChangeState != null)
            ms_globalStateHook += onChangeState;
    }
    public static void RemoveGlobalHook(Action<StateHandle> click = null, Action<StateHandle> hold = null, Action<PointerEventData> onPointDown = null, Action<PointerEventData> onPointUp = null, Action<PointerEventData> dragBegin = null, Action<PointerEventData> dragEnd = null, Action<StateHandle, int> onChangeState = null)
    {
        if (click != null)
            ms_globalClickHook -= click;
        if (hold != null)
            ms_globalHoldHook -= hold;
        if (onPointDown != null)
            ms_globalDownHook -= onPointDown;
        if (onPointUp != null)
            ms_globalUpHook -= onPointUp;
        if (dragBegin != null)
            ms_globalDragBeginHook -= dragBegin;
        if (dragEnd != null)
            ms_globalDragEndHook -= dragEnd;
        if (onChangeState != null)
            ms_globalStateHook -= onChangeState;
    }

    public void AddClick(Action cb)
    {
        if (m_onClick == null)
        {
            m_onClick = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onClick.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onClick += cb;
    }

    public void AddLuaClick(Action<LuaTable> cb, LuaTable tbl)
    {
        m_luaTbl = tbl;

        if (m_onLuaClick == null)
        {
            m_onLuaClick = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaClick.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onLuaClick += cb;
    }

    public void AddClickEx(Action<StateHandle> cb)
    {
        if (m_onClickEx == null)
        {
            m_onClickEx = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onClickEx.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onClickEx += cb;
    }

    public void AddLuaClickEx(Action<LuaTable, StateHandle> cb, LuaTable tbl)
    {
        m_luaTbl = tbl;

        if (m_onLuaClickEx == null)
        {
            m_onLuaClickEx = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaClickEx.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onLuaClickEx += cb;
    }

    public void AddPressHold(Action<StateHandle> cb, bool reset = false)
    {
        if (m_onPressHold == null || reset)
        {
            m_onPressHold = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onPressHold.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onPressHold += cb;
    }

    public void AddLuaPressHold(Action<LuaTable, StateHandle> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        if (m_onLuaPressHold == null || reset)
        {
            m_onLuaPressHold = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaPressHold.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onLuaPressHold += cb;
    }

    public void AddChangeState(Action<StateHandle, int> cb, bool reset = false)
    {

        if (m_onChangeState == null || reset)
        {
            m_onChangeState = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onChangeState.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onChangeState += cb;
    }

    public void AddLuaChangeState(Action<LuaTable, StateHandle, int> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        if (m_onLuaChangeState == null || reset)
        {
            m_onLuaChangeState = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaChangeState.GetInvocationList();
        foreach (Delegate d in inlist)
        {
            if (d == cb)
                return;
        }

        m_onLuaChangeState += cb;
    }


    public void AddPointUp(Action<PointerEventData> cb, bool reset = false)
    {
        if (m_onPointUp == null || reset)
        {
            m_onPointUp = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onPointUp.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onPointUp += cb;
    }

    public void AddLuaPointUp(Action<LuaTable, PointerEventData> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        if (m_onLuaPointUp == null || reset)
        {
            m_onLuaPointUp = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaPointUp.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onLuaPointUp += cb;
    }

    public void AddPointDown(Action<PointerEventData> cb, bool reset = false)
    {
        if (m_onPointDown == null || reset)
        {
            m_onPointDown = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onPointDown.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onPointDown += cb;
    }


    public void AddLuaPointDown(Action<LuaTable, PointerEventData> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        if (m_onLuaPointDown == null || reset)
        {
            m_onLuaPointDown = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaPointDown.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onLuaPointDown += cb;
    }


    public void AddDragBegin(Action<PointerEventData> cb, bool reset = false)
    {
        CheckDragListener();
        if (m_onDragBegin == null || reset)
        {
            m_onDragBegin = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onDragBegin.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onDragBegin += cb;
    }

    public void AddLuaDragBegin(Action<LuaTable, PointerEventData> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        CheckDragListener();
        if (m_onLuaDragBegin == null || reset)
        {
            m_onLuaDragBegin = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaDragBegin.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onLuaDragBegin += cb;
    }


    public void AddDrag(Action<PointerEventData> cb, bool reset = false)
    {
        CheckDragListener();
        if (m_onDrag == null || reset)
        {
            m_onDrag = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onDrag.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onDrag += cb;
    }


    public void AddLuaDrag(Action<LuaTable, PointerEventData> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        CheckDragListener();
        if (m_onLuaDrag == null || reset)
        {
            m_onLuaDrag = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaDrag.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onLuaDrag += cb;
    }

    public void AddDragEnd(Action<PointerEventData> cb, bool reset = false)
    {
        CheckDragListener();
        if (m_onDragEnd == null || reset)
        {
            m_onDragEnd = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onDragEnd.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onDragEnd += cb;
    }


    public void AddLuaDragEnd(Action<LuaTable, PointerEventData> cb, LuaTable tbl, bool reset = false)
    {
        m_luaTbl = tbl;

        CheckDragListener();
        if (m_onLuaDragEnd == null || reset)
        {
            m_onLuaDragEnd = cb;
            return;
        }

        //如果重复添加，那么就不添加了
        Delegate[] inlist = m_onLuaDragEnd.GetInvocationList();
        foreach (Delegate d in inlist)
            if (d == cb) return;

        m_onLuaDragEnd += cb;
    }

    #endregion

    #region 状态变化监听
    void UpdateSelectable()
    {
        if (!m_isPressHoldThisTime && m_isPressing && Time.unscaledTime - m_lastPressTime > m_pressHoldTime)
        {
            m_isPressHoldThisTime = true;
            if (m_onPressHold != null)
            {
                m_onPressHold(this);

                if (ms_globalHoldHook != null)
                    ms_globalHoldHook(this);
            }

            if (m_onLuaPressHold != null)
            {
                m_onLuaPressHold(m_luaTbl, this);
            }
        }
    }
    public void OnPointerClick(PointerEventData eventData)
    {
        //如果已经触发了按紧，那么不触发点击
        if (m_onPressHold != null && Time.unscaledTime - m_lastPressTime > m_pressHoldTime)
            return;

        //Vector2 p = eventData == null ? Vector2.zero : eventData.position;
        //if (eventData.eligibleForClick)//如果鼠标提起的时候已经偏移了5个像素，那么没有点击事件 (pressPosition - p).sqrMagnitude < 25
        //{
        if (m_onClickEx != null)
            m_onClickEx(this);

        if (m_onLuaClickEx != null)
            m_onLuaClickEx(m_luaTbl, this);

        if (m_onClick != null)
            m_onClick();

        if (m_onLuaClick != null)
            m_onLuaClick(m_luaTbl);

        //}

        if ((m_onClickEx != null || m_onClick != null) && ms_globalClickHook != null)
            ms_globalClickHook(this);
    }


    //Vector2 pressPosition = Vector2.zero;
    public void OnPointerDown(PointerEventData eventData)
    {
        //记录下最后按下的时间
        m_isPressing = true;
        m_isPressHoldThisTime = false;
        m_lastPressTime = Time.unscaledTime;
        
        if (m_onPointDown != null)
        {
            //lastPress很可能不是当前对象，这里重新赋值
            if (eventData != null)
            {
                eventData.pointerPress = gameObject;
            }
            else
            {
                eventData = new PointerEventData(EventSystem.current);
                eventData.pointerPress = gameObject;
            }

            m_onPointDown(eventData);

            if (ms_globalDownHook != null)
                ms_globalDownHook(eventData);
        }
        //if (!IsActive() || !IsInteractable())
        //    return;
        //pressPosition = eventData == null?Vector2.zero:eventData.position;
        //控件状态变化
        if (!m_enableCtrlState)
            return;
        else if (m_ctrlType == CtrlType.button)
        {
            if (this.m_curState == 0 || this.m_curState == 1)
                this.SetState(1);
        }

    }

    public void OnPointerUp(PointerEventData eventData)
    {
        m_isPressing = false;

        //如果已经触发了按紧，那么不触发点击

        //控件状态变化
        if (!m_enableCtrlState)
        {

        }
        else if (m_ctrlType == CtrlType.button)
        {
            if (this.m_curState == 0 || this.m_curState == 1)
                this.SetState(0);
        }
        else if (m_ctrlType == CtrlType.toggle)
        {
            if ((m_onPressHold != null || m_onLuaPressHold != null) && Time.unscaledTime - m_lastPressTime > m_pressHoldTime)
                return;

            if (this.m_curState == 0 || this.m_curState == 1)
                this.SetState(this.m_curState == 0 ? 1 : 0);
        }

        //if (!IsActive() || !IsInteractable())
        //    return;
        
        if (m_onPointUp != null)
        {
            //这个函数被手动调用时，eventData可能为null
            if (eventData == null)
            {
                eventData = new PointerEventData(EventSystem.current);
                eventData.pointerPress = gameObject;
            }

            m_onPointUp(eventData);

            if (ms_globalUpHook != null)
                ms_globalUpHook(eventData);
        }

        if (m_onLuaPointUp != null)
        {
            //这个函数被手动调用时，eventData可能为null
            if (eventData == null)
            {
                eventData = new PointerEventData(EventSystem.current);
                eventData.pointerPress = gameObject;
            }

            m_onLuaPointUp(m_luaTbl, eventData);

            if (ms_globalUpHook != null)
                ms_globalUpHook(eventData);
        }
    }
    void CheckDragListener()
    {
        DragListener l = this.GetComponent<DragListener>();
        if (l == null)
            l = this.gameObject.AddComponentIfNoExist<DragListener>();

        if (l.onDragBegin == null || l.onDrag == null || l.onDragEnd == null)
        {
            l.onDragBegin = OnBeginDrag;
            l.onDrag = OnDrag;
            l.onDragEnd = OnEndDrag;
        }
    }

    void OnBeginDrag(PointerEventData eventData)
    {
        if (m_onDragBegin != null)
            m_onDragBegin(eventData);

        if (m_onLuaDragBegin != null)
            m_onLuaDragBegin(m_luaTbl, eventData);

        //这里不判断m_onDragBegin不为null再执行ms_globalDragBeginHook，是为了引导回调，因为有些UI没订阅BeginDrag
        if (ms_globalDragBeginHook != null)
            ms_globalDragBeginHook(eventData);
    }

    void OnDrag(PointerEventData eventData)
    {
        if (m_onDrag != null)
            m_onDrag(eventData);

        if (m_onLuaDrag != null)
            m_onLuaDrag(m_luaTbl, eventData);
    }

    void OnEndDrag(PointerEventData eventData)
    {
        if (m_onDragEnd != null)
            m_onDragEnd(eventData);

        if (m_onLuaDragEnd != null)
            m_onLuaDragEnd(m_luaTbl, eventData);

        //这里不判断m_onDragEnd不为null再执行ms_globalDragEndHook，是为了引导回调，因为有些UI没订阅EndDrag
        if (ms_globalDragEndHook != null)
            ms_globalDragEndHook(eventData);
    }

    #region 模拟操作
    public void ExecuteClick()
    {
        if (m_onClickEx != null)
            m_onClickEx(this);

        if (m_onClick != null)
            m_onClick();

        if (m_onLuaClick != null)
            m_onLuaClick(m_luaTbl);

        if (m_onLuaClickEx != null)
            m_onLuaClickEx(m_luaTbl, this);

        if ((m_onClickEx != null || m_onClick != null || m_onLuaClickEx != null || m_onLuaClick != null) && ms_globalClickHook != null)
            ms_globalClickHook(this);
    }

    public void ExecuteDown()
    {
        ExecuteDown(Vector2.zero);
    }

    public void ExecuteDown(Vector2 position)
    {
        if (m_onPointDown != null)
        {
            var eventData = new PointerEventData(EventSystem.current);
            eventData.pointerPress = gameObject;
            eventData.position = position;

            m_onPointDown(eventData);
            
            if (ms_globalDownHook != null)
                ms_globalDownHook(eventData);
        }

        if (m_onLuaPointDown != null)
        {
            var eventData = new PointerEventData(EventSystem.current);
            eventData.pointerPress = gameObject;
            eventData.position = position;

            m_onLuaPointDown(m_luaTbl, eventData);

            if (ms_globalDownHook != null)
                ms_globalDownHook(eventData);
        }
    }

    public void ExecuteUp()
    {
        ExecuteUp(Vector2.zero);
    }

    public void ExecuteUp(Vector2 position)
    {
        if (m_onPointUp != null)
        {
            var eventData = new PointerEventData(EventSystem.current);
            eventData.pointerPress = gameObject;
            eventData.position = position;

            m_onPointUp(eventData);

            if (ms_globalUpHook != null)
                ms_globalUpHook(eventData);
        }

        if (m_onLuaPointUp != null)
        {
            var eventData = new PointerEventData(EventSystem.current);
            eventData.pointerPress = gameObject;
            eventData.position = position;

            m_onLuaPointUp(m_luaTbl, eventData);

            if (ms_globalUpHook != null)
                ms_globalUpHook(eventData);
        }
    }

    public void ExecuteHold()
    {
        if (m_onPressHold != null)
        {
            m_onPressHold(this);

            if (ms_globalHoldHook != null)
                ms_globalHoldHook(this);
        }

        if (m_onLuaPressHold != null)
        {
            m_onLuaPressHold(m_luaTbl, this);

            if (ms_globalHoldHook != null)
                ms_globalHoldHook(this);
        }
    }

    public void ExecuteBeginDrag()
    {
        ExecuteBeginDrag(Vector2.zero);
    }

    public void ExecuteBeginDrag(Vector2 position)
    {
        var eventData = new PointerEventData(EventSystem.current);
        eventData.pointerPress = gameObject;
        eventData.pointerDrag = gameObject;
        eventData.position = position;

        OnBeginDrag(eventData);
    }

    public void ExecuteDrag()
    {
        ExecuteDrag(Vector2.zero);
    }

    public void ExecuteDrag(Vector2 position)
    {
        var eventData = new PointerEventData(EventSystem.current);
        eventData.pointerPress = gameObject;
        eventData.pointerDrag = gameObject;
        eventData.position = position;

        OnDrag(eventData);
    }

    public void ExecuteEndDrag()
    {
        ExecuteEndDrag(Vector2.zero);
    }

    public void ExecuteEndDrag(Vector2 position)
    {
        var eventData = new PointerEventData(EventSystem.current);
        eventData.pointerPress = gameObject;
        eventData.pointerDrag = gameObject;
        eventData.position = position;

        OnEndDrag(eventData);
    }

    public void Clear()
    {
        ms_globalClickHook = null;
        ms_globalHoldHook = null;
        ms_globalDownHook = null;
        ms_globalUpHook = null;
        ms_globalDragBeginHook = null;
        ms_globalDragEndHook = null;
        ms_globalStateHook = null;

        m_onClick = null;
        m_onClickEx = null;

        m_onLuaClick = null;
        m_onLuaClickEx = null;

        m_onPressHold = null;
        m_onLuaPressHold = null;

        m_onChangeState = null;
        m_onLuaChangeState = null;

        m_onPointUp = null;
        m_onLuaPointUp = null;

        m_onPointDown = null;
        m_onLuaPointDown = null;

        m_onDragBegin = null;
        m_onLuaDragBegin = null;

        m_onDrag = null;
        m_onLuaDrag = null;

        m_onDragEnd = null;
        m_onLuaDragEnd = null;
    }
    #endregion

    //public virtual void OnPointerEnter(PointerEventData eventData)
    //{

    //}

    //public virtual void OnPointerExit(PointerEventData eventData)
    //{

    //}



    //public virtual void OnDrop(PointerEventData eventData)
    //{

    //}


    //public virtual void OnPointerClick(PointerEventData eventData)
    //{

    //}

    //public virtual void OnSelect(BaseEventData eventData)
    //{

    //}

    //public virtual void OnDeselect(BaseEventData eventData)
    //{

    //}

    //public virtual void OnScroll(PointerEventData eventData)
    //{

    //}

    //public virtual void OnMove(AxisEventData eventData)
    //{

    //}

    //public virtual void OnUpdateSelected(BaseEventData eventData)
    //{

    //}

    //public virtual void OnInitializePotentialDrag(PointerEventData eventData)
    //{

    //}



    //public virtual void OnSubmit(BaseEventData eventData)
    //{

    //}

    //public virtual void OnCancel(BaseEventData eventData)
    //{

    //}
    #endregion



}
