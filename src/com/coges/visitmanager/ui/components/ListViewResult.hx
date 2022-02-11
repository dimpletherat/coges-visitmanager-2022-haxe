package com.coges.visitmanager.ui.components;

import feathers.controls.ListView;
import feathers.data.ListViewItemState;
import feathers.graphics.FillStyle;
import feathers.skins.RectangleSkin;
import feathers.utils.DisplayObjectRecycler;
import nbigot.ui.list.ScrollItemSelectType;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * ...
 * @author 
 */
class ListViewResult extends ListView 
{
	
	public var selectType(get, null):ScrollItemSelectType;
	var _selectType:ScrollItemSelectType;	
	function get_selectType():ScrollItemSelectType 
	{
		return _selectType;
	}

	public function new() 
	{
		super();	
		
		
		backgroundSkin = new RectangleSkin( FillStyle.None );		
		fixedScrollBars = true;

		var recycler = DisplayObjectRecycler.withFunction(() -> {
			var renderer = new ItemRendererResult();
			renderer.addEventListener( MouseEvent.MOUSE_DOWN, _mouseDownHandler );
			return renderer;
		});
		recycler.update = (itemRenderer:ItemRendererResult, state:ListViewItemState) -> {
			itemRenderer.updateRenderer(state);					
		};
		recycler.reset = (itemRenderer:ItemRendererResult, state:ListViewItemState) -> {
			itemRenderer.resetRenderer(state);
		};
		
		itemRendererRecycler = recycler;
		
	}
	
	function _mouseDownHandler(e:MouseEvent):Void 
	{
		//trace( "VMFeathersListView._mouseDownHandler > e : " + e.target );
		//trace( "VMFeathersListView._mouseDownHandler > e : " + e.currentTarget );
		
		var renderer = cast( e.currentTarget, ItemRendererResult );
		selectedItem = renderer.data;
		_selectType = renderer.selectType;
		e.stopImmediatePropagation();
		
		//trace( "VMFeathersListView._mouseDownHandler > e : " + renderer.selectType );
		dispatchEvent( new Event(Event.SELECT ) );
		
		//TODO: dispatch with bubble
	}
	
}