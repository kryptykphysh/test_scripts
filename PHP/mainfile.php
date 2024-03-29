<?php
// $Id: mainfile.dist.php,v 1.7.6.3 2005/05/21 15:38:20 mithyt2 Exp $
//  ------------------------------------------------------------------------ //
//                XOOPS - PHP Content Management System                      //
//                    Copyright (c) 2000 XOOPS.org                           //
//                       <http://www.xoops.org/>                             //
//  ------------------------------------------------------------------------ //
//  This program is free software; you can redistribute it and/or modify     //
//  it under the terms of the GNU General Public License as published by     //
//  the Free Software Foundation; either version 2 of the License, or        //
//  (at your option) any later version.                                      //
//                                                                           //
//  You may not change or alter any portion of this comment or credits       //
//  of supporting developers from this source code or any supporting         //
//  source code which is considered copyrighted (c) material of the          //
//  original comment or credit authors.                                      //
//                                                                           //
//  This program is distributed in the hope that it will be useful,          //
//  but WITHOUT ANY WARRANTY; without even the implied warranty of           //
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            //
//  GNU General Public License for more details.                             //
//                                                                           //
//  You should have received a copy of the GNU General Public License        //
//  along with this program; if not, write to the Free Software              //
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA //
//  ------------------------------------------------------------------------ //

if ( !defined("XOOPS_MAINFILE_INCLUDED") ) {
	define("XOOPS_MAINFILE_INCLUDED",1);

	// XOOPS Physical Path
	// Physical path to your main XOOPS directory WITHOUT trailing slash
	// Example: define('XOOPS_ROOT_PATH', '/home/pedigree/domains/animalpedigree.com/public_html/afghanhound');
	//define('XOOPS_ROOT_PATH', '/home/fhlinux160/a/ahpedigrees.com/user/htdocs');
	//define('XOOPS_ROOT_PATH', '/home/fhlinux-script/a/ahpedigrees.com/user/htdocs');
	define('XOOPS_ROOT_PATH', '/home/default/ahpedigrees.com/user/htdocs');
	// XOOPS Virtual Path (URL)
	// Virtual path to your main XOOPS directory WITHOUT trailing slash
	// Example: define('XOOPS_URL', 'http://www.afghanhound.animalpedigree.com');
	define('XOOPS_URL', 'http://www.ahpedigrees.com');

	define('XOOPS_CHECK_PATH', '1');
	// Protect against external scripts execution if safe mode is not enabled
	if ( XOOPS_CHECK_PATH && !@ini_get('safe_mode') ) {
		if ( function_exists('debug_backtrace') ) {
			$xoopsScriptPath = debug_backtrace();
			if ( !count($xoopsScriptPath) ) {
			 	die("XOOPS path check: this file cannot be requested directly");
			}
			$xoopsScriptPath = $xoopsScriptPath[0]['file'];
		} else {
			$xoopsScriptPath = isset($_SERVER['PATH_TRANSLATED']) ? $_SERVER['PATH_TRANSLATED'] :  $_SERVER['SCRIPT_FILENAME'];
		}
		if ( DIRECTORY_SEPARATOR != '/' ) {
			// IIS6 may double the \ chars
			$xoopsScriptPath = str_replace( strpos( $xoopsScriptPath, '\\\\', 2 ) ? '\\\\' : DIRECTORY_SEPARATOR, '/', $xoopsScriptPath);
		}
		if ( strcasecmp( substr($xoopsScriptPath, 0, strlen(XOOPS_ROOT_PATH)), str_replace( DIRECTORY_SEPARATOR, '/', XOOPS_ROOT_PATH)) ) {
		 	exit("XOOPS path check: Script is not inside XOOPS_ROOT_PATH and cannot run.");
		}
	}

	// Database
	// Choose the database to be used
	define('XOOPS_DB_TYPE', 'mysql');

	// Table Prefix
	// This prefix will be added to all new tables created to avoid name conflict in the database. Please change this to something different than 'xoops'.
	define('XOOPS_DB_PREFIX', 'draaf');

	// Database Hostname
	// Hostname of the database server. If you are unsure, 'localhost' works in most cases.
	define('XOOPS_DB_HOST', '213.171.219.99');

	// Database Username
	// Your database user account on the host
	define('XOOPS_DB_USER', 'adminafghan');

	// Database Password
	// Password for your database user account
	define('XOOPS_DB_PASS', 'webcam');

	// Database Name
	// The name of database on the host. The installer will attempt to create the database if not exist
	define('XOOPS_DB_NAME', 'adminafghan');

	// Use persistent connection? (Yes=1 No=0)
	// Default is 'No'. Choose 'No' if you are unsure.
	define('XOOPS_DB_PCONNECT', '0');

	define('XOOPS_GROUP_ADMIN', '1');
	define('XOOPS_GROUP_USERS', '2');
	define('XOOPS_GROUP_ANONYMOUS', '3');

	if (!isset($xoopsOption['nocommon']) && XOOPS_ROOT_PATH != '') {
		require XOOPS_ROOT_PATH."/include/common.php";
	}
}
?>