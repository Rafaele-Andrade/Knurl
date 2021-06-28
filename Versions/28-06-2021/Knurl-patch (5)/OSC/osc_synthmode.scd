/***** osc_synthmode.scd *****/
(

OSCdef(\synthmode, {|msg|
		var id = msg[2], mode = msg[3], func = msg[4] , inputs = msg[5], rewrite = msg[6], count = msg[7].asInt,  dig = msg[8];
		var	classif = -4, linan1,linan2;
		
		var b2;
	/*"This patch simulates a counter button, the data has to be update in the instance of the evaluation so we use global environment vor the variables"*/	
		~dig = dig ;
		~count = count;
		~id = id;
		~mod = mode;
		~func = func;
	


   /*the Conditions are evauate after 1 sec. through a Task function*/
	if(~mod == 0){ 
~count.postln;	
		if(~func == 0){  
		//D1
	if(~id == 101) {
						if(~count == 1){
						
						t = Task({
						fork{
						1.5.wait;
						if(~count == 1){
						if(~a1 != nil,{	~a1.set(\gate,classif); "Sequence  0".postln; },
						{
						x = Synth('blinker', ['outPin', 0, 'rate', 2, 'seq', 1]);
						~a1 = Synth(\Sequencer);
						~name = 'Sequencer'; 
						"synth A1  on".postln;
						m.sendMsg("/tr", "Sequencer 1");
												1.wait; 
												t.stop; 
												t.reset; 
												
											
												
											
						})
						}}
						});  //short press
						t.start;
						};
		
					if(~count == 2, {
		
									t = Task({
										fork{
										2.wait;
										if(~count == 2){
										// 0.4.wait;
										if(~a2 != nil, {
		
											if (~ampprepare != nil, { ~a2.set(\amp, ~amp); },{
											~ampprepare = nil;
											~a2.set(\gate,classif);
											p = Task({
											fork{4.wait; ~b = nil; 1.wait;p.reset; p.stop;}});
											p.start;  ["synth A2  off" ++ classif].postln;
		
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
											
											m.sendMsg("/tr", "recPlay 0");
											})},
		
											{
												if(~a2 == nil, { 1.do{
												fork{
												if(~rec == nil) {~rec= Synth(\record_my_voice)};
												6.wait;
												~a2 = Synth(\recPlay);
												 ~worksynth = ~a2;   //for interaction
												};
												x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 2]);
												"synth A2  on".postln;
												~name = 'RecPlay';
										
											n.sendMsg("/tr", "recPlay 1");
		
												}})
											}
										 );  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});

		
						if(~count == 3, {
		
									t = Task({
		
										fork{
										2.wait;
										if(~count == 3){
								
										if(~a3 != nil, {
										if (~ampprepare != nil, { ~a3.set(\amp, ~amp); },{
										~ampprepare = nil;
										~a3.set(\gate, classif);
										 ~worksynth = ~a3;
										m.sendMsg("/console", "lorenzSynth 0:");
										
										p = Task({fork{7.wait; ~a3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); }) },
											{ 	if(~a3 == nil, {
												~a3 = Synth(\lorenzSynth);
												~name = 'lorenzSynth';
											m.sendMsg("/tr", "lorenzSynth 1");
											
											"Lorenz on".postln;
											x = Synth('blinker', ['outPin', ~ledred, 'rate', 2, 'seq', 3]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
						if(~count == 4, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
									1.2.wait;
										if(~count == 4){
										// 0.4.wait;
										if(~a4 != nil,{
											if (~ampprepare != nil, { ~a4.set(\amp, ~amp); },{
											~ampprepare = nil;
										~a4.set(\gate,  classif);

										n.sendMsg("/tr", "AudFeedback 0");
										["sm: A4 off:" ++ classif].postln;
										p = Task({fork{4.wait; ~a4 = nil; 1.wait;p.reset; p.stop;}});
										p.start; x = Synth('blinker', ['outPin', ~ledred, 'rate', 2, 'seq', 4]); })},
										{ 	if(~a4 == nil, {
											~a4 = Synth(\AudFeedback);
											~name = 'AudFeedback';
											~worksynth = ~a4;
										"A4".postln;
										// b.sendMsg("/tr", "sm: A4 on"); x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]);
										if(n != nil){n.sendMsg("/tr", "AudFeedback 1");};
										 }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
		
		};
		
	//D2
	if(~id == 102) {
	
						
				
			if(~count == 1, {
							
									t = Task({
		
										fork{
										2.wait;
		
										if(~count == 1){
										// 0.4.wait;
		
										if(~b1 != nil, {
											if (~storingb1 != nil,
												{ ~vstorage.add(~b1); ~vstoragename.add('Ambience'); 'storingb1'.postln;  ~storingb1 = nil; },
												{~b1.set(\gate, -4);
												//	"b2 0".postln;
												4.wait; ~b1 = nil;
											
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
											m.sendMsg('/knurlconsole', "Ambience 0");
										
											
											})
											},
											{ 	if(~b1 == nil, {   
												~b1 = Synth(\Ambience);  
												~lastsynth = ~b1;	 
												~storingb1 = 1;
												//"sm: Freqshift 1".postln;
												~name = 'Ambience';
										if(m != nil){m.sendMsg('/knurlconsole', "Ambience 1") };
						
										x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							if(~count == 2, {
							
									t = Task({
		
										fork{
										2.wait;
		
										if(~count == 2){
										// 0.4.wait;
		
										if(~b2 != nil, {
											if (~storingb2 != nil, 
											{ ~vstorage.add(~b2); ~vstoragename.add('FreqShift');'storing b2'.postln; ~storingb2 = nil},
											{
											b2.set(\gate, -4);
											"b2 off".postln;
											4.wait; 
											~b2 = nil; 
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
											m.sendMsg('/knurlconsole', "FreqShift 0");
										
											
											})
											},
											{ 	if(~b2== nil, {   
												~b2 = Synth(\FreqShift);  
												1.wait;
												~lastsynth = ~b2;	 
												~storingb2 = 1;
												"sm: FreqShift 1".postln;
												~name = 'FreqShift';
										m.sendMsg('/knurlconsole', "FreqShift 1");
						
										x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 2]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							if(~count == 3, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
										2.wait;
		
		
										if(~count == 3){
											if(~b3 != nil, 
												{if (~storingb3  != nil,
													{ ~vstorage.add(~b3); ~vstoragename.add('Reus'); 'storing b3'.postln; ~storingb3 = nil; },
													{
													~b3.set(\gate, classif);
													"B3 off".postln;
													4.wait; ~b3 = nil; 
													m.sendMsg('/knurlconsole', "Reus 0");
											})
											},
										{ 	if(~b3 == nil, 
												{   ~b3 = Synth(\Reus); 
													~name = 'Reus';
													~lastsynth  = ~b3;	
													~storingb3 = 1;
										"B3 (Reus) on".postln;
									m.sendMsg('/knurlconsole', "Reus 1");
										x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 3]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
				
		
		
								};
		
	//D3
	if(~id == 103) {
		
							if(~count == 1, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({
		
								fork{
								
								2.wait;
								if(~count == 1){
								// 0.4.wait;
								if(~c1 != nil,
								{
									if ( ~storingc1  != nil,{~vstorage.add(~c1);  ~vstoragename.add('SinChoir');'storing c1'.postln; ~storingc1 = nil;},{
											~c1.set(\gate,   classif);
											"1C off".postln;
											4.wait; ~c1 = nil; 
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
										m.sendMsg('/knurlconsole', "SinChoir 0");
									})
								},  //long press
								{ 	if(~c1 == nil, {   
							
								~c1 = Synth(\SinChoir);
								~name = 'SinChoir';
								~lastsynth  = ~c1;	
								~storingc1 = 1;
								m.sendMsg('/knurlconsole', "SinChoir 1");
								"1C on".postln;
								x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) });
									1.wait;
									~c1.set( \gatefi, 0 , \gatelin, 0);

									t.reset;
									t.stop;
								}}
							});
							t.start;
					      	});
		
		
							if(~count == 2, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({
							fork{
							2.wait;
							if(~count == 2 ){
							if(~c2 != nil, {
								if (~storingc2 != nil, {~vstorage.add(~c2); ~vstoragename.add('SawChoir'); 'storing c2'.postln; ~storingc2 = nil; },{
								
							~c2.set(\gate, classif);
							4.wait; ~c2 = nil;
							"2C off".postln;
							m.sendMsg('/knurlconsole', "SawChoir 0");
							x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); })},
								{ 	if(~c2 == nil, {
									~name = 'SawChoir';
									~c2 = Synth(\SawChoir);
									~lastsynth  = ~c2;	
									~storingc2 = 1;
									m.sendMsg('/knurlconsole', "SawChoir 1");
									"SawChoir 1".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 1, 'seq', 2]); }) });  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							if(~count == 3, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
										2.wait;
										if(~count == 3){
										// 0.4.wait;
										if(~c3 != nil, {
											if (~storingc3 != nil, {~vstorage.add(~c3);  ~vstoragename.add('Ocarina'); 'storing c3'.postln; ~storingc3 = nil;},{
											~c3.set(\gate, classif);
										
										"3C off".postln;
										m.sendMsg('/knurlconsole', "Ocarina 0");
										p = Task({fork{4.wait; ~c3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
										})
		
										},
									{ 	if(~cc3 == nil, {   
										~c3 = Synth(\ocarina);
										~name = 'Ocarina';
										~lastsynth = ~c3;	
										~storingc3 = 1;
									m.sendMsg('/knurlconsole', "Ocarina 1");
									"Ocarina 1".postln;
									x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 3]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							if(~count == 4, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
										2.wait;
										if(~count == 4){
										// 0.4.wait;
										if(~c4 != nil, {
											if (~storingc4 != nil, {~vstorage.add(~c4);  ~vstoragename.add('AudFeedback');  ~storingc4 = nil;},{
											~c4.set(\gate, classif);
										m.sendMsg('/knurlconsole', "AudFeedback 0");
										p = Task({fork{4.wait; ~c4 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
										})
		
										},
									{ 	if(~c4 == nil, {   
										~c4 = Synth(\AudFeedback);
										~name = 'AudFeedback';
										~lastsynth = ~c4;	
										~storingc4 = 1;
									m.sendMsg('/knurlconsole', "AudFeedback 1");
									"AudFeedback 1".postln;
									x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
								};
								
						//D4
						if(~id == 104) {
		
							if(~count == 1, {
								fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({
		
								fork{
								1.wait;
								if(~count == 1){
		
								if(~d1 != nil,{
									if (~ampprepare != nil, { ~d1.set(\amp, ~amp); },{
											~ampprepare = nil;
											~d1.set(\gate, classif);
											// b.sendMsg("/tr", "sm: 1D off" ++ classif);
											m.sendMsg('/knurlconsole', "BeatTrack 0");
								["1D off" ++ classif].postln;
								p = Task({fork{4.wait; ~d1 = nil; 1.wait;p.reset; p.stop;}});
								p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]); })},
								{ 	if(~d1 == nil, { 
									~d1 = Synth(\BeatTrack); 
								~name = 'BeatTrack';
								~worksynth= ~d1;
									// b.sendMsg("/tr", "sm: 1D on");
								m.sendMsg('/knurlconsole', "BeatTrack 1");
														"1D on".postln;
														x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) }
														);  //short press
		
									1.wait;
									t.reset;
									t.stop;
								}}
							});
							t.start;
					      	});
		
		
							if(~count == 2, {
								fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
										1.wait;
										if(~count == 2){
										// 0.4.wait;
										if(~d2 != nil,{
											if (~ampprepare != nil, { ~d2.set(\amp, ~amp); },{
											~ampprepare = nil;
											~d2.set(\gate, classif) ;
											// b.sendMsg("/tr", "sm: 2D off" ++ classif);
											m.sendMsg('/knurlconsole', "Sparky 0");
										["Sparky 0" ++ classif].postln;
										p = Task({fork{4.wait; ~d2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); }) },
										{ 	if(~d2 == nil, {
											 ~d2 = Synth(\Sparky);
											~worksynth = ~d2;
											~name = 'Sparky';
											// b.sendMsg("/tr", "sm: 2D on");
											m.sendMsg('/knurlconsole', "Sparky 1");
																"Sparky 1".postln;
																x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 2]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							if(~count == 3, {
								fork{1.do{"synth mode receiving".postln;}; 5.wait};
									t = Task({
		
										fork{
										1.wait;
										if(~count == 3){
										// 0.4.wait;
										if(~d3 != nil,{
											if (~ampprepare != nil, { ~d3.set(\amp, ~amp); },{
											~ampprepare = nil;
											~d3.set(\gate, classif);
										m.sendMsg('/knurlconsole', "Converb 0");
										p = Task({fork{4.wait; ~d3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]); })},
										{ 	if(~d3 == nil, {   ~d3 = Synth(\Converb);
										~name = 'Converb';
										~lastsynth = ~d3;
										m.sendMsg('/knurlconsole', "Converb 1");
										"3D ON".postln;
										x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 3]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							// if(~count == 4 , {
							// 	fork{1.do{"synth mode receiving".postln;}; 5.wait};
							// 		t = Task({
		
							// 			fork{
							// 			1.wait;
							// 			if(~count == 4){
							// 			// 0.4.wait;
							// 			if(~d4 != nil,{
							// 				if (~ampprepare != nil, { ~d4.set(\amp, ~amp); },{
							// 				~ampprepare = nil;
							// 				~d4.set(\gate, classif) ; 
							// 				// b.sendMsg("/tr", "sm: 4D off" ++ classif);
							// 			["4D off" ++ classif].postln;
							// 			if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Moog 0");});
							// 			p = Task({fork{4.wait; ~d4 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', ]); }) },
							// 			{ 	if(~d4 == nil, {
							// 				~d4 = Synth(\Moog);
							// 				~name = 'Moog';
							// 				~worksynth = ~d4;
							// 				// b.sendMsg("/tr", "synth S on");
							// 				if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Moog 1 ");});
							// 			"4D ON".postln;
							// 			x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); }, {"sm: 4D on".postln}) }
							// 			);  //short press
		
							// 							1.wait;
							// 							t.reset;
							// 							t.stop;
							// 					}}
							// 				});
							// 				t.start;
							// 		});
		
								};
		
		};

		if(~func == 1){  /*set*/
		
		if(~rewrite == 0){	 // freq amp
		t = Task({
		fork{
			1.wait;

			if (~id == 101 && ~count == 1, { if( ~a1 != nil && ~freqamp == nil,{~a1.set('gatef', 1, 'gateamp', 1); 'filter and lin a1'.postln},{ fork {~a1.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 101 && ~count == 2, { if( ~a2 != nil && ~freqamp == nil,{~a2.set('gatef', 1, 'gateamp', 1); 'filter and lin a2'.postln},{ fork {~a2.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 101 && ~count == 3, { if( ~a3 != nil && ~freqamp == nil,{~a3.set('gatef', 1, 'gateamp', 1); 'filter and lin a3'.postln},{ fork {~a3.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 101 && ~count == 4, { if( ~a4 != nil && ~freqamp == nil,{~a4.set('gatef', 1, 'gateamp', 1); 'filter and lin a4'.postln},{ fork {~a4.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			
			if (~id == 102 && ~count == 1, { if( ~b1 != nil && ~freqamp == nil,{~b1.set('gatef', 1, 'gateamp', 1); 'filter and lin b1'.postln},{ fork {~b1.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 102 && ~count == 2, { if( ~b2 != nil && ~freqamp == nil,{~b2.set('gatef', 1, 'gateamp', 1); 'filter and lin b2'.postln},{ fork {~b2.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 102 && ~count == 3, { if( ~b3 != nil && ~freqamp == nil,{~b3.set('gatef', 1, 'gateamp', 1); 'filter and lin b3'.postln},{ fork {~b3.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 102 && ~count == 4, { if( ~b4 != nil && ~freqamp == nil,{~b4.set('gatef', 1, 'gateamp', 1); 'filter and lin b4'.postln},{ fork {~b4.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
				
			if (~id == 103 && ~count == 1, { if( ~c1 != nil && ~freqamp == nil,{~c1.set('gatef', 1, 'gateamp', 1); 'filter and lin c1'.postln},{ fork {~c1.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 103 && ~count == 2, { if( ~c2 != nil && ~freqamp == nil,{~c2.set('gatef', 1, 'gateamp', 1); 'filter and lin c2'.postln},{ fork {~c2.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 103 && ~count == 3, { if( ~c3 != nil && ~freqamp == nil,{~c3.set('gatef', 1, 'gateamp', 1); 'filter and lin c3'.postln},{ fork {~c3.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 103 && ~count == 4, { if( ~c4 != nil && ~freqamp == nil,{~c4.set('gatef', 1, 'gateamp', 1); 'filter and lin c4'.postln},{ fork {~c4.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			
			if (~id == 104 && ~count == 1, { if( ~d1 != nil && ~freqamp == nil,{~d1.set('gatef', 1, 'gateamp', 1); 'filter and lin d1'.postln},{ fork {~d1.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 104 && ~count == 2, { if( ~d2 != nil && ~freqamp == nil,{~d2.set('gatef', 1, 'gateamp', 1); 'filter and lin d2'.postln},{ fork {~d2.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 104 && ~count == 3, { if( ~d3 != nil && ~freqamp == nil,{~d3.set('gatef', 1, 'gateamp', 1); 'filter and lin d3'.postln},{ fork {~d3.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			if (~id == 104 && ~count == 4, { if( ~d4 != nil && ~freqamp == nil,{~d4.set('gatef', 1, 'gateamp', 1); 'filter and lin d4'.postln},{ fork {~d4.set('gatef', 0, 'gateamp', 0) ; 1.wait ; ~freqamp = nil}});});
			
		}}); t.start;
			
		};
		
		if(~rewrite == 1){	 // filter lin 
		t = Task({
		fork{
			1.wait;
			if (~id == 101 && ~count == 1, { if( ~a1 != nil && ~filin == nil,{~a1.set('gatefi', 1, 'gatelin', 1); 'filter and lin a1'.postln},{ fork {~a1.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 101 && ~count == 2, { if( ~a2 != nil && ~filin == nil,{~a2.set('gatefi', 1, 'gatelin', 1); 'filter and lin a2'.postln},{ fork {~a2.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 101 && ~count == 3, { if( ~a3 != nil && ~filin == nil,{~a3.set('gatefi', 1, 'gatelin', 1); 'filter and lin a3'.postln},{ fork {~a3.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 101 && ~count == 4, { if( ~a4 != nil && ~filin == nil,{~a4.set('gatefi', 1, 'gatelin', 1); 'filter and lin a4'.postln},{ fork {~a4.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			
			if (~id == 102 && ~count == 1, { if( ~b1 != nil && ~filin == nil,{~b1.set('gatefi', 1, 'gatelin', 1); 'filter and lin b1'.postln},{ fork {~b1.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 102 && ~count == 2, { if( ~b2 != nil && ~filin == nil,{~b2.set('gatefi', 1, 'gatelin', 1); 'filter and lin b2'.postln},{ fork {~b2.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 102 && ~count == 3, { if( ~b3 != nil && ~filin == nil,{~b3.set('gatefi', 1, 'gatelin', 1); 'filter and lin b3'.postln},{ fork {~b3.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 102 && ~count == 4, { if( ~b4 != nil && ~filin == nil,{~b4.set('gatefi', 1, 'gatelin', 1); 'filter and lin b4'.postln},{ fork {~b4.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
				
			if (~id == 103 && ~count == 1, { if( ~c1 != nil && ~filin == nil,{~c1.set('gatefi', 1, 'gatelin', 1); 'filter and lin c1'.postln},{ fork {~c1.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 103 && ~count == 2, { if( ~c2 != nil && ~filin == nil,{~c2.set('gatefi', 1, 'gatelin', 1); 'filter and lin c2'.postln},{ fork {~c2.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 103 && ~count == 3, { if( ~c3 != nil && ~filin == nil,{~c3.set('gatefi', 1, 'gatelin', 1); 'filter and lin c3'.postln},{ fork {~c3.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 103 && ~count == 4, { if( ~c4 != nil && ~filin == nil,{~c4.set('gatefi', 1, 'gatelin', 1); 'filter and lin c4'.postln},{ fork {~c4.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			
			if (~id == 104 && ~count == 1, { if( ~d1 != nil && ~filin == nil,{~d1.set('gatefi', 1, 'gatelin', 1); 'filter and lin d1'.postln},{ fork {~d1.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 104 && ~count == 2, { if( ~d2 != nil && ~filin == nil,{~d2.set('gatefi', 1, 'gatelin', 1); 'filter and lin d2'.postln},{ fork {~d2.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 104 && ~count == 3, { if( ~d3 != nil && ~filin == nil,{~d3.set('gatefi', 1, 'gatelin', 1); 'filter and lin d3'.postln},{ fork {~d3.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			if (~id == 104 && ~count == 4, { if( ~d4 != nil && ~filin == nil,{~d4.set('gatefi', 1, 'gatelin', 1); 'filter and lin d4'.postln},{ fork {~d4.set('gatefi', 0, 'gatelin', 0) ; 1.wait ; ~filin = nil}});});
			
		}}); t.start;
			
		};
		
		if( ~rewrite == 2){	 // hold all
		t = Task({
		fork{
			1.wait;
			if (~id == 101 && ~count == 1 && ~a1 != nil, { 1.do{~a1.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 101 && ~count == 2 && ~a2 != nil, { 1.do{~a2.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 101 && ~count == 3 && ~a3 != nil, { 1.do{~a3.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 101 && ~count == 4 && ~a4 != nil, { 1.do{~a4.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			
			if (~id == 102 && ~count == 1 && ~b1 != nil, { 1.do{~b1.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 102 && ~count == 2 && ~b2 != nil, { 1.do{~b2.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 102 && ~count == 3 && ~b3 != nil, { 1.do{~b3.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 102 && ~count == 4 && ~b4 != nil, { 1.do{~b4.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
				
			if (~id == 103 && ~count == 1 && ~c1 != nil, { 1.do{~c1.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 103 && ~count == 2 && ~c2 != nil, { 1.do{~c2.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 103 && ~count == 3 && ~c3 != nil, { 1.do{~c3.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 103 && ~count == 4 && ~c4 != nil, { 1.do{~c4.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			
			if (~id == 104 && ~count == 1 && ~d1 != nil, { 1.do{~d1.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 104 && ~count == 2 && ~d2 != nil, { 1.do{~d2.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 104 && ~count == 3 && ~d3 != nil, { 1.do{~d3.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			if (~id == 104 && ~count == 4 && ~d4 != nil, { 1.do{~d4.set('gatef', 0, 'gateamp', 0,'gatefi', 0, 'gatelin', 0)}});
			
		}}); t.start;
			
		};
		
};

		if(~func == 2){  /*stop*/
		if(~id == 101) {

		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~a1 != nil) {
		~a1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~a1 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 2){
		if(~a2 != nil) {
		~a2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~a2 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 3){
		if(~a3 != nil) {
		~a3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~a3 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 4){
		if(~a4 != nil) {
		~a4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~a4 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
			
		};
		};
		
		if(~id == 102) {

		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~b1 != nil) {
		~b1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~b1 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 2){
		if(~b2 != nil) {
		~b2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~b2 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 3){
		if(~b3 != nil) {
		~b3.set(\gate,classif)
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~b3 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 4){
		if(~b4 != nil) {
		~b4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~b4 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
			
		};

			
		};
		
		if(~id == 103) {

		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~c1 != nil) {
		m.sendMsg('/knurlconsole', "SinChoir 0");
		~c1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~c1 = nil;  
		}};
		
		if(~count == 2){
		if(~c2 != nil) {
		m.sendMsg('/knurlconsole', "SawChoir 0");
		~c2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~c2 = nil;  

		}};
		
		if(~count == 3){
		if(~c3 != nil) {
		m.sendMsg('/knurlconsole', "Ocarina 0");
		~c3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~c3 = nil;  

		}};
		
		if(~count == 4){
		if(~c4 != nil) {
		~c4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~c4 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
			
		};

			
		};
		
		if(~id == 104) {
		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~d1 != nil) {
		~d1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~d1 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 2){
		if(~d2 != nil) {
		~d2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~d2 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 3){
		if(~d3 != nil) {
		~d3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~d3 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
		
		if(~count == 4){
		if(~d4 != nil) {
		~d4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~d4 = nil;  
		m.sendMsg('/knurlconsole', "recPlay 0");
		}};
			
		};
			
		};
		
		};	
		


		if(~func == 3){  /*send*/
			
			// This function is evaluate in another OSCDEF (send virus.scd)
			//101 - freq
			//102 - amp
			//103 - filter 
			//104 - lin
			
			if(~id == 101){ ~reprAn = 'amp'.asSymbol; "set amp".postln;};
			if(~id == 102){ ~reprAn = 'data'.asSymbol; "set data".postln;};
			if(~id == 103){ ~reprAn = 'fade'.asSymbol; "set fade".postln;};
			if(~id == 104){ ~reprAn = 'color'.asSymbol; "set color".postln; };
	
		};	
};


			//[~vstorage[0],~vstorage[1],~vstorage[2],~vstorage[3]].postln;
m.sendMsg('/knurlvstorage', ~vstoragename[0],~vstoragename[1],~vstoragename[2],~vstoragename[3])

}, "/trsm");


)



