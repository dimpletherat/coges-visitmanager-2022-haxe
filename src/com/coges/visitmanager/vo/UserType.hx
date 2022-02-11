package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract UserType(String) from String to String
{
	var OZ = "oz";
	var PROGRAMMEUR = "prog";
	var ATTACHE_DEFENSE = "att_def";
	var MEMBRE_BUREAU = "mem_bur";
}