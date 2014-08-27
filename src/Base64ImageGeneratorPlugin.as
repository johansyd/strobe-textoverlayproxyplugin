package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class Base64ImageGeneratorPlugin extends Sprite
	{
		private static var ID:String = 'http://drvideo.aptoma.no/Base64ImageGeneratorPlugin.swf';
		private var _pluginInfo:PluginInfo;
		private var stage:Stage;
		private var text:TextField;
		
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
				console.error(
					'Base64ImageGeneratorPlugin : Could not find property parent for the event.target property '
					+ 'This plugin is only compatible with Strobe 1.6'
				);
				return;
			}
			
			var displayable:DisplayObject = event.target.parent;
			if (!displayable.hasOwnProperty('stage'))
			{
				console.error(
					'Base64ImageGeneratorPlugin : Could not find property stage for the parent property '
					+ 'of the current event target. '
					+ 'This plugin is only compatible with Strobe 1.6'
				);
				return;
			}
			
			this.text = new TextField();
			this.text.text = 'Text';
			this.text.textColor = 0xFFFFFF;
			this.text.mouseEnabled = false;
			this.setText("");
			this.stage = displayable.stage;
			this.stage.addChild(this.text);
			
			ExternalInterface.addCallback('addTextOverlay', addTextOverlay);
		}
		
		public function setText(value:String):void
		{
			this.text.text = value;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = 'Arial';
			textFormat.bold = new Boolean(true);
			textFormat.size = new Number(14);
			this.text.setTextFormat(textFormat);
			this.text.width = this.text.textWidth + 10;
		}
		
		public function addTextOverlay(textValue,x,y):void
		{
			var value:String = textValue as String;
			var xPos:Number = x as Number;
			var yPos:Number = y as Number;
			this.setText(value);
			this.text.x = xPos;
			this.text.y = yPos;
		}

		/*
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