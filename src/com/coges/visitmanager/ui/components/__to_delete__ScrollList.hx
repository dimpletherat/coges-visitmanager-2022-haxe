package com.coges.visitmanager.ui.components;

import nbigot.ui.control.Scrollbar;
import nbigot.utils.Collection;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollList extends Sprite
{
    public var datas(get, set):Collection<Dynamic>;
    public var selectedData(get, set):Dynamic;
    public var selectedIndex(get, set):Int;
    public var scrollBar(get, never):Scrollbar;
    public var selectedItem(get, set):IScrollListItem;
    public var scrollPosition(get, set):Float;

    private var _datas:Collection<Dynamic>;
    private function get_datas():Collection<Dynamic>
    {
        return _datas;
    }
    private function set_datas(value:Collection<Dynamic>):Collection<Dynamic>
    {
        if (value == null)
        {
            return value;
        }
        _datas = value;
        update();
        return value;
    }
    
    private var _listContainer:Sprite;
    private var _listMask:Shape;
    private var _labelField:String;
    
    
    private var _selectedData:Dynamic;
    private function get_selectedData():Dynamic
    {
        return _selectedData;
    }
    private function set_selectedData(data:Dynamic):Dynamic
    {
        var i:Int = _listContainer.numChildren;
        var lei:IScrollListItem;
        while (--i >= 0)
        {
            lei = try cast(_listContainer.getChildAt(i), IScrollListItem) catch(e:Dynamic) null;
            if (lei != null && lei.getData() == data)
            {
                _selectedData = data;
                _selectedIndex = lei.getIndex();
                _selectedItem = lei;
                lei.setSelected(true);
                _updatePosition();
            }
        }
        return data;
    }
    
    
    private var _selectedIndex:Int;
    private function get_selectedIndex():Int
    {
        return _selectedIndex;
    }
    private function set_selectedIndex(index:Int):Int
    {
        var i:Int = _listContainer.numChildren;
        var lei:IScrollListItem;
        while (--i >= 0)
        {
            lei = try cast(_listContainer.getChildAt(i), IScrollListItem) catch(e:Dynamic) null;
            if (lei != null && lei.getIndex() == index)
            {
                _selectedIndex = index;
                _selectedData = lei.getData();
                _selectedItem = lei;
                lei.setSelected(true);
                _updatePosition();
            }
        }
        return index;
    }
    
    
    private var _selectedItem:IScrollListItem;
    private var _width:Int;
    private var _height:Int;
    private var _scrollListItemClass:Class<Dynamic>;
    private var _scrollBar:ScrollBar;
    private function get_scrollBar():ScrollBar
    {
        return _scrollBar;
    }
    
    private function get_selectedItem():IScrollListItem
    {
        return _selectedItem;
    }
    private function set_selectedItem(item:IScrollListItem):IScrollListItem
    {
        var i:Int = _listContainer.numChildren;
        var lei:IScrollListItem;
        while (--i >= 0)
        {
            lei = try cast(_listContainer.getChildAt(i), IScrollListItem) catch(e:Dynamic) null;
            if (lei != null && lei == item)
            {
                _selectedIndex = lei.getIndex();
                _selectedData = lei.getData();
                _selectedItem = item;
                lei.setSelected(true);
                _updatePosition();
            }
        }
        return item;
    }
    
    public function new(datas:Collection<Dynamic>, width:Int, height:Int, labelField:String = "label", scrollListItemClass:Class<Dynamic> = null)
    {
        super();
        _scrollListItemClass = ScrollListItem;
        if (scrollListItemClass != null)
        {
            var testObj:Dynamic = Type.createInstance(scrollListItemClass, []);
            if (Std.isOfType(testObj, IScrollListItem))
            {
                _scrollListItemClass = scrollListItemClass;
            }
        }
        
        _height = height;
        _width = width;
        _labelField = labelField;
        _datas = datas;
        
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
        
        _listContainer = new Sprite();
        addChild(_listContainer);
        var i:Int = -1;
        var yPos:Float = 0;
        var lei:DisplayObject;
        var leiPrevious:DisplayObject;
        while (++i < _datas.length)
        {
            lei = _listContainer.addChild(Type.createInstance(_scrollListItemClass, [_datas.getItemAt(i), i, _width, _labelField]));
            lei.y = yPos;
            lei.addEventListener(MouseEvent.MOUSE_DOWN, _clickItemHandler);
            yPos += lei.height - 1;
        }
        
        _listMask = new Shape();
        _listMask.graphics.beginFill(0x00);
        _listMask.graphics.drawRect(0, 0, _width + 1, ((_listContainer.height > _height)) ? _height + 1:_listContainer.height + 1);
        _listMask.graphics.endFill();
        addChild(_listMask);
        _listContainer.mask = _listMask;
        
        if (_listContainer.height > _height)
        {
            _scrollBar = try cast(addChild(new ScrollBar(_listContainer, _listMask.getRect(this))), ScrollBar) catch(e:Dynamic) null;
            _scrollBar.x = _width - (_scrollBar.width);
        }
    }
    
    private function _updatePosition():Void
    {
        var pos:Float = -cast((_selectedItem), DisplayObject).y;
        if (pos < -(_listContainer.height - height))
        {
            pos = -(_listContainer.height - height);
        }
        
        _listContainer.y = pos;
        if (_scrollBar != null)
        {
            _scrollBar.updatePosition();
        }
    }
    
    private function _clickItemHandler(e:MouseEvent = null):Void
    {
        if (_selectedItem != null)
        {
            _selectedItem.setSelected(false);
        }
        
        _selectedItem = try cast(e.target, IScrollListItem) catch(e:Dynamic) null;
        _selectedItem.setSelected(true);
        _selectedData = _selectedItem.getData();
        _selectedIndex = _selectedItem.getIndex();
        dispatchEvent(new Event(Event.SELECT));
    }
    
    override private function get_height():Float
    {
        return _listMask.height;
    }
    public function clear():Void
    {
        _datas.clear();
        update();
    }
    public function update(newDatas:Collection<Dynamic> = null):Void
    {
        if (newDatas != null)
        {
            _datas = newDatas;
        }
        if (_scrollBar != null)
        {
            removeChild(_scrollBar);
        }
        if (_listMask != null)
        {
            removeChild(_listMask);
        }
        if (_listContainer != null)
        {
            removeChild(_listContainer);
        }
        _scrollBar = null;
        _listMask = null;
        _listContainer = null;
        _init(null);
    }
    
    private function get_scrollPosition():Float
    {
        return ((_listContainer != null)) ? _listContainer.y:0;
    }
    private function set_scrollPosition(value:Float):Float
    {
        if (_listContainer == null)
        {
            return value;
        }
        if (value < _listMask.height - _listContainer.height)
        {
            value = _listMask.height - _listContainer.height;
        }
        _listContainer.y = value;
        if (_scrollBar != null)
        {
            _scrollBar.updatePosition();
        }
        return value;
    }
}

