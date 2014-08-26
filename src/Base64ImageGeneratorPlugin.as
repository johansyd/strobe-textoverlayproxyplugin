package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.media.URLResource;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class Base64ImageGeneratorPlugin extends Sprite
	{
		private static var ID:String = 'http://drvideo.aptoma.no/Base64ImageGeneratorPlugin.swf';
		private var _pluginInfo:PluginInfo;
		private var isPluginReady:Boolean = false;
		private var isPluginReadyCallback:String;
		
		
		public function Base64ImageGeneratorPlugin()
		{
			Security.allowDomain('*');
			super();
			var item:MediaFactoryItem = new MediaFactoryItem(
				ID,
				canHandleResourceCallback,
				mediaElementCreationCallback,
				MediaFactoryItemType.PROXY
			);
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			items.push(item);
			this._pluginInfo = new PluginInfo(items, mediaElementCreationNotificationCallback);
		}
		
		public function get pluginInfo():PluginInfo
		{
			return this._pluginInfo;
		}
		
		private function canHandleResourceCallback(resource:MediaResourceBase):Boolean
		{
			return true;
		}
		
		private function mediaElementCreationCallback():MediaElement
		{
			var mediaElement:MediaElement = new MediaElement();
			return mediaElement;
		}
		
		private function mediaElementCreationNotificationCallback(target:MediaElement):void
		{
			target.addEventListener(MediaElementEvent.TRAIT_ADD, registerForAddedToStageEvent);
		}

		private function registerForAddedToStageEvent(event:MediaElementEvent):void
		{
			var media:MediaElement = event.target as MediaElement;
			var trait:DisplayObjectTrait = media.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
			
			if (trait == null) {
				return;
			}
			
			var displayable:DisplayObject = trait.displayObject;
			displayable.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			event.target.removeEventListener(MediaElementEvent.TRAIT_ADD, registerForAddedToStageEvent);
		}
		
		/**
		 * the event target has to have a parent that has a property named stage
		 */
		private function onAddedToStage(event:Event):void
		{
			if (!event.target.hasOwnProperty('parent'))
			{
				trace(
					'Base64ImageGeneratorPlugin : Could not find property parent for the event.target property '
					+ 'This plugin is only compatible with Strobe 1.6'
				);
				return;
			}
			
			var displayable:DisplayObject = event.target.parent;
			if (!displayable.hasOwnProperty('stage'))
			{
				trace(
					'Base64ImageGeneratorPlugin : Could not find property stage for the parent property '
					+ 'of the current event target. '
					+ 'This plugin is only compatible with Strobe 1.6'
				);
				return;
			}
			
			//ExternalInterface.addCallback('isBase64ImageGeneratorPluginReady', isBase64ImageGeneratorPluginReady);
			//ExternalInterface.addCallback('registerForBase64ImageGeneratorPluginIsReadyEvent', isBase64ImageGeneratorPluginReady);
			//ExternalInterface.addCallback('getBase64EncodedImage', getBase64EncodedImage);
			//Base64ImageGeneratorPlugin.call([this.isPluginReadyCallback, true]);
			/*
			displayable.stage.addEventListener(
				FullScreenEvent.FULL_SCREEN, onFullScreen
			);
			*/
		}
		
		
		
		/*
		public function isBase64ImageGeneratorPluginReady():Boolean
		{
			return this.isPluginReady;
		}
		
		public function registerForBase64ImageGeneratorPluginIsReadyEvent(isPluginReadyCallback:String):void
		{
			this.isPluginReadyCallback = isPluginReadyCallback;
		}
		
		public function getBase64EncodedImage():String
		{
			return 'getBase64EncodedImage';
		}
		
		private static function call(args:Array, async:Boolean = true):void {
			if (async) {
				var asyncTimer:Timer = new Timer(10, 1);
				asyncTimer.addEventListener(TimerEvent.TIMER, 
					function(event:Event):void
					{
						asyncTimer.removeEventListener(TimerEvent.TIMER, arguments.callee);
						ExternalInterface.call.apply(ExternalInterface, args);
					}
				);
				asyncTimer.start();
				return;
			}
			ExternalInterface.call.apply(ExternalInterface, args);
		}
		*/
	}
}