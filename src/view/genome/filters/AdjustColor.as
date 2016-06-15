package view.genome.filters 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.IGContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class AdjustColor extends GFilter 
	{
		public static var brightness:Number = 1// + 1/-2
		public static var contrast:Number = 1 //+ 1/13;
		public static var saturation:Number = 1 //+ 1/20;
		
		public function AdjustColor() 
		{
			super();
			
			overrideFragmentShader = true;
			fragmentCode =
								"tex	ft0			v0			fs0			\n"		//main texture sample	#removed because need only outline shape
							+	"	<2d,linear,mipnone,clamp>				\n"
							
							//+	"div	ft0.xyz		ft0.xyz		ft0.www		\n"

							
							+	"mul	ft0.xyz		ft0.xyz		fc1.xxx		\n" //ft0 - brtColor
							+	"dp3	ft1.xyz		ft0.xyz		fc1.xyz		\n"	//ft1 - intensity
							
							//intensity * (1-saturation) + brtColor * saturation
							+	"mov	ft4.xyz		fc3.xxx					\n"	//1 - saturation
							+	"mul	ft1.xyz		ft1.xyz		ft4.xyz		\n"	//intensity * (1 - saturation)
							+	"mul	ft0.xyz		ft0.xyz		fc1.zzz		\n"	//brtColor * saturation;
							+	"add	ft0.xyz		ft1.xyz		ft0.xyz		\n"	//intensity * (1 - saturation) + brtColor * saturation;
							
							//AvgLum * (1 - contrast) + satColor * contrast;
							//ft0 - satColor
							//fc1.www - AvgLum
							//fc1.y - contrast
							+	"mov	ft4.xyz		fc3.yyy					\n"	//1 - contrast
							+	"mul	ft4.xyz		fc1.www		ft4.xyz		\n"	//AvgLum * (1 - contrast)
							+	"mul	ft0.xyz		ft0.xyz		fc1.yyy		\n"	//satColor * contrast;
							+	"add	ft0.xyz		ft4.xyz		ft0.xyz		\n"	//AvgLum * (1 - satColor) + brtColor * contrast;
							
							
							//+	"mul	ft0.xyz		ft0.xyz		ft0.www		\n"
							//+	"sub	ft0.xyz		ft0.xyz		fc1.xxx		\n"
							//+	"mul	ft0.xyz		ft0.xyz		fc1.yyy		\n"
							//+	"sat	ft0			ft0						\n"
							+	"mov	oc			ft0";
							
				
			fragmentConstants = new <Number>[
												0, 0, 0, 0, //outline x,y
												0, 0, 0, 0,  //color value argb-xyzw
												0, 0, 0, 0  //color value argb-xyzw
											];
		}
		
	
		override public function bind(p_context:IGContext, p_defaultTexture:GTexture):void 
		{
			//Dont forget that genome reserver fc0 so 0-4 registers is fc1
			fragmentConstants[0] = brightness;
			fragmentConstants[1] = contrast;
			fragmentConstants[2] = saturation;
			fragmentConstants[3] = 0.5;
			
			fragmentConstants[4] = 0.2125;
			fragmentConstants[5] = 0.7154;
			fragmentConstants[6] = 0.0721;
			fragmentConstants[7] = 1;
			
			fragmentConstants[8] = 1-saturation;
			fragmentConstants[9] = 1-contrast;
			fragmentConstants[10] = 1;
			fragmentConstants[11] = 1;
			
			super.bind(p_context, p_defaultTexture);
		}
	}
}