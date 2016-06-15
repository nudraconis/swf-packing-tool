package 
{

	public function internal_trace(...args:Array):void
	{
		PrintUtil.instance.printArray(args);
		trace(args);
	}

}