using UnityEngine;

[ExecuteInEditMode]
public class RageLayer : MonoBehaviour {
    public int Zorder;
    public bool ForceRefresh;
    private bool _isOrdered;
    [SerializeField]
    private Material _material;

    public void Update() {
        if (!ForceRefresh) return;
        if (_isOrdered) return;
        SetMaterialRenderQueue();
        _isOrdered = true;
        //ForceRefresh = false;
    }

    /// <summary>Sets the z Order to the value set in the component's Zorder variable </summary>
    public void SetMaterialRenderQueue() {
        ForceRefresh = true;
        if (_material == null)
            _material = new Material(GetComponent<Renderer>().sharedMaterial) { renderQueue = Zorder };
        else
            _material.renderQueue = Zorder;
        GetComponent<Renderer>().sharedMaterial = _material;
    }

    public void OffsetMaterialRenderQueue(int offset) {
        Zorder += offset;
        ForceRefresh = true;
        _material = new Material(GetComponent<Renderer>().material) { renderQueue = Zorder };
        GetComponent<Renderer>().sharedMaterial = _material;
        //_isOrdered = false;
    }

    /// <summary>Sets the z Order to the value assigned to the zOrder parameter </summary>
    public void SetMaterialRenderQueue(int zOrder) {
        GetComponent<Renderer>().sharedMaterial.renderQueue = zOrder;
    }
}
