/***** osc_programmingmode.scd *****/
/***** Oscdef_programingmode.scd *****/

OSCdef(\programingmode, {|msg|
	var id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];

	
		~mode = mode;
		~id = id;
		~dig = dig;
		~count = count; 
		~function = func;


if ( ~mode == 1){

	if ( ~function == 'play'){  /***** play *****/
	
		if(~id == 101){
			fork{
			2.wait;
			if(~count == 1){  ~nv1 = Synth(\newvoice, ['bufnum', a])};
			if(~count == 2){  ~nv2 = Synth(\newvoice, ['bufnum', b])};
			if(~count == 3){  ~nv3 = Synth(\newvoice, ['bufnum', c])};
			if(~count == 4){  ~nv4 = Synth(\newvoice, ['bufnum', d])};
			};	
		};
		
		if(~id == 102){
			fork{
			2.wait;
			if(~count == 1){  ~nv1 = Synth('overdubb', ['bufnum', a])};
			if(~count == 2){  ~nv1 = Synth('overdubb', ['bufnum', b])};
			if(~count == 3){  ~nv1 = Synth('overdubb', ['bufnum', c])};
			if(~count == 4){  ~nv1 = Synth('overdubb', ['bufnum', d])};
			};	
		};
		
		if(~id == 103){
			fork{
			2.wait;
			if(~count == 1){  ~nv1 = Synth('simplestream', ['bufnum', a])};
			if(~count == 2){  ~nv1 = Synth('simplestream', ['bufnum', b])};
			if(~count == 3){  ~nv1 = Synth('simplestream', ['bufnum', c])};
			if(~count == 4){  ~nv1 = Synth('simplestream', ['bufnum', d])};
			};	
		};
		
		if(~id == 104){
			fork{
			2.wait;
			if(~count == 1){  ~nv1 = Synth('beatmaker', ['bufnum', a])};
			if(~count == 2){  ~nv1 = Synth('beatmaker', ['bufnum', b])};
			if(~count == 3){  ~nv1 = Synth('beatmaker', ['bufnum', c])};
			if(~count == 4){  ~nv1 = Synth('beatmaker', ['bufnum', d])};
			};	
		};
		
	};
	
	if ( ~function == 2){   /***** set *****/
	
			if(~id == 101){
			fork{
			2.wait;
			if(~count == 1){  ~buffertime = 1};
			if(~count == 2){  ~buffertime = 2};
			if(~count == 3){  ~buffertime = 3};
			if(~count == 4){  ~buffertime = 4};
			};	
		};
		
			
	};
	
	if ( ~function == 1){   /***** stop *****/
		
	}
}
}, "/trpm");
