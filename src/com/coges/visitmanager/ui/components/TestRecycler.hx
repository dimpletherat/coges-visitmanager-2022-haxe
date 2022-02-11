package com.coges.visitmanager.ui.components;

import feathers.data.ListViewItemState;
import feathers.utils.DisplayObjectRecycler;
import openfl.display.DisplayObject;

/**
 * ...
 * @author 
 */
class TestRecycler extends DisplayObjectRecycler<ItemRendererResult,ListViewItemState,DisplayObject>
{

	public function new() 
	{
		super();
		
	}
	
	override public dynamic function update(target:ItemRendererResult, state:ListViewItemState):Void 
	{
		target.updateRenderer( /**null, */state );
	};

	/**
		Prepares a display object to be used again. This method should restore
		the display object to its original state from when it was returned by
		`create()`.

		@since 1.0.0
	**/
	override public dynamic function reset(target:ItemRendererResult, state:ListViewItemState):Void 
	{
		target.resetRenderer(/* target, */state );
	}

	/**
		Creates a new display object.

		@since 1.0.0
	**/
	override public dynamic function create():ItemRendererResult {
		return new ItemRendererResult();
	}

	/**
		Destroys/disposes a display object when it will no longer be used.

		@since 1.0.0
	**/
	override public dynamic function destroy(target:ItemRendererResult):Void {}
}