package com.plode.utils 
{

	/**
	 * @author ns
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;	

	/**
	 * @author ns
	 */
	public final class AssetCache extends EventDispatcher
	{
		/**
		 * Stores the singleton's instance.
		 * @type AssetCache
		 */
		private static var INSTANCE : AssetCache;
		private var _loaderArray : Array;
		private var _d : Dictionary;

		public function AssetCache( se : SingletonEnforcerer ) 
		{
			if( se != null ){
			}
		}

		public static function get gi() : AssetCache 
		{
			if( INSTANCE == null )
			{
				INSTANCE = new AssetCache( new SingletonEnforcerer( ) );
			}
			return INSTANCE;
		}

		public function addBmp(bmpd : BitmapData, id : String) : void
		{
			if(!_loaderArray)
			{
				_loaderArray = new Array( );
				_d = new Dictionary( );
			}

			var bmp : Bitmap = new Bitmap();
			bmp.bitmapData = bmpd;
			_d[id] = bmp;
		}

		public function loadImage(path : String, id : String) : void
		{
			if(!_loaderArray)
			{
				_loaderArray = new Array( );
				_d = new Dictionary( );
			}

			// CHECK ITEMS AGAINST ALREADY LOADED
			if(!_d[id])
			{
				var imageLoader : Loader = new Loader( );
				imageLoader.load( new URLRequest( path ) );
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, imageLoaded );
				
				_loaderArray.push( imageLoader );
				_d[id] = imageLoader;
			}
		}

		protected function imageLoaded(e : Event) : void 
		{
			var loaderInfo : LoaderInfo = e.currentTarget as LoaderInfo;
			var ind : int;
			for each(var loader : Loader in _loaderArray)
			{
				if(loader.contentLoaderInfo == loaderInfo)
				{
					ind = _loaderArray.indexOf(loader);
					_loaderArray.splice(ind, 1);
					loader = null;
				}
			}

			if (_loaderArray.length == 0) dispatchEvent(new Event( Event.COMPLETE ) );
		}


		
		
		
		//----------------------------------------------------------------------
		//
		// GETTERS & SETTERS
		//
		//----------------------------------------------------------------------

		public function getImg(key : String) : Bitmap
		{
			return BitmapConverter.getBmp(_d[key] );
		}
		
		public function removeBmp(arg0 : String) : void
		{
			delete _d[arg0];
		}
		
	}
}

/**
 * The SingletonEnforcerer class is located outside the package to block external access.
 */
class SingletonEnforcerer 
{
}