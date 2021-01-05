/***** osc_synthmode.scd *****/
(

OSCdef(\synthmode, {|msg|
		var id = msg[2], mode = msg[3], write = msg[4] , rewrite = msg[5], count = msg[6].asInt,  dig = msg[7], pot = msg[8].asInt, potdig = msg[9];
		var	classif = -4;
		
		~pot = pot;
		~dig = dig ;
		~count = count;
		~id = id;
		~mode = mode ;
		~write = write;
		~rewrite = rewrite;
		~potdig = pot;



if(~mode == 0 /*"sm"*/){ 
	
		if(~write == 0 /*"play"*/){  
		
		if((~id != 105) && (~id != 112),{ ["sm:" ++ msg[2..]].postln; n.sendMsg("/tr", ~count.cs);});   ///those are the analogue buttons, 
		

		
						//sc1
						if(id == 101) {
		
						if(~count == 1, {
		
									t = Task({
										fork{
										2.wait;
										if(~count == 1){
		
										// 0.4.wait;
										if(~a1 != nil, {
												if (~ampprepare != nil, { ~a1.set(\amp, ~amp); },{
												~ampprepare = nil;
												~a1.set(\gate, classif);
												p = Task({fork{4.wait; ~b = nil; 1.wait;p.reset; p.stop;}});
												p.start;
											
												x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
												
												n.sendMsg("/tr", "recTrack 0");
												d.cs;
												})},
									{ 	if(~a1 == nil, {
												(
												
												q = Task({
												if(~rec == nil) {~rec= Synth(\record_my_voice)}; 6.wait; ~a1 = Synth(\recTrack);  ~worksynth  = ~a1;  1.wait; t.stop; t.reset; });
												q.start
												);
												x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 8]);
												"synth A1  on".postln;
												~name = 'RecTrack'; 
												
												d.put("sm:", " A1 on" );
												n.sendMsg("/tr", "recTrack 1");
												d.cs
											}) }
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
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]); }) }
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
										p.start; x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); })},
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
		
		
						//sc2
						if(id == 102) {
	
						if(~count == 1, {
					t = Task({

						fork{
						2.wait;


						if(~count == 1){
						// 0.4.wait;
						if(~b1 != nil,{
							if (~ampprepare != nil, { ~b1.set(\amp, ~amp); },{
							~ampprepare = nil;
							~b1.set(\gate, classif);
							["sm: B1 off:" ++ classif].postln;
							p = Task({fork{2.wait; ~b1 = nil; 1.wait;p.reset; p.stop;}});
							p.start;
							x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
						n.sendMsg("/knurl/tr", "FreqShift 0" ++ classif);
						
						})
						},
						{ if(~b1 == nil, {
						~name = 'FreqShift';
						~b1 = Synth(\FreqShift);
						~worksynth = ~b1 ;
						"sm: 1B ON ".postln;
					
						x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) }	);
						n.sendMsg("/tr", "FreqShift 1");
						if (~ampprepare != nil, { ~b1.set(\amp, ~amp)}) ;
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
											if (~ampprepare != nil, { ~b2.set(\amp, ~amp); },{
											~ampprepare = nil;
											~b2.set(\gate, -4);
											
											["b2 off"++ classif].postln;
											p = Task({fork{4.wait; ~b2 = nil; 1.wait;p.reset; p.stop;}});
											p.start;
											x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
											n.sendMsg("/tr", "Contra 0");
										
											
											})
											},
											{ 	if(~b2== nil, {   
												~b2 = Synth(\Contra);  
												~worksynth = ~b2;	 
										
												"sm: B2 on".postln;
												~name = 'Contra';
										if(n != nil){n.sendMsg("/tr", "Contra 1") };
						
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
		
							// if(~count == 4, {
							// 	// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							// 		t = Task({
		
							// 			fork{
							// 			1.2.wait;
							// 					if(~count == 4){
							// 			// 0.4.wait;
							// 					if(~b4 != nil,{
							// 						if (~ampprepare != nil, { ~b4.set(\amp, ~amp); },{
							// 						~ampprepare = nil;
							// 						~b4.set(\gate, classif) ;
							// 						// b.sendMsg("/tr", "sm: 4B Off"++ classif);
							// 						["B4 off"++ classif].postln;
							// 						p = Task({fork{4.wait; ~b4 = nil; 1.wait;p.reset; p.stop;}});
							// 						p.start;
							// 						x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]);
							// 						if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Hildur 0");});
							// 						})
							// 						},
							// 			{ 	if(~b4 == nil, {   
							// 				~b4 = Synth(\Hildur);
							// 			~name = 'Hildur';
							// 			~worksynth = ~a4;	
							// 			// b.sendMsg("/tr", "sm: 4B ON");
							// 			if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Hildur 1");});
							// 			"B4 on".postln;
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
		
						//sc3
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
									  n.sendMsg("/tr", "Ambin 1");
									  //if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Ambin 1"); n.sendMsg("/tr", "Ambin 1")});
								"1C on".postln;
								x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) });
									1.wait;
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
									~c2 = Synth(~name);
									~worksynth = ~c2;
									// b.sendMsg("/tr", "sm: 2C on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "SawChoir 1");});
								"2C on".postln;
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
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "LFPulse 0");});
										["2D off" ++ classif].postln;
										p = Task({fork{4.wait; ~d2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); }) },
										{ 	if(~d2 == nil, {
											 ~d2 = Synth(\LFPulse);
											~worksynth = ~d2;
											~name = 'LFPulse';
											// b.sendMsg("/tr", "sm: 2D on");
											if(n != nil && ~worksynth != nil ,{n.sendMsg("/tr", "LFPulse 1");});
																"2D on".postln;
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
		
		if(~write == 1 /*"stop"*/){ };	
		
		if(~write == 2 /*"rewrite"*/){
			
		// "rewrite sm".postln;
		};
		
		if(~write == 3 /*"set"*/){
			
		// "set sm".postln;
			//101 - var
			//102 - data
			//103 - fade 
			//104 - color
			
			if(~id == 101){ ~reprAn = 'amp'.asSymbol; "set amp".postln;};
			if(~id == 102){ ~reprAn = 'data'.asSymbol; "set data".postln;};
			if(~id == 103){ ~reprAn = 'fade'.asSymbol; "set fade".postln;};
			if(~id == 104){ ~reprAn = 'color'.asSymbol; "set color".postln; };
		
	
			
		if(~id == 108){  //pot 1
	
			if(~reprAn == 'amp') {    //stop one synth
			if(~potdig != 0){
			t = Task({
			fork{
				//select
			~amp = LinLin.kr(~potdig, 1,8, 0.1,26 ); //~pot; //
			["amp sel:" ++ ~amp].postln; // n.sendMsg("/tr", d.cs); 
			 n.sendMsg("/tr", "amp sel:" ++ ~amp);
					
				//evaluate
				1.wait; 
				if(~reprAn == 'amp'){
				if(~potdig != 0){
					// if(~blockamp == nil){ fork{ . 1.wait; ~blockamp = nil}}   ///a block message for multiple messages being triggered
			["amp is:" ++ ~amp].postln; 
			n.sendMsg("/tr", "amp is:" ++ ~amp); 
			
			
			//connect
			if(~a1 != nil){~a1.set(\amp, ~amp); };
			if(~a2 != nil){~a2.set(\amp, ~amp); };
			if(~a3 != nil){~a3.set(\amp, ~amp); };
			if(~a4 != nil){~a4.set(\amp, ~amp); };
			
			if(~b1 != nil){~b1.set(\amp, ~amp); };
			if(~b2 != nil){~b2.set(\amp, ~amp); };
			if(~b3 != nil){~b3.set(\amp, ~amp); };
			
			if(~c1 != nil){~c1.set(\amp, ~amp); };
			if(~c2 != nil){~c2.set(\amp, ~amp); };
			if(~c3 != nil){~c3.set(\amp, ~amp); };
			
			if(~d1 != nil){~d1.set(\amp, ~amp); };
			if(~d2 != nil){~d2.set(\amp, ~amp); };
			if(~d3 != nil){~d3.set(\amp, ~amp); };
					}};
			}});
				t.reset;
				t.start;
			}
					};
					
					
			if(~reprAn == 'fade') {    //stop one synth
			if(~potdig != 0){
			t = Task({
			fork{
				//select
			~fade = LinLin.kr(~pot, ~minrangecap,~maxrangecap, -1,-8 ); //~pot; //
			["fade sel:" ++ ~fade].postln; // n.sendMsg("/tr", d.cs); 
					
				//evaluate
				1.wait; 
				if(~reprAn == 'fade'){
				if(~potdig != 0){
					
			["fade is:" ++ ~amp].postln; // n.sendMsg("/tr", d.cs); 
			//connect
			if(~a1 != nil){~a1.set(\gate, ~fade); };
			if(~a2 != nil){~a2.set(\gate, ~fade); };
			if(~a3 != nil){~a3.set(\gate, ~fade); };
			if(~a4 != nil){~a4.set(\gate, ~fade); };
			
			if(~b1 != nil){~b1.set(\gate, ~fade); };
			if(~b2 != nil){~b2.set(\gate, ~fade); };
			if(~b3 != nil){~b3.set(\gate, ~fade); };
			
			if(~c1 != nil){~c1.set(\gate, ~fade); };
			if(~c2 != nil){~c2.set(\gate, ~fade); };
			if(~c3 != nil){~c3.set(\gate, ~fade); };
			
			if(~d1 != nil){~d1.set(\gate, ~fade); };
			if(~d2 != nil){~d2.set(\gate, ~fade); };
			if(~d3 != nil){~d3.set(\gate, ~fade); };
					}};
			}});
				t.reset;
				t.start;
			}
					};
					
					
			if(~reprAn == 'data') {    //stop one synth
			//rewrite switch 
					};
					
			if(~reprAn == 'color') {    //stop one synth
			if(~potdig != 0){
			t = Task({
			fork{
				//select
			~color = LinLin.kr(~pot,~minrangecap,~maxrangecap, -1,-8 ); //~pot; //
			["fade sel:" ++ ~color].postln; // n.sendMsg("/tr", d.cs);

				//evaluate
				1.wait;
				if(~reprAn == 'color'){
				if(~potdig != 0){

			["color set:" ++ ~reprRewritevar].postln; // n.sendMsg("/tr", d.cs);

//connect
			if(~reprRewritevar ==  'Altered Tartini')	{

			if(~a1 != nil){~a1.set(\tartini, ~color); };
			if(~a2 != nil){~a2.set(\tartini, ~color); };
			if(~a3 != nil){~a3.set(\tartini, ~color); };
			if(~a4 != nil){~a4.set(\tartini, ~color); };

			if(~b1 != nil){~b1.set(\tartini, ~color); };
			if(~b2 != nil){~b2.set(\tartini, ~color); };
			if(~b3 != nil){~b3.set(\tartini, ~color); };

			if(~c1 != nil){~c1.set(\tartini, ~color); };
			if(~c2 != nil){~c2.set(\tartini, ~color); };
			if(~c3 != nil){~c3.set(\tartini, ~color); };

			if(~d1 != nil){~d1.set(\tartini, ~color); };
			if(~d2 != nil){~d2.set(\tartini, ~color); };
			if(~d3 != nil){~d3.set(\tartini, ~color); };

			};
			
			if(~reprRewritevar ==  'Cents out')	{

			if(~a1 != nil){~a1.set(\cent, ~color); };
			if(~a2 != nil){~a2.set(\cent,~color); };
			if(~a3 != nil){~a3.set(\cent, ~color); };
			if(~a4 != nil){~a4.set(\cent, ~color); };

			if(~b1 != nil){~b1.set(\cent, ~color); };
			if(~b2 != nil){~b2.set(\cent, ~color); };
			if(~b3 != nil){~b3.set(\cent, ~color); };

			if(~c1 != nil){~c1.set(\cent, ~color); };
			if(~c2 != nil){~c2.set(\cent, ~color); };
			if(~c3 != nil){~c3.set(\cent, ~color); };

			if(~d1 != nil){~d1.set(\cent, ~color); };
			if(~d2 != nil){~d2.set(\cent, ~color); };
			if(~d3 != nil){~d3.set(\cent, ~color); };

			};
			
			if(~reprRewritevar ==  'Space')	{

			if(~a1 != nil){~a1.set(\reflection, ~color); };
			if(~a2 != nil){~a2.set(\reflection, ~color); };
			if(~a3 != nil){~a3.set(\reflection, ~color); };
			if(~a4 != nil){~a4.set(\reflection, ~color); };

			if(~b1 != nil){~b1.set(\reflection, ~color); };
			if(~b2 != nil){~b2.set(\reflection, ~color); };
			if(~b3 != nil){~b3.set(\reflection, ~color); };

			if(~c1 != nil){~c1.set(\reflection, ~color); };
			if(~c2 != nil){~c2.set(\reflection, ~color); };
			if(~c3 != nil){~c3.set(\reflection, ~color); };

			if(~d1 != nil){~d1.set(\reflection, ~color); };
			if(~d2 != nil){~d2.set(\reflection, ~color); };
			if(~d3 != nil){~d3.set(\reflection, ~color); };

			};
			
			if(~reprRewritevar ==  'Round or sharp')	{

			if(~a1 != nil){~a1.set(\round, ~color); };
			if(~a2 != nil){~a2.set(\round,~color); };
			if(~a3 != nil){~a3.set(\round, ~color); };
			if(~a4 != nil){~a4.set(\round, ~color); };

			if(~b1 != nil){~b1.set(\round, ~color); };
			if(~b2 != nil){~b2.set(\round, ~color); };
			if(~b3 != nil){~b3.set(\round, ~color); };

			if(~c1 != nil){~c1.set(\round, ~color); };
			if(~c2 != nil){~c2.set(\round, ~color); };
			if(~c3 != nil){~c3.set(\round, ~color); };

			if(~d1 != nil){~d1.set(\round, ~color); };
			if(~d2 != nil){~d2.set(\round, ~color); };
			if(~d3 != nil){~d3.set(\round, ~color); };

			};
			
					}};
			}});
				t.reset;
				t.start;
			}
					};
					
					
		
		if(~id == 108){   //rewrite var
		
			if(~reprAn == 'color'){ 
		
		if( ~rewrite == 1 ){~reprRewritevar = 'Altered Tartini'};
		if( ~rewrite == 2 ){~reprRewritevar = 'Cents out'};
		if( ~rewrite == 3 ){~reprRewritevar = 'Space'};
		if( ~rewrite == 4 ){~reprRewritevar = 'Round or sharp' };
		
		};
		};
		
};
}
};
	
}, "/trsm");
)



