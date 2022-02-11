package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.IDraggerItem;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.SearchResult;
import nbigot.utils.SpriteUtils;
import openfl.display.GradientType;
import openfl.display.IBitmapDrawable;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.DropShadowFilter;
import openfl.geom.Matrix;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchResultDraggerItem extends Sprite implements IDraggerItem
{
    private static final ITEM_WIDTH:Int = 150;
	
	
    public var data(default, null):Dynamic;
    
    private var _txtLabel:TextField;
    
    public function new(data:SearchResult)
    {
        super();
        this.data = data;
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        _txtLabel = drawLabel();
        _txtLabel.text = (data:SearchResult).exhibitorCompanyName;
        _txtLabel.width = ITEM_WIDTH - 4;
        _txtLabel.x = 4;
        _txtLabel.y = 4;
        drawBackground(_txtLabel.height + 8);
        filters = [new DropShadowFilter(2, 90, 0, 0.4, 4, 4, 1, 2)];
    }
    
    private function drawBackground(height:Float):Void
    {
		addChildAt( SpriteUtils.createRoundSquare( ITEM_WIDTH + 10, Std.int(height) + 10, 4, 4, Colors.GREY1, 1, Colors.GREY2 ), 0 );
        /*graphics.clear();
        graphics.lineStyle(1, 0xFFFFFF);
        var m:Matrix = new Matrix();
        m.createGradientBox(ITEM_WIDTH, height, Math.PI / 2);
        graphics.beginGradientFill(GradientType.LINEAR, [0xDCE8EE, 0xAFC2D0], [0.9, 0.9], [0x00, 0xff], m);
        graphics.drawRoundRect(0, 0, ITEM_WIDTH, height, 4, 4);
        graphics.endFill();*/
    }
    
    private function drawLabel():TextField
    {
        var t:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.font = Fonts.OPEN_SANS;
        tf.bold = true;
        tf.color = 0x00;
        tf.size = 12;
        t.selectable = false;
        t.embedFonts = true;
        t.antiAliasType = AntiAliasType.ADVANCED;
        t.autoSize = TextFieldAutoSize.LEFT;
        t.wordWrap = true;
        t.defaultTextFormat = tf;
        addChild(t);
        return t;
    }
}

