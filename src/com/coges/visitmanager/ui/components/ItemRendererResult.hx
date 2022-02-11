package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.SearchResult;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.dataRenderers.LayoutGroupItemRenderer;
import feathers.data.ListViewItemState;
import feathers.graphics.FillStyle;
import feathers.layout.HorizontalAlign;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.skins.RectangleSkin;
import nbigot.ui.list.ScrollItemSelectType;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;

/**
 * ...
 * @author 
 */
//TODO: complete with good names, datas, add triangles etc (see comments at the end of file)
class ItemRendererResult extends LayoutGroupItemRenderer 
{	
	public var selectType(get, null):ScrollItemSelectType;
	var _selectType:ScrollItemSelectType;	
	function get_selectType():ScrollItemSelectType 
	{
		return _selectType;
	}
	
	
	var _lblExhibitor:Label;
	var _lblDemand:Label;
	var _iconFlag:AssetLoader;
	var _iconLocalization:AssetLoader;
	var _iconTriangles:AssetLoader;
	var _line:Sprite;
	
	public function new() 
	{
		super();
		
		/*
		-------------
		|           |
		|           |
		|           |
		|           |
		|           |
		|           |
		|           |
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		var vl = new VerticalLayout();
		vl.paddingTop = 4.0;
		vl.paddingBottom = 0.0;
		vl.paddingLeft = 6.0;
		vl.paddingRight = 6.0;
		layout = vl;
		/*var vld:VerticalLayoutData = new VerticalLayoutData();
		layoutData = vld;*/
		
		/*
		-------------
		|-----------|
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		var hlg = new LayoutGroup();
		var hl = new HorizontalLayout();
		hl.horizontalAlign = HorizontalAlign.LEFT;
		hl.gap = 6;
		hlg.layout = hl;
		addChild( hlg );
		
		/*
		-------------
		|-----------|
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|-----------|
		-------------
		|     X     |
		-------------
		|           |
		-------------
		*/
		var spacer = SpriteUtils.createSquare( 50, 20, Colors.RED1 );
		spacer.alpha = 0;
		addChild( spacer );
		
		/*
		-------------
		|-----------|
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|| |   | | ||
		|-----------|
		-------------
		|           |
		-------------
		|     X     |
		-------------
		*/
		_line = SpriteUtils.createSquare( 50, 2, Colors.GREY2 );
		addChild( _line );
		
		/*
		-------------
		|-----------|
		|| |   | | ||
		|| |   | | ||
		||X|   | | ||
		|| |   | | ||
		|| |   | | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		_iconFlag = new AssetLoader();
		_iconFlag.minWidth = 22;
		hlg.addChild( _iconFlag );			
		
		/*
		-------------
		|-----------|
		|| |---| | ||
		|| || || | ||
		|| |---| | ||
		|| || || | ||
		|| |---| | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		var vlg:LayoutGroup = new LayoutGroup();
		vlg.layout = new VerticalLayout();
		hlg.addChild( vlg );
		
		/*
		-------------
		|-----------|
		|| |---| | ||
		|| || || | ||
		|| |---|X| ||
		|| || || | ||
		|| |---| | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		/*
		_iconLocalization = new AssetLoader();
		_iconLocalization.minWidth = 20;
		hlg.addChild( _iconLocalization );
		*/
		
		/*
		-------------
		|-----------|
		|| |---| | ||
		|| || || | ||
		|| |---| |X||
		|| || || | ||
		|| |---| | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		_iconTriangles = new AssetLoader();
		_iconTriangles.minWidth = 22;
		_iconTriangles.maxWidth = 22;
		hlg.addChild( _iconTriangles );
		
		/*
		-------------
		|-----------|
		|| |---| | ||
		|| ||X|| | ||
		|| |---| | ||
		|| || || | ||
		|| |---| | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		_lblExhibitor = new Label();
		_lblExhibitor.textFormat = new TextFormat( Fonts.OPEN_SANS, 13, 0, true );
		//_label.width = 150.0;
		_lblExhibitor.wordWrap = true;
		//_lblExhibitor.backgroundSkin = new RectangleSkin( FillStyle.SolidColor(0x005846) );
		/*var ldLabel = new HorizontalLayoutData();
		ldLabel.percentWidth = 60;
		_label.layoutData = ldLabel;*/
		vlg.addChild(_lblExhibitor);
		
		/*
		-------------
		|-----------|
		|| |---| | ||
		|| || || | ||
		|| |---| | ||
		|| ||X|| | ||
		|| |---| | ||
		|-----------|
		-------------
		|           |
		-------------
		|           |
		-------------
		*/
		_lblDemand = new Label();
		//_lblDemand.backgroundSkin = new RectangleSkin( FillStyle.SolidColor(0x476400) );
		/*var ldDemand = new HorizontalLayoutData();
		ldDemand.percentWidth = 60;
		_label.layoutData = ldDemand;*/
		_lblDemand.textFormat = new TextFormat( Fonts.OPEN_SANS, 11 );
		//_label.width = 150.0;
		_lblDemand.wordWrap = true;
		
		vlg.addChild(_lblDemand);
		
		
		
		
		backgroundSkin = new RectangleSkin( FillStyle.SolidColor( Colors.GREY1 ) );
		selectedBackgroundSkin = new RectangleSkin( FillStyle.SolidColor( Colors.GREY2 ) );
		
		addEventListener( MouseEvent.MOUSE_DOWN, _mouseDownHandler );
		addEventListener( MouseEvent.ROLL_OVER, _mouseOverHandler );
		addEventListener( MouseEvent.ROLL_OUT, _mouseOutHandler );
	}
		
