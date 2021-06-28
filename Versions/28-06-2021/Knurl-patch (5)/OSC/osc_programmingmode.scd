/***** osc_programmingmode.scd *****/
/***** Oscdef_programingmode.scd *****/

OSCdef(\programingmode, {|msg|
	var id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];

	
		~modee = mode;
		~idu = id;
		~dig = dig;
		~count = count; 
		~funci = func;
		
if ( ~modee == 1){

	if ( ~funci == 0){  /***** play *****/
	
		if(~idu == 101){
			fork{
			2.wait;
			if(~count == 1){ if( ~nv1 == nil, {  ~nv1 = Synth('newvoice', [\bufnum, ~a]); 	m.sendMsg('/knurlconsole', 'recording a');'recording a'.postln},{ if(~nv1store == nil, {~nv1store =1; ~vstorage.add(~nv1); ~vstoragename.add('NewVoice');'storing nv1'.postln},{'stop nv1'.postln; ~nv1store = nil; ~nv1 = nil}) })};
			if(~count == 2){ if( ~nv2 == nil, {  ~nv2 = Synth('newvoice', [\bufnum, ~b]); 	m.sendMsg('/knurlconsole', 'recording b');'recording b'.postln},{ if(~nv2store == nil, {~nv2store =1; ~vstorage.add(~nv2); ~vstoragename.add('NewVoice');'storing nv2'.postln},{~nv2.gate('gate',-4);'stop nv2'.postln; ~nv2store = nil; ~nv2 = nil}) })};
			if(~count == 3){ if( ~nv3 == nil, {  ~nv3 = Synth('newvoice', [\bufnum, ~c]); 	m.sendMsg('/knurlconsole', 'recording c');'recording c'.postln},{ if(~nv3store == nil, {~nv3store =1; ~vstorage.add(~nv3); ~vstoragename.add('NewVoice');'storing nv3'.postln},{~nv3.gate('gate',-4);'stop nv3'.postln; ~nv3store = nil; ~nv3 = nil}) })};
			if(~count == 4){ if( ~nv4 == nil, {  ~nv4 = Synth('newvoice', [\bufnum, ~d]); 	m.sendMsg('/knurlconsole', 'recording d');'recording d'.postln},{ if(~nv4store == nil, {~nv4store =1; ~vstorage.add(~nv4); ~vstoragename.add('NewVoice');'storing nv4'.postln},{~nv4.gate('gate',-4);'stop nv4'.postln; ~nv4store = nil; ~nv4 = nil}) })};
			};	
		};
		
		if(~idu == 103){
			fork{
			2.wait;
			if(~count == 1 ){ if(~od1 == nil, {  ~ob1 = Synth('overdubb', [\bufnum, ~a]); m.sendMsg('/knurlconsole', 'overdubble a');'overdubble a'.postln},{ if(~od1store == nil, {~od1store =1; ~vstorage.add(~od1); ~vstoragename.add('Overdubb'); 'storing od1'.postln},{~od1.set('gate',-4);'stop od1'.postln; ~od1store = nil; ~od1 = nil}) })};
			if(~count == 2 ){ if(~od2 == nil, {  ~ob2 = Synth('overdubb', [\bufnum, ~b]); m.sendMsg('/knurlconsole', 'overdubble b');'overdubble b'.postln},{ if(~od2store == nil, {~od2store =1; ~vstorage.add(~od2); ~vstoragename.add('Overdubb'); 'storing od2'.postln},{~od2.set('gate',-4);'stop od2'.postln; ~od2store = nil; ~od2 = nil}) })};
			if(~count == 3 ){ if(~od3 == nil, {  ~ob3 = Synth('overdubb', [\bufnum, ~c]); m.sendMsg('/knurlconsole', 'overdubble c');'overdubble c'.postln},{ if(~od3store == nil, {~od3store =1; ~vstorage.add(~od3); ~vstoragename.add('Overdubb'); 'storing od3'.postln},{~od3.set('gate',-4);'stop od3'.postln; ~od3store = nil; ~od3 = nil}) })};
			if(~count == 4 ){ if(~od4 == nil, {  ~ob4 = Synth('overdubb', [\bufnum, ~d]); m.sendMsg('/knurlconsole', 'overdubble d');'overdubble d'.postln},{ if(~od4store == nil, {~od4store =1; ~vstorage.add(~od4); ~vstoragename.add('Overdubb'); 'storing od4'.postln},{~od4.set('gate',-4);'stop od4'.postln; ~od4store = nil; ~od4 = nil}) })};
			};	
		};
		
		if(~idu == 102){
			fork{
			2.wait;
			if(~count == 1 ){ if(~ss1 == nil, {  ~ss1 = Synth('simplestream', [\bufnum, ~a]); m.sendMsg('/knurlconsole', 'simplestream a');'simplestream a'.postln},{ if(~ss1store == nil, {~ss1store =1; ~vstorage.add(~ss1); ~vstoragename.add('simplestream');'storing nv1'.postln},{~ss1.set('gate',-4);'stop nv1'.postln; ~ss1store = nil; ~ss1 = nil}) })};
			if(~count == 2 ){ if(~ss2 == nil, {  ~ss2 = Synth('simplestream', [\bufnum, ~b]); m.sendMsg('/knurlconsole', 'simplestream b');'simplestream b'.postln},{ if(~ss2store == nil, {~ss2store =1; ~vstorage.add(~ss2); ~vstoragename.add('simplestream');'storing nv2'.postln},{~ss2.set('gate',-4);'stop nv2'.postln; ~ss2store = nil; ~ss2 = nil}) })};
			if(~count == 3 ){ if(~ss3 == nil, {  ~ss3 = Synth('simplestream', [\bufnum, ~c]); m.sendMsg('/knurlconsole', 'simplestream c');'simplestream c'.postln},{ if(~ss3store == nil, {~ss3store =1; ~vstorage.add(~ss3); ~vstoragename.add('simplestream');'storing nv3'.postln},{~ss3.set('gate',-4);'stop nv3'.postln; ~ss3store = nil; ~ss3 = nil}) })};
			if(~count == 4 ){ if(~ss4 == nil, {  ~ss4 = Synth('simplestream', [\bufnum, ~d]); m.sendMsg('/knurlconsole', 'simplestream d');'simplestream d'.postln},{ if(~ss4store == nil, {~ss4store =1; ~vstorage.add(~ss4); ~vstoragename.add('simplestream');'storing nv4'.postln},{~ss4.set('gate',-4);'stop nv4'.postln; ~ss4store = nil; ~ss4 = nil}) })};
			};	
		};
		
		if(~idu == 104){
			fork{
			2.wait;
			if(~count == 1 ){ if(~bm1 == nil, {  ~bm1 = Synth('beatmaker', ['bufnum', ~a]); m.sendMsg('/knurlconsole', 'beatmaker a');'beatmaker a'.postln},{ if(~ss1store == nil, {~bm1store =1; ~vstorage.add(~ss1); ~vstoragename.add('beatmaker');'storing nv1'.postln},{~ss1.set('gate',-4);'stop nv1'.postln; ~ss1store = nil; ~bm1 = nil}) })};
			if(~count == 2 ){ if(~bm2 == nil, {  ~bm2 = Synth('beatmaker', ['bufnum', ~b]); m.sendMsg('/knurlconsole', 'beatmaker b');'beatmaker b'.postln},{ if(~ss2store == nil, {~bm2store =1; ~vstorage.add(~ss2); ~vstoragename.add('beatmaker');'storing nv2'.postln},{~ss2.set('gate',-4);'stop nv2'.postln; ~ss2store = nil; ~bm2 = nil}) })};
			if(~count == 3 ){ if(~bm3 == nil, {  ~bm3 = Synth('beatmaker', ['bufnum', ~c]); m.sendMsg('/knurlconsole', 'beatmaker c');'beatmaker c'.postln},{ if(~ss3store == nil, {~bm3store =1; ~vstorage.add(~ss3); ~vstoragename.add('beatmaker');'storing nv3'.postln},{~ss3.set('gate',-4);'stop nv3'.postln; ~ss3store = nil; ~bm3 = nil}) })};
			if(~count == 4 ){ if(~bm4 == nil, {  ~bm4 = Synth('beatmaker', ['bufnum', ~d]); m.sendMsg('/knurlconsole', 'beatmaker d');'beatmaker d'.postln},{ if(~ss4store == nil, {~bm4store =1; ~vstorage.add(~ss4); ~vstoragename.add('beatmaker');'storing nv4'.postln},{~ss4.set('gate',-4);'stop nv4'.postln; ~ss4store = nil; ~bm4 = nil}) })};
			};	
		};
		
	};
	
	if ( ~funci == 1){   /***** set *****/
	
			if(~idu == 101){
			fork{
			2.wait;
			if(~count == 1){  ~buffertime = 1};
			if(~count == 2){  ~buffertime = 2};
			if(~count == 3){  ~buffertime = 3};
			if(~count == 4){  ~buffertime = 4};
			};	
		};
		
			
	};
	
	if ( ~funci == 2){   /***** stop *****/


		if(~idu == 101){
			fork{
			2.wait;
			if(~count == 1){ ~nv1.gate('gate',-4); m.sendMsg('/knurlconsole', 'stop nv1');'stop nv1'.postln; ~nv1store = nil; ~nv1 = nil};
			if(~count == 2){ ~nv2.gate('gate',-4); m.sendMsg('/knurlconsole', 'stop nv2');'stop nv2'.postln; ~nv2store = nil; ~nv2 = nil};
			if(~count == 3){ ~nv3.gate('gate',-4); m.sendMsg('/knurlconsole', 'stop nv3');'stop nv3'.postln; ~nv3store = nil; ~nv3 = nil};
			if(~count == 4){ ~nv4.gate('gate',-4); m.sendMsg('/knurlconsole', 'stop nv4');'stop nv4'.postln; ~nv4store = nil; ~nv4 = nil};
			};	
		};
		
		if(~idu == 103){
			fork{
			2.wait;
			if(~count == 1 ){ ~od1.set('gate',-4);m.sendMsg('/knurlconsole', 'stop od1');'stop od1'.postln; ~od1store = nil; ~od1 = nil};
			if(~count == 2 ){ ~od2.set('gate',-4);m.sendMsg('/knurlconsole', 'stop od2');'stop od2'.postln; ~od2store = nil; ~od2 = nil};
			if(~count == 3 ){ ~od3.set('gate',-4);m.sendMsg('/knurlconsole', 'stop od3');'stop od3'.postln; ~od3store = nil; ~od3 = nil};
			if(~count == 4 ){ ~od4.set('gate',-4);m.sendMsg('/knurlconsole', 'stop od4');'stop od4'.postln; ~od4store = nil; ~od4 = nil};
			};	
		};
		
		if(~idu == 102){
			fork{
			2.wait;
			if(~count == 1 ){ ~ss1.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv1');'stop nv1'.postln; ~ss1store = nil; ~ss1 = nil};
			if(~count == 2 ){ ~ss2.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv2');'stop nv2'.postln; ~ss2store = nil; ~ss2 = nil};
			if(~count == 3 ){ ~ss3.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv3');'stop nv3'.postln; ~ss3store = nil; ~ss3 = nil};
			if(~count == 4 ){ ~ss4.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv4');'stop nv4'.postln; ~ss4store = nil; ~ss4 = nil};
			};	
		};
		
		if(~idu == 104){
			fork{
			2.wait;
			if(~count == 1 ){ ~ss1.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv1');'stop nv1'.postln; ~ss1store = nil; ~bm1 = nil};
			if(~count == 2 ){ ~ss2.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv2');'stop nv2'.postln; ~ss2store = nil; ~bm2 = nil};
			if(~count == 3 ){ ~ss3.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv3');'stop nv3'.postln; ~ss3store = nil; ~bm3 = nil};
			if(~count == 4 ){ ~ss4.set('gate',-4);m.sendMsg('/knurlconsole', 'stop nv4');'stop nv4'.postln; ~ss4store = nil; ~bm4 = nil};
			};	
		};
		
	}
}
}, "/trpm");
