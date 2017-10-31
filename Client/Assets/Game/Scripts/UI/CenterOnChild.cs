using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class CenterOnChild : MonoBehaviour, IEndDragHandler, IDragHandler
{
    //将子物体拉到中心位置时的速度
    public float centerSpeed = 9f;

    //注册该事件获取当拖动结束时位于中心位置的子物体
    public delegate void OnCenterHandler(GameObject centerChild);
    public event OnCenterHandler onCenter;

    private ScrollRect _scrollView;
    private Transform _container;

    private List<float> _childrenPos = new List<float>();
    private float _targetPos;
    private bool _centering = false;

    //public Transform dianParent;
    //private List<GameObject> dianList = new List<GameObject>();
    private int m_childIndex = 0;

    void Awake()
    {
        RefreshState();
    }

    void Update()
    {
        if (_centering)
        {
            Vector3 v = _container.localPosition;
            v.x = Mathf.Lerp(_container.localPosition.x, _targetPos, centerSpeed * Time.deltaTime);
            _container.localPosition = v;
            if (Mathf.Abs(_container.localPosition.x - _targetPos) < 0.01f)
            {
                _centering = false;
            }
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        _centering = true;
        _targetPos = FindClosestPos(_container.localPosition.x);

    }

    public void OnDrag(PointerEventData eventData)
    {
        _centering = false;
    }

    private float FindClosestPos(float currentPos)
    {
        int childIndex = 0;
        float closest = 0;
        float distance = Mathf.Infinity;

        for (int i = 0; i < _childrenPos.Count; i++)
        {
            float p = _childrenPos[i];
            float d = Mathf.Abs(p - currentPos);
            if (d < distance)
            {
                distance = d;
                closest = p;
                childIndex = i;
            }
        }


        GameObject centerChild = _container.GetChild(childIndex).gameObject;

        // Debug.Log("    需要居中的   idndex  :   "+childIndex);

        //下方点点设置
        // UINotice._instance.SetDianGrid(childIndex);
        // SetDian(childIndex);
        m_childIndex = childIndex;

        if (onCenter != null)
            onCenter(centerChild);
        return closest;
    }


    public int GetCenterChildIndex()
    {
        return m_childIndex;
    }

    ////设置点
    //private void SetDian(int index)
    //{
    //    if (dianParent)
    //    {
    //        for (int i = 0; i < dianParent.childCount; i++)
    //        {
    //            if (i == index)
    //            {
    //                dianParent.GetChild(i).GetChild(1).gameObject.SetActive(true);
    //            }
    //            else
    //            {
    //                dianParent.GetChild(i).GetChild(1).gameObject.SetActive(false);
    //            }
    //        }
    //    }
    //}

    public void RefreshState()
    {
        // Debug.Log("RefreshState  ---------  ");
        _childrenPos.Clear();
        _scrollView = GetComponent<ScrollRect>();
        if (_scrollView == null)
        {
            Debug.LogError("CenterOnChild: No ScrollRect");
            return;
        }
        _container = _scrollView.content;

        GridLayoutGroup grid;
        grid = _container.GetComponent<GridLayoutGroup>();
        if (grid == null)
        {
            Debug.LogError("CenterOnChild: No GridLayoutGroup on the ScrollRect's content");
            return;
        }

        _scrollView.movementType = ScrollRect.MovementType.Unrestricted;

        //计算第一个子物体位于中心时的位置
        float childPosX = _scrollView.GetComponent<RectTransform>().rect.width * 0.5f - grid.cellSize.x * 0.5f;
        _childrenPos.Add(childPosX);
        //缓存所有子物体位于中心时的位置
        for (int i = 0; i < _container.childCount - 1; i++)
        {
            childPosX -= grid.cellSize.x + grid.spacing.x;
            _childrenPos.Add(childPosX);
        }
    }
}
