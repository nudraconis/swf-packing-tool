package view.genome.filters 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.IContext;
	
	public class GrassWind extends GFilter 
	{
		private var _grassFactor:Number = 0;
		
		public function GrassWind() 
		{
			super();
			
			overrideFragmentShader = true;
			
			
			
			fragmentCode = 
			"mov	ft4				v0													\n"	//ft2 = sub UV
		+	"sub 	ft4.xy			ft4.xy			fc5.xy								\n" //sub UV -> self UV part
		+	"div	ft4.zw			ft4.zw			fc5.zw								\n" //self UV part -> self UV normal
			
		+	"sub	ft3				ft4.y			fc1.y								\n"	//offset = 1-y
		+	"pow	ft3				ft3				fc2									\n"	//offset = offset^3
		+	"mul	ft3				ft3.y			fc3									\n"	//offset = sin(count)*offset
		+	"mul	ft3.xyzw		ft3.xyzw		fc4.xxxx							\n"	//offset *= .3
		+	"add	ft2				v0				ft3									\n"	//texturePos.x += offset
		+	"tex	ft1				ft2				fs0 <2d,linear,clamp,mipnone>		\n" //pixel = texture(texturePos)
		+	"mov	oc				ft1													  "	//return(pixel)
							
				
			fragmentConstants = new <Number>[
												0, 0, 0, 0,  //
												0, 0, 0, 0,  //
												0, 0, 0, 0,  //
												0, 0, 0, 0,  //
												0, 0, 0, 0   //
											];
		}
		
		
		public function advanceGrassFactor():void
		{
			_grassFactor = (_grassFactor + .05) % (Math.PI * 10);
		}
		
		override public function bind(p_context:IContext, p_defaultTexture:GTexture):void 
		{
			//TODO: можно уменьшить константы т.к ну нужны регистры типа 1, 1, 1, 1 а все можно засунуть просто в 1 регистр 
			//Dont forget that genome reserver fc0 so 0-4 registers is fc1
			fragmentConstants[0] = 1;
			fragmentConstants[1] = 1;
			fragmentConstants[2] = 1;
			fragmentConstants[3] = 1;
			
			fragmentConstants[4] = 9;
			fragmentConstants[5] = 9;
			fragmentConstants[6] = 9;
			fragmentConstants[7] = 9;
			
			fragmentConstants[8] = 	Math.sin(_grassFactor + p_defaultTexture.g2d_contextId);
			fragmentConstants[9] = 	0;
			fragmentConstants[10] = 0;
			fragmentConstants[11] = 0;
			
			fragmentConstants[12] = 0.04;
			fragmentConstants[13] = 0;
			fragmentConstants[14] = 0;
			fragmentConstants[15] = 0;
			
			fragmentConstants[16] = p_defaultTexture.g2d_region.x / p_defaultTexture.gpuWidth;  		//uv->x
			fragmentConstants[17] = p_defaultTexture.g2d_region.y / p_defaultTexture.gpuHeight; 		//uv->y
			fragmentConstants[18] = p_defaultTexture.g2d_region.width / p_defaultTexture.gpuWidth; 		//uv->width
			fragmentConstants[19] = p_defaultTexture.g2d_region.height / p_defaultTexture.gpuHeight;	//uv->height
			
			super.bind(p_context, p_defaultTexture);
			
			fragmentConstants.length = 0;
		}
	}
}