	public function updateRenderer(state:ListViewItemState):Void
	{
		var sr:SearchResult = cast state.data;
		
		var l:VerticalLayout = cast( layout, VerticalLayout);
		var lineWidth:Float = state.owner.width - l.paddingLeft - l.paddingRight;
		var labelWidth:Float = lineWidth - 22 - 6 - 6 - 22 - 12;// flag with - gap - gap - triangle width - scrollbar;
		
		_lblExhibitor.text =  sr.exhibitorCompanyName;
		_lblExhibitor.width = labelWidth;
		
		if (sr.idExhibitor > 0)
		{
			if ( sr.exhibitorCountry != null )
			{
				// TODO : use the 'source' property of the AssetLoader ?
				// or get rid of it and prefer a direct addchild of the flag?
				var iconCountry:DisplayObject = sr.exhibitorCountry.flag16;
				if (iconCountry != null)
				{
					_iconFlag.addChild(iconCountry);
				}
			}
		
			var demandText:String = "";
			if (sr.idDemand != 0)
			{
				demandText += sr.demandPriority + " | ";
				if ( sr.demandSlotDay != null )
				{
					demandText += sr.demandSlotDay.label + " ";
				}
				if ( sr.demandSlotDuration != null )
				{
					demandText += sr.demandSlotDuration.label + " | ";
				}
			}	
			demandText += sr.exhibitorWelcomeStand;
			
			_lblDemand.text =  demandText;
			
			/*
			// TODO : use the 'source' property of the AssetLoader ?
			// or get rid of it and prefer a direct addchild of the flag?
			_iconLocalization.addChild(Icons.getIcon( Icon.LOCALIZATION_20 ));
			*/
			if (sr.urlTrianglesIcon.length > 0)
			{
				_iconTriangles.buttonMode = true;
				_iconTriangles.mouseChildren = false;
				//if ( Config.isOnline )
					_iconTriangles.source = Config.trianglesFolderURL + sr.urlTrianglesIcon;
				//else
				//	_iconTriangles.source = "assets/icons/" + Icon.TMP_TRIANGLE_1;// _iconTriangles.addChild( Icons.getIcon( Icon.TMP_TRIANGLE_1 ) );
			}
		}else{
			//THIS IS A 'NO RESULT' ITEM
			mouseChildren = false;
			mouseEnabled = false;
		}
		_lblDemand.width = labelWidth;
		
		
		_line.width = lineWidth;
	}
		
	public function resetRenderer(state:ListViewItemState):Void
	{
		mouseChildren = true;
		mouseEnabled = true;
		_lblExhibitor.text =  "";
		_lblDemand.text =  "";
		_iconFlag.source = null;
		while ( _iconFlag.numChildren > 0 )
		{
			_iconFlag.removeChildAt(0);
		}
		//_iconLocalization.source = null;
		_iconTriangles.source = null;
	}
	
	
	// Because of the rollover/out mechanique 
	override private function set_selected(value:Bool):Bool
	{
		if (!value)
			backgroundSkin = new RectangleSkin( FillStyle.SolidColor( Colors.GREY1 ) );
		return super.set_selected(value);
	}
	function _mouseOverHandler(e:MouseEvent):Void 
	{
		if (!selected)
			backgroundSkin = new RectangleSkin( FillStyle.SolidColor( Colors.GREY2 ) );
	}	
	function _mouseOutHandler(e:MouseEvent):Void 
	{
		if (!selected)
			backgroundSkin = new RectangleSkin( FillStyle.SolidColor( Colors.GREY1 ) );
	}
	
	
	function _mouseDownHandler(e:MouseEvent):Void 
	{		
        if (e.target == _iconLocalization)
        {
            _selectType = ScrollItemSelectType.VIEW;
            return;
        }
        if (e.target == _iconTriangles)
        {
            _selectType = ScrollItemSelectType.VALIDATE;
            return;
        }
        _selectType = ScrollItemSelectType.SELECT;
	}
}