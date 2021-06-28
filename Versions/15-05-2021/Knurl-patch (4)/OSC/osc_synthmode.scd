/***** osc_synthmode.scd *****/
(

OSCdef(\synthmode, {|msg|
		var id = msg[2], mode = msg[3], func = msg[4] , inputs = msg[5], rewrite = msg[6], count = msg[7].asInt,  dig = msg[8], an1 = msg[9].asFloat, an2 = msg[10];
		var	classif = -4, linan1,linan2;
		
	/*"This patch simulates a counter button, the data has to be update in the instance of the evaluation so we use global environment vor the variables"*/	
		~dig = dig ;
		~count = count;
		~id = id;
		~mode = mode ;
		~func = func;
		~inputs = inputs;
		~rewrite = rewrite;
		~an1 = an1;
		~an2 = an2;


   /*the Conditions are evauate after 1 sec. through a Task function*/
	if(~mode == 0 /*"sm"*/){ 
	
		if(~func == 0 /*"play"*/){  
		id.postln(2);
		//D1
		if(id == 101) {
						if(~count == 1){
						
						t = Task({
						fork{
						1.5.wait;
						if(~count == 1){
						if(~a1 == nil){
						x = Synth('blinker', ['outPin', 0, 'rate', 2, 'seq', ~count]);
						~rec= Synth(\record_my_voice); 6.wait; ~a1 = Synth(\recTrack); 
						~name = 'RecTrack'; 
						"synth A1  on".postln;
						n.sendMsg("/tr", "recTrack 1");
												1.wait; 
												t.stop; 
												t.reset; 
												
											
												
											
						}}}
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
											
											n.sendMsg("/tr", "recPlay 0");
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
										n.sendMsg("/tr", "Raw 0:" ++ classif);
									
										["sm A3 off:" ++ classif].postln;
										
										p = Task({fork{7.wait; ~a3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); }) },
											{ 	if(~a3 == nil, {
												~a3 = Synth(\Raw);
												~name = 'Raw';
											n.sendMsg("/tr", "Raw 1");
											
											"synth A3 (Raw): on".postln;
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
	if(id == 102) {
	if(~count == 1){
						
						t = Task({
						fork{
						1.wait;
						if(~count == 1){
						if(~b1 == nil){
						x = Synth('blinker', ['outPin', 0, 'rate', 1, 'seq', ~count]);
						~b1 = Synth(\FreqShift); 
						~name = 'FreqShift'; 
						"synth FreqShift  on".postln;
						n.sendMsg("/tr", "FreqShift 1");
												1.wait; 
												t.stop; 
												t.reset; 
												
											
												
											
						}}}
						});  //short press
						t.start;
						};
						
				
		
		
							if(~count == 2, {
							
									t = Task({
		
										fork{
										2.wait;
		
										if(~count == 2){
										// 0.4.wait;
		
										if(~b2 != nil, {
											if (~ampprepare != nil, { ~b2.set(\amp, ~amp); },{
											~ampprepare = nil;
											~b2.set(\gate, -4);
											
											["b2 off"++ classif].postln;
											p = Task({fork{4.wait; ~b2 = nil; 1.wait;p.reset; p.stop;}});
											p.start;
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
											n.sendMsg("/tr", "lorenzSynth 0");
										
											
											})
											},
											{ 	if(~b2== nil, {   
												~b2 = Synth(\lorenzSynth);  
												~worksynth = ~b2;	 
										
												"sm: lorenzSynth 1".postln;
												~name = 'lorenzSynth';
										if(n != nil){n.sendMsg("/tr", "lorenzSynth 1") };
						
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
										// 0.4.wait;
										if(~b3 != nil, {
											if (~ampprepare != nil, { ~b3.set(\amp, ~amp); },{
											~ampprepare = nil;
											~b3.set(\gate, classif);
											// b.sendMsg("/tr", "sm: 3B off" ++ classif);
										["B3 off"++ classif].postln;
										p = Task({fork{4.wait; ~b3 = nil; 1.wait;p.reset; p.stop;}});
										p.start; x = Synth('blinker', ['outPin', 2, 'rate', 2, 'seq', 3]);
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Reus 0");});
											})
											},
										{ 	if(~b3 == nil, {   ~b3 = Synth(\Reus); 
										~name = 'Reus';
										~worksynth = ~a3;	
										// b.sendMsg("/tr", "sm: 3B on");
										"B3 (Reus) on".postln;
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Reus 1");});
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
							 			1.2.wait;
							 					if(~count == 4){
							 			// 0.4.wait;
							 					if(~b4 != nil,{
							 						if (~ampprepare != nil, { ~b4.set(\amp, ~amp); },{
							 						~ampprepare = nil;
							 						~b4.set(\gate, classif) ;
							 						// b.sendMsg("/tr", "sm: 4B Off"++ classif);
							 						["B4 off"++ classif].postln;
							 						p = Task({fork{4.wait; ~b4 = nil; 1.wait;p.reset; p.stop;}});
							 						p.start;
							 						x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]);
						 						if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Hildur 0");});
							 						})
							 						},
							 			{ 	if(~b4 == nil, {   
							 				~b4 = Synth(\Hildur);
							 			~name = 'Hildur';
							 			~worksynth = ~a4;	
							 			// b.sendMsg("/tr", "sm: 4B ON");
							 			if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Hildur 1");});
							 			"B4 on".postln;
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
		
						//D3
						if(id == 103) {
		
							if(~count == 1, {
								// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({
		
								fork{
								
								2.wait;
								if(~count == 1){
								// 0.4.wait;
								if(~c1 != nil,
								{
									if (~ampprepare != nil, { ~c1.set(\amp, ~amp); },{
											~ampprepare = nil;
											~c1.set(\gate,   classif);
											// b.sendMsg("/tr", "sm: 1C off" ++ classif);
											["1C off" ++ classif].postln;
											p = Task({fork{4.wait; ~c1 = nil; 1.wait;p.reset; p.stop;}}); p.start;
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Ambience 0");});
									})
								},  //long press
								{ 	if(~c1 == nil, {   
							
								~c1 = Synth(\Ambience);
								
								~name = 'Ambience';
									 ~worksynth = ~c1;
									  n.sendMsg("/tr", "Ambience 1");
									  //if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Ambin 1"); n.sendMsg("/tr", "Ambin 1")});
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
							// 0.4.wait;
							if(~c2 != nil, {
								if (~ampprepare != nil, { ~c2.set(\amp, ~amp); },{
								~ampprepare = nil;
							~c2.set(\gate, classif);	p = Task({fork{4.wait; ~c2 = nil; 1.wait;p.reset; p.stop;}}); p.start;
							["2C off" ++ classif].postln;
							if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "SawChoir 0");});
							// b.sendMsg("/tr", "sm: 2C off"); 
							x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); })},
								{ 	if(~c2 == nil, {
									~name = 'SawChoir';
									~c2 = Synth(\SawChoir);
									~worksynth = ~c2;
									// b.sendMsg("/tr", "sm: 2C on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "SawChoir 1");});
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
											if (~ampprepare != nil, { ~c3.set(\amp, ~amp); },{
											~ampprepare = nil;
											~c3.set(\gate, classif);
											// b.sendMsg("/tr", "sm: 3C off" ++ classif);
										["3C off" ++ classif].postln;
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "SinChoir 0");});
										p = Task({fork{4.wait; ~c3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
										})
		
										},
									{ 	if(~cc3 == nil, {   
										~c3 = Synth(\SinChoir);
										~name = 'SinChoir';
										~worksynth = ~c3;	
										// .sendMsg("/tr", "sm: 3C on");
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "SinChoir 1");});
									"3C on".postln;
									x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 3]); }) }
														);  //short press
														1.wait;
														t.reset;
														t.stop;
												}}
											});
											t.start;
		
									});
		
							// if(~count == 4, {
							// 	// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							// 		t = Task({
		
							// 			fork{
							// 			1.2.wait;
							// 			if(~count == 4){
							// 			// 0.4.wait;
		
							// 			if(~c4 != nil,{
							// 				if (~ampprepare != nil, { ~c4.set(\amp, ~amp); },{
							// 				~ampprepare = nil;
							// 				~c4.set(\gate,classif);
							// 				// b.sendMsg("/tr", "sm: 4C off" ++ classif);
							// 				if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "loca 0");});
							// 			["4C off" ++ classif].postln;
							// 			p = Task({fork{4.wait; ~c4 = nil; 1.wait;p.reset; p.stop;}});
							// 			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]); })},
							// 		{ 	if(~c4 == nil, {
							// 			~c4 = Synth(\Loca);
							// 			~name = 'Loca';
							// 			~worksynth = ~c4;
							// 			// b.sendMsg("/tr", "sm: 4C on");
							// 			if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "loca 1");});
							// 			"4C on".postln;
							// 			x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); }) }
							// 							);  //short press
							// 							1.wait;
							// 							t.reset;
							// 							t.stop;
							// 					}}
							// 				});
							// 				t.start;
		
							// 		});
		
								};
								
						//D4
						if(id == 104) {
		
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
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "BeatTrack 0");});
								["1D off" ++ classif].postln;
								p = Task({fork{4.wait; ~d1 = nil; 1.wait;p.reset; p.stop;}});
								p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]); })},
								{ 	if(~d1 == nil, { 
									~d1 = Synth(\BeatTrack); 
								~name = 'BeatTrack';
								~worksynth= ~d1;
									// b.sendMsg("/tr", "sm: 1D on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "BeatTrack 1");});
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
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Sparky 0");});
										["Sparky 0" ++ classif].postln;
										p = Task({fork{4.wait; ~d2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); }) },
										{ 	if(~d2 == nil, {
											 ~d2 = Synth(\Sparky);
											~worksynth = ~d2;
											~name = 'Sparky';
											// b.sendMsg("/tr", "sm: 2D on");
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Sparky 1");});
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
											~d3.set(\gate, classif) ;
											// b.sendMsg("/tr", "sm: 3D off" ++ classif);
										["3D off" ++ classif].postln;
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Sequencer 0");});
										p = Task({fork{4.wait; ~d3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]); })},
										{ 	if(~d3 == nil, {   ~d3 = Synth(\Sequencer);
										~name = 'Sequencer';
											 ~worksynth = ~d3;
											// b.sendMsg("/tr", "sm: 3D on");
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "Sequencer 1");});
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
		
		if(~func == 1 /*"stop"*/){
		
		if(id == 101) {
		t = Task({
		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~a1 != nil) {
		~a1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~a1 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 2){
		if(~a2 != nil) {
		~a2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~a2 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 3){
		if(~a3 != nil) {
		~a3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~a3 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 4){
		if(~a4 != nil) {
		~a4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~a4 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
			
		};
		}); t.start;
		
		};
		
		if(id == 102) {
		t = Task({
		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~b1 != nil) {
		~b1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~b1 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 2){
		if(~b2 != nil) {
		~b2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~b2 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 3){
		if(~b3 != nil) {
		~b3.set(\gate,classif)
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~b3 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 4){
		if(~b4 != nil) {
		~b4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~b4 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
			
		};
		}); t.start;
			
		};
		
		if(id == 103) {
		
				t = Task({
		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~c1 != nil) {
		~c1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~c1 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 2){
		if(~c2 != nil) {
		~c2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~c2 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 3){
		if(~c3 != nil) {
		~c3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~c3 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 4){
		if(~c4 != nil) {
		~c4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~c4 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
			
		};
		}); t.start;
			
		};
		
		if(id == 104) {
				t = Task({
		fork{
		2.wait;	/*"evaluation time"*/
		
		if(~count == 1){
		if(~d1 != nil) {
		~d1.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~d1 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 2){
		if(~d2 != nil) {
		~d2.set(\gate,classif);
		["synth A2  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait;
		~d2 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 3){
		if(~d3 != nil) {
		~d3.set(\gate,classif);
		["synth A3  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; 
		~d3 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
		
		if(~count == 4){
		if(~d4 != nil) {
		~d4.set(\gate,classif);
		["synth A4  off"].postln;
		x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
		4.wait; ~d4 = nil;  
		n.sendMsg("/tr", "recPlay 0");
		}};
			
		};
		}); t.start;
			
		};
		
		};	
		
		if(~func == 2 /*"set"*/){
		
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

		if(~func == 4 /*"send"*/){ 
			
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
	
}, "/trsm");
)



