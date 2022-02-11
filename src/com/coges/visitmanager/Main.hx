package com.coges.visitmanager;


import com.coges.visitmanager.core.Locale;
import feathers.controls.Application;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.TextArea;
import feathers.graphics.FillStyle;
import feathers.graphics.LineStyle;
import feathers.layout.AnchorLayoutData;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalLayout;
import feathers.layout.VerticalLayoutData;
import feathers.skins.RectangleSkin;
import nbigot.application.AssetFile;
import nbigot.application.Controler;
import nbigot.application.ResizeManager;
import nbigot.application.view.ViewContainer;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import nbigot.utils.ColorUtils;
import nbigot.utils.SpriteUtils;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.TextEvent;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;


class Main extends Application {
	
	
	public function new () {
		
		super ();
		/*
		var i = Assets.getBitmapData( "assets/images/ScreenPanningDO_v2_03.jpg");
		var b = new openfl.display.Bitmap( i );

		ImageUtils.fitIn( b, new openfl.geom.Rectangle( 0,0, stage.stageWidth, stage.stageHeight));
		addChild( b );
        trace( "umh...");*/
		
		

		addEventListener( openfl.events.Event.ADDED_TO_STAGE, _addedToStageHandler );
	}
	
	private function _addedToStageHandler( e:Event ):Void
	{
		ResizeManager.initialize( stage, stage.stageWidth, stage.stageHeight );
		trace( stage.stageWidth, stage.stageHeight );
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		
		var xml:Xml = Xml.parse( Assets.getText("assets/content/vm_content.xml") );
		Locale.init	(xml, Locale.EN);
		
		var tf:TextFormat = new TextFormat( Assets.getFont("assets/fonts/OpenSans-Regular.ttf").fontName, 14, 0x000000 );
		var ds:DialogSkin = new DialogSkin();
		ds.closeButtonFormat = tf;
		ds.closeButtonLabel = "Fermer";
		
		ds.titleFormat = tf;
		ds.contentFormat = tf;
		DialogManager.initialize( stage, ds );


		//DialogManager.instance.open( VMMessageDialog, "umh...é'-");
		
		
		layout = new VerticalLayout();
		backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0xcccccc, 1), LineStyle.SolidColor( 2, 0, 1));
		
		//backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0xcccccc, 2), LineStyle.SolidColor( 1, 0, 1));
		
		var lg1 = new LayoutGroup();
		var ld1 = new VerticalLayoutData();
		ld1.percentWidth = 100.0;
		lg1.layoutData = ld1;
		
		
		lg1.layout = new HorizontalLayout();
		/*var ld1 = new VerticalLayoutData();
		ld1.percentWidth = 100.0;
		ld1.percentHeight = 10.0;
		lg1.layoutData = ld1;*/
		lg1.backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0xccccdd, 2), LineStyle.SolidColor( 1, 0, 1));
		addChild(lg1);
		var b1_1 = new Button();
		var ldb1_1 = new HorizontalLayoutData();
		ldb1_1.percentWidth = 50.0;
		b1_1.layoutData = ldb1_1;	
		b1_1.height = 40;
		lg1.addChild( b1_1);
		var b1_2 = new Button();
		var ldb1_2 = new HorizontalLayoutData();
		ldb1_2.percentWidth = 50.0;
		b1_2.layoutData = ldb1_2;	
		b1_2.height = 40;
		lg1.addChild( b1_2);
		
		
		
		
		
		var lg2 = new LayoutGroup();
		var ld2 = new VerticalLayoutData();
		ld2.percentWidth = 100.0;
		ld2.percentHeight = 100.0;
		lg2.layoutData = ld2;
		lg2.backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0xccddcc, 2), LineStyle.SolidColor( 1, 0, 1));
		addChild(lg2);
		
		
		
		
		/*
		var lg1 = new LayoutGroup();
		lg1.backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0x00ddcc, 1), LineStyle.SolidColor( 2, 0, 1));
		var ld1 = new VerticalLayoutData();
		ld1.percentHeight = 100.0;
		ld1.percentWidth = 30.0;
		lg1.layoutData = ld1;
		addChild(lg1);
		
		
		var lg2 = new LayoutGroup();
		lg2.backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0x00ccdd, 1), LineStyle.SolidColor( 2, 0, 1));
		var ld2 = new VerticalLayoutData();
		ld2.percentHeight = 100.0;
		ld2.percentWidth = 50.0;
		lg2.layoutData = ld2;*/
		/*
		var f:Font = Assets.getFont("assets/fonts/LondonBetween.ttf");
		var t = new TextField();
		t.addEventListener( TextEvent.LINK, _textEventHandler );
		t.defaultTextFormat = new TextFormat( f.fontName, 42 );
		t.embedFonts = true;
        t.antiAliasType = AntiAliasType.ADVANCED;
		t.htmlText = "<a href=\"event:some-arg\">link</a> text";
		t.x = 100;
		t.y = 100;
		t.width = 300;
		//lg2.addChild(t);
		
		var l1:Label = new Label();
		l1.textFormat = tf;
		l1.wordWrap = true;
		l1.htmlText = Locale.get("ALERT_VISIT_IS_SERIE", Locale.FR );
		l1.x = 22;
		l1.y = 200;
		//lg2.addChild(l1);
		
		var l2:nbigot.ui.control.Label = new nbigot.ui.control.Label(null,tf, "left", true);
		l2.setText(Locale.get("ALERT_VISIT_IS_SERIE", Locale.EN ), tf);
		l2.x = 22;
		l2.y = 350;
		//lg2.addChild(l2);*/
		/*addChild(lg2);
		
		var lg3 = new LayoutGroup();
		lg3.backgroundSkin = new RectangleSkin( FillStyle.SolidColor( 0xcc00cc, 1), LineStyle.SolidColor( 2, 0, 1));
		var ld3 = new VerticalLayoutData();
		ld3.percentHeight = 100.0;
		ld3.percentWidth = 20.0;
		lg3.layoutData = ld3;
		addChild(lg3);*/
		
		
		
		
		
	}
	
	function _textEventHandler(e:TextEvent):Void 
	{
		trace( "HEY :!!!!" + e.text );
	}
}