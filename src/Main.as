package 
{
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceErrorEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.mssdk.data.MSSkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Stejskal
	 *  Johnstejskal@gmail.com
	 *  www.johnstejskal.com
	 */
	public class Main extends Sprite 
	{

		private var kinect:Kinect;
		private var cameraBitmap:Bitmap;
		private var skeletonHolder:Sprite;

		
		public function Main():void 
		{
			
			stage.displayState = StageDisplayState.FULL_SCREEN
			
			//check if the kinect is supported
			if (Kinect.isSupported())
			{
				//establish the kinect device
				kinect = Kinect.getDevice();

				//declare bitmap that will hold the camera data
				cameraBitmap = new Bitmap();
				addChild(cameraBitmap);
				
				//Create an empty spite which will hold out joins/bones
				skeletonHolder = new Sprite();
				addChild(skeletonHolder);

				//add a kinect rbg update listener (this fires every time the camera frame updates)
				kinect.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rbg_update, false, 0, true);
				
				//listen to when the kinect is ready
				kinect.addEventListener(DeviceEvent.STARTED, kinectStarted);

				//Core settings, these will determin how the device behaves, what it see's and what it ignores. 
				var settings:KinectSettings = new KinectSettings();
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthShowUserColors = true;
				settings.skeletonEnabled = true;
				kinect.start(settings);
				
				//add the main loop in which the skeleton updates
				addEventListener(Event.ENTER_FRAME, on_enterFrame, false, 0, true);
			}
			else
			{
				trace("device is not supported");
			}
		}
		
		private function on_enterFrame(e:Event):void 
		{
			//clear all dots to make way for new ones
			skeletonHolder.graphics.clear();
			
			//loop through all skeletons in frame, up to 2 with as3Nui.
			for each(var user:User in kinect.usersWithSkeleton)
			{
				skeletonHolder.graphics.beginFill(0x00ccff);

				for each(var joint:MSSkeletonJoint in user.skeletonJoints)
				{
					
					trace("joints :"+joint.name)
					
					//Draw a circle on all the joints
					skeletonHolder.graphics.drawCircle(joint.position.depth.x, joint.position.depth.y, 15 );
				}
				
				//-------------------o
				//Points for tracking
				
			   /*	
			    user.leftHand.position.depth;
				user.rightHand.position.depth;
				
				user.head.position.depth;
				
				user.rightHip.position.depth;
				user.leftHip.position.depth;
				
				user.rightShoulder.position.depth;
				user.leftShoulder.position.depth;
				
				user.leftElbow.position.depth;
				user.rightElbow.position.depth;
				
				user.neck.position.depth;
				*/
				
				//-------------------o
				//Some other useful info
				
				//trace(user.hasSkeleton);
				//trace(user.position.world);
				
			}
		}
		
		//udates the camera feed
		private function rbg_update(event:CameraImageEvent):void {
			cameraBitmap.bitmapData = event.imageData;
		}
		
		private function kinectStarted(e:DeviceEvent):void 
		{
			trace("kinect has started")
			
		}
		
	}
	
}