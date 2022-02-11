package com.coges.visitmanager;

import nbigot.application.view.BaseView;
import nbigot.ui.control.BaseButton;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.MessageDialog;
import nbigot.utils.ImageUtils;
import nbigot.utils.SpriteUtils;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;


class TestView extends BaseView{


    private var image:Bitmap;


    public function new()
    {
        super();
		var i = Assets.getBitmapData( "assets/images/ScreenPanningDO_v2_03.jpg");
		image = new openfl.display.Bitmap( i );
    }


    override private function _draw(ratioH:Float, ratioV:Float):Void 
    {
		addChild( image );
        trace( "umh...");
/*
        _displayWaitPanel();
        _waitPanel.displayMessage( "adf<b>AAA</b>AAARGH §§§§§§§§", new TextFormat(Assets.getFont("assets/fonts/corbel.ttf").fontName, 36));
		*/
		var bt:BaseButton = new BaseButton( "", null, SpriteUtils.createSquare( 200, 30, 0xffffff, true, 0x990000, 4 ));
		bt.setLabel("Bon alorrrrrsss !!!é'", new TextFormat( Assets.getFont("assets/fonts/corbelb.ttf").fontName, 22, 0x009999 ));
		bt.addEventListener( MouseEvent.CLICK, _btClickHandler );
		bt.x = 200;
		bt.y = 200;
		addChild( bt );
		
		
		/*
		var params = Web.getParams();
		for ( p in params )
		{
			trace( p );
		}
		
		var host = url();
		trace( host );
		var uri = Web.getURI();
		trace( uri );
		var uriArr:Array<String> = uri.split("/");
		trace( uriArr );
		uriArr.pop();
		uri = uriArr.join("/") + "/";
		trace( uri );
		var url = host + uri + "vamp_list.txt";
		trace( url );
		*/
		
		/*
		var http = new Http( "vamp_list.txt");
		http.onData = _httpDataHandler;
		http.request(false);
		*/
	}
	/*
	function _httpDataHandler( datas:String ):Void
	{
		var list:Array<Dynamic> = Json.parse( datas );
		
		
		var v:Vamp = null;
		var vi:VampItem = null;
		
		for ( i in 0...list.length )
		{
			v = new Vamp();
			v.num = i;
			v.id = list[i].id;
			v.nom = list[i].nom;
			v.fichier = list[i].fichier;
			v.clan = list[i].clan;
			v.icone = list[i].icone;
			Vamp.list.push( v );
			
			vi = new VampItem(v);
			vi.x = 200;
			vi.y = 40 * i;
			addChild( vi );
			if ( i == 200 ) break;
		}
		trace( Vamp.list );
		
		
    }
	*/
	function _btClickHandler(e:MouseEvent):Void 
	{
		trace( "bt clicked !");
		DialogManager.instance.open( new MessageDialog( "<b>AAA</b>aaaaa", "<b>fjqsldjsdhfjg purp ghujsj'us <i>imgjofdssug</i> sdjgms</b>sdqlf ghjksdfh gskfld hglsf<br>sddfjhds sdflkhgsd fhgsfdj" ) );
	}

    override private function _redraw(ratioH:Float, ratioV:Float):Void 
    {
		ImageUtils.fitIn( image, new openfl.geom.Rectangle( 0,0, stage.stageWidth, stage.stageHeight));
        if ( _waitPanel != null )
        {
            _waitPanel.setRect( new openfl.geom.Rectangle(0,0,stage.stageWidth, stage.stageHeight) );
        }
    }
}