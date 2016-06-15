package view.genome 
{
	import com.genome2d.Genome2D;
	
	public class VMemStat 
	{
		private var MB:int = 1024 * 1024;
		public function VMemStat() 
		{
			
		}
		
		public function toString():String
		{
			return "<font color='#999999'>vMEM:</font>" + Math.round(Genome2D.g2d_instance.g2d_context.g2d_nativeContext["totalGPUMemory"] / MB) + "MB";
		}
	}
}