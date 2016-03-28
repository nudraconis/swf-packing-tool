package view.genome.filters 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.IContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class PixelOutline extends GFilter 
	{
		public var size:Number = 0.2;
		public var red:Number = 1;
		public var green:Number = 1;
		public var blue:Number = 1;
		public var alpha:Number = 1;
		
		public function PixelOutline() 
		{
			super();
			
			overrideFragmentShader = true;
			fragmentCode =
								"mov	ft1	v0					\n" //vr buffer
							+	"mov	ft3	v0					\n" //position buffer
								 
							+	"tex	ft0	v0	fs0"				//main texture sample	#removed because need only outline shape
							+	"	<2d,linear,mipnone,clamp>	\n"
								 
							+	"add	ft3.x	ft1.x	fc1.x	\n" //left border position
							+	"tex	ft2		ft3		fs0"		//sample left border texture
							+	"	<2d,linear,mipnone,clamp>	\n"
								
							+	"sub	ft3.x	ft1.x	fc1.x	\n" //right border position
							+	"tex	ft4		ft3		fs0"		//sample right border texture
							+	"	<2d,linear,mipnone,clamp>	\n"
							+	"add	ft2		ft4		ft2		\n" //combine border with main texture
							
							+	"mov 	ft3		ft1 			\n" //reset position register, set x to default value
							
							+	"sub	ft3.y	ft1.y	fc1.y	\n" //up border position
							+	"tex	ft5		ft3		fs0"		//sample up border texture
							+	"	<2d,linear,mipnone,clamp>	\n"
							+	"add	ft2		ft5		ft2		\n" //combine border with main texture
							
							+	"add	ft3.y	ft1.y	fc1.y	\n" //down border position
							+	"tex	ft6		ft3		fs0"		//sample up down texture
							+	"	<2d,linear,mipnone,clamp>	\n"
							+	"add	ft2		ft6		ft2		\n" //combine border with main texture
							
							+	"sat	ft2.w	ft2.w			\n" //Math.max(Math.min(alpha, 1), 0); because wee need alpha tob be <=1
							
							+	"sub	ft2.w	ft2.w	ft0.w	\n" //cut mask and get only border #removed because need only outline shape
							
							+	"mul	ft2.xyz	fc2.xyz	ft2.wwww \n"//colorize
							
							//+	"add	ft0		ft2		ft0	\n" //add outline to result pixel #removed because need only outline shape
							
							+	"mov oc, ft2" 
							
				
			fragmentConstants = new <Number>[
												0, 0, 0, 0, //outline x,y
												0, 0, 0, 0  //color value argb-xyzw
											];
		}
		
		public function setOutline(size:Number = 1, r:Number = 1, g:Number = 1, b:Number = 1, a:Number = 1):void
		{
			this.size = size;
			this.red = r;
			this.green = g;
			this.blue = b;
			this.alpha = a;
		}
		
		override public function bind(p_context:IContext, p_defaultTexture:GTexture):void 
		{
			//Dont forget that genome reserver fc0 so 0-4 registers is fc1
			fragmentConstants[0] = size / p_defaultTexture.gpuWidth;
			fragmentConstants[1] = size / p_defaultTexture.gpuWidth;
			fragmentConstants[2] = 0;
			fragmentConstants[3] = 0;
			
			fragmentConstants[4] = red;
			fragmentConstants[5] = green;
			fragmentConstants[6] = blue;
			fragmentConstants[7] = alpha;
			
			super.bind(p_context, p_defaultTexture);
		}
	}
}