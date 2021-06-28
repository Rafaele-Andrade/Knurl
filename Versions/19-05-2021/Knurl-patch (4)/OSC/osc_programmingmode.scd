/***** osc_programmingmode.scd *****/
/***** Oscdef_programingmode.scd *****/

OSCdef(\programingmode, {|msg|
	var id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];

	
		~mode = mode;
		~id = id;
		~dig = dig;
		~count = count; 
		~function = func;
		
~function.postln;
if ( ~mode == 1){

	if ( ~function == 0){  /***** play *****/
	
		if(~id == 101){
			fork{
			2.wait;
			if(~count == 1 && ~ss1 == nil, {  ~nv1 = Synth(\newvoice, [\bufnum, ~a]); 'recording a'.postln});
			if(~count == 2 && ~ss2 == nil, {  ~nv2 = Synth(\newvoice, [\bufnum, ~b]); 'recording b'.postln});
			if(~count == 3 && ~ss3 == nil, {  ~nv3 = Synth(\newvoice, [\bufnum, ~c]); 'recording c'.postln});
			if(~count == 4 && ~ss4 == nil, {  ~nv4 = Synth(\newvoice, [\bufnum, ~d]); 'recording d'.postln});
			};	
		};
		
		if(~id == 102){
			fork{
			2.wait;
			if(~count == 1 && ~od1 == nil, {  ~nv1 = Synth('overdubb', [\bufnum, ~a]); 'overdubble a'.postln});
			if(~count == 2 && ~od2 == nil, {  ~nv2 = Synth('overdubb', [\bufnum, ~b]); 'overdubble b'.postln});
			if(~count == 3 && ~od3 == nil, {  ~nv3 = Synth('overdubb', [\bufnum, ~c]); 'overdubble c'.postln});
			if(~count == 4 && ~od4 == nil, {  ~nv4 = Synth('overdubb', [\bufnum, ~d]); 'overdubble d'.postln});
			};	
		};
		
		if(~id == 103){
			fork{
			2.wait;
			if(~count == 1 && ~ss1 == nil, {  ~nv1 = Synth('simplestream', [\bufnum, ~a]); 'simplestream a'.postln});
			if(~count == 2 && ~ss2 == nil, {  ~nv2 = Synth('simplestream', [\bufnum, ~b]); 'simplestream b'.postln});
			if(~count == 3 && ~ss3 == nil, {  ~nv3 = Synth('simplestream', [\bufnum, ~c]); 'simplestream c'.postln});
			if(~count == 4 && ~ss4 == nil, {  ~nv4 = Synth('simplestream', [\bufnum, ~d]); 'simplestream d'.postln});
			};	
		};
		
		if(~id == 104){
			fork{
			2.wait;
			if(~count == 1 && ~bm1 == nil, {  ~nv1 = Synth('beatmaker', ['bufnum', ~a]); 'beatmaker a'.postln});
			if(~count == 2 && ~bm2 == nil, {  ~nv2 = Synth('beatmaker', ['bufnum', ~b]); 'beatmaker b'.postln});
			if(~count == 3 && ~bm3 == nil, {  ~nv3 = Synth('beatmaker', ['bufnum', ~c]); 'beatmaker c'.postln});
			if(~count == 4 && ~bm4 == nil, {  ~nv4 = Synth('beatmaker', ['bufnum', ~d]); 'beatmaker d'.postln});
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
