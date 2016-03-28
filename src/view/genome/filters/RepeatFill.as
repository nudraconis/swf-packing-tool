package view.genome.filters 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.IContext;
	
	public class RepeatFill extends GFilter 
	{
		
		public function RepeatFill() 
		{
			super();
			
			overrideFragmentShader = true;
			
			
			
			fragmentCode = 
			"mov	ft1				v0													\n"
		+	"mul	ft1.xy			ft1.xy			fc1.xy								\n"
		+	"tex	ft0				ft1				fs0 <2d,linear,repeat,mipnone>		\n" //pixel = texture(texturePos)
		+	"mov	oc				ft1													  "	//return(pixel)
							
				
			fragmentConstants = new <Number>[
												0.9, 0.9, 1, 1
											];
		}
		
		override public function bind(p_context:IContext, p_defaultTexture:GTexture):void 
		{
			fragmentConstants[0] = 4;
			fragmentConstants[1] = 1;
			fragmentConstants[2] = 1;
			fragmentConstants[3] = 1;
			
			super.bind(p_context, p_defaultTexture);
		}
	}
}