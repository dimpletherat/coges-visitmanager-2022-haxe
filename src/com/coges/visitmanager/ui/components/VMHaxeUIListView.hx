package com.coges.visitmanager.ui.components;

import haxe.ui.components.VerticalScroll;
import haxe.ui.containers.ListView;
import haxe.ui.core.Component;
import haxe.ui.core.ItemRenderer;
import haxe.ui.data.DataSource;
import haxe.ui.data.DataSourceFactory;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author 
 */

 /*
<listview height="350" selectedIndex="1" virtual="true">
</listview>*/
/*@:xml('
<listview>
</listview>
')*/
class VMHaxeUIListView<T> extends Sprite/*ListView */
{
	public function updateDatas( datas:Array<T> ):Void
	{
		_buildDataSource( datas );
	}
	
	function _buildDataSource(datas:Array<T>) 
	{		
        _list.dataSource.allowCallbacks = false; // speeds things up a little		
		var ds = _list.dataSource;
        for (i in 0...datas.length)
		{
			ds.add( datas[i] );
        }
		_list.dataSource = ds;
		_list.dataSource.allowCallbacks = true;
	}
	
	private var _list:ListView;

	public function new( datas:Array<T> = null, rendererClass:Class<ItemRenderer>, virtual:Bool = true, width:Float = 300, height:Float = 300 ) 
	{
		super();
		_list = new ListView();
		_list.itemRendererClass = rendererClass;
		_list.virtual = virtual;
		_list.width = width;
		_list.height = height;
		addChild( _list );
		
		if ( datas != null )
		{
			_buildDataSource( datas );
		}
		
	
		
		
        //registerEvent(MouseEvent.MOUSE_DOWN, _onItemMouseDown2);
        //registerEvent(Event.CHANGE, _onItemMouseDown2);
		addEventListener( Event.CHANGE, _onItemMouseDown2 );
        /*registerEvent(Event.SELECT, _select1);
        addEventListener(Event.SELECT, _select2);*/
	}
	
	function _select1(e:Event):Void 
	{
		trace( "TestListView._select1 > e : " + e );
		
	}
	function _select2(e:Event):Void 
	{
		trace( "TestListView._select2 > e : " + e );
		
	}
	
	
	function _ClickHandler(e:MouseEvent) 
	{
		trace( "TestListView._ClickHandler > e : " + e );
	}
	
	function _changeHandler(e:UIEvent) 
	{
		trace( "TestListView._changeHandler > e : " + e );
	}
	
	function _onItemMouseDown2(e:Event) 
	{
		trace( "TestListView._onItemMouseDown2 > e : " + e );
		//prevent from draging list
		//e.cancel();
		/*
		if ( !Std.isOfType( e._originalEvent.target, TestItemRenderer ) ) return;
		
		var t:TestItemRenderer = cast e._originalEvent.target;
		trace( "TestListView._onItemMouseDown > e : " + t.selectType );
		trace( "TestListView._onItemMouseDown > e : " + t.data );*/
	}
	
	
	override public function set_width( value:Float ):Float
	{
		_list.width = value;
		return value;
	}
	
	override public function set_height( value:Float ):Float
	{
		_list.height = value;
		return value;
	}
}

