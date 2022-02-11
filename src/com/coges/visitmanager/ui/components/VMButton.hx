package com.coges.visitmanager.ui.components;

import nbigot.ui.control.BaseButton;
import nbigot.ui.control.ToolTip;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VMButton extends BaseButton
{
    private var _toolTipContent:Dynamic;
    public var toolTipContent(get, set):Dynamic;
    private function get_toolTipContent():Dynamic
    {
        return _toolTipContent;
    }
    private function set_toolTipContent(value:Dynamic):Dynamic
    {
        _toolTipContent = value;
        return value;
    }
	
	
    override private function set_enabled(value:Bool):Bool
    {
        super.enabled = value;
        alpha = (_isFrozen) ? 0.5:1;
        return value;
    }
	
    
    
    
	public function new( label:String = null, format:TextFormat = null, background:DisplayObject = null, isMultiline:Bool = false)
    {
        super(label, format, background, isMultiline);
        _toolTipContent = null;
    }
    
    override private function _rollOverHandler(e:MouseEvent):Void
    {
		super._rollOverHandler(e);
        if (_toolTipContent != null)
        {
            ToolTip.show(_toolTipContent);
        }
    }
    override private function _rollOutHandler(e:MouseEvent):Void
    {
		super._rollOutHandler(e);
        if (_toolTipContent != null)
        {
            ToolTip.hide();
        }
    }
	
	
	
	
	
	//TODO: keep this ? (this is used, but not very clean )
    public function setTextFormat(value:TextFormat, beginIndex:Int = -1, endIndex:Int = -1, applyBoth:Bool = false):Void
    {
        if (_txtLabel == null)
        {
            return;
        }
		
        _txtLabel.setTextFormat(value, beginIndex, endIndex);
		_txtLabel.text = _label;
        
        //_draw();
    }
    public function getTextFormat(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
    {
        return _txtLabel.getTextFormat(beginIndex, endIndex);
    }
}

