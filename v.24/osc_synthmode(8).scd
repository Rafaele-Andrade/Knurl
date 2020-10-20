/***** osc_demo.scd *****/
/***** osc_demo.scd *****/
(

OSCdef(\synthmode, {|msg|
		// var id = msg[2], count = msg[3].asInt, mode = msg[4],dig = msg[5], red = msg[6], classif = msg[7],pot2 = msg[8];
		var id = msg[2], mode = msg[3],  count = msg[4].asInt,  classif = msg[5], dig = msg[6];
		var pot2 = classif;
		~dig = dig ;
		~count = count;
		~id = id;
		~mode = mode ;
		classif = LinLin.ar(classif,0,5,-1,-15);

		// ~pot2 = LinLin.kr(pot2, 30, 900, 0.3,1.3 );


		//mode,trg,bt,an,prm


						
if(~mode == 0, {
if(~id != 108,{   //amplitude changes
if (~dig == 1){   //avoid more than one trigger


// [id,~count,count,red].postln;
["sm:" ++ msg[2..]].postln;

if ( mode == 0,
// synth mode
{


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
										// ~fu = nil;
										// ["synth A1  off:" ++ classif].postln;

										x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
										// b.sendMsg("/tr", d.put("sm:", "on"));
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "recTrack 0");});
										d.cs;
										})},
							{ 	if(~a1 == nil, {
										(
										// c = Buffer.alloc( s, 5.0 * s.sampleRate, 1);
										q = Task({
										if(~rec == nil) {~rec= Synth(\record_my_voice)}; 6.wait; ~a1 = Synth(\recTrack);  ~worksynth  =~a1;  1.wait; t.stop; t.reset; });
										q.start
										);
										x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 8]);
										"synth A1  on".postln;
										~name = 'RecTrack'; 
										// b.sendMsg("/tr", "sm: A1 on");
										d.put("sm:", " A1 on" );
										if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "recTrack 1");});
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
									// b.sendMsg("/tr", d.put("sm:", "sm: A2  off")); d.cs;
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "recPlay 0");});
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
									// b.sendMsg("/tr", d.put("sm:", "sm: A2  on"));
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "recPlay 1");});

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
								// b.sendMsg("/tr", "sm: 3A" );
								// 0.4.wait;
								if(~a3 != nil, {
								if (~ampprepare != nil, { ~a3.set(\amp, ~amp); },{
								~ampprepare = nil;
								~a3.set(\gate, classif);
								 ~worksynth = ~a3;
								// b.sendMsg("/trsm", "sm: 3A off" ++ classif);
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SinS 0");});
								["sm A3 off:" ++ classif].postln;
								p = Task({fork{7.wait; ~a3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); }) },
									{ 	if(~a3 == nil, {
										~a3= Synth(\SinS);
										// b.sendMsg("/tr", "sm: 3A");
										~name = 'SinS';
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SinS 1");});
									"synth A3 on".postln;
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
								 //b.sendMsg("/tr", "sm: A4 off" ++ classif);
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "AudFeedback 0");});
								["sm: A4 off:" ++ classif].postln;
								p = Task({fork{4.wait; ~a4 = nil; 1.wait;p.reset; p.stop;}});
								p.start; x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); })},
								{ 	if(~a4 == nil, {
									~a4 = Synth(\AudFeedback);
									~name = 'AudFeedback';
									~worksynth = ~a4;
								"A4".postln;
								// b.sendMsg("/tr", "sm: A4 on"); x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]);
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "AudFeedback 1");});
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
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
					t = Task({

						fork{
						2.wait;


						if(~count == 1){
						// 0.4.wait;
						if(~b1 != nil,{
							if (~ampprepare != nil, { ~b1.set(\amp, ~amp); },{
							~ampprepare = nil;
							~b1.set(\gate, classif);
							// b.sendMsg("/tr", "sm: 1B off" ++ classif);
							["sm: B1 off:" ++ classif].postln;
							p = Task({fork{8.wait; ~b1 = nil; 1.wait;p.reset; p.stop;}});
							p.start;
							x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
							if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "FreqShift 0");});
						})
						},
						{ if(~b1 == nil, {
						~name = 'FreqShift';
						~b1 = Synth(\FreqShift);
						~worksynth = ~b1 ;
						"sm: 1B ON ".postln;
						// b.sendMsg("/tr", "sm: 1B on");
						x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 1]); }) }	);
						if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "FreqShift 1");});
						if (~ampprepare != nil, { ~b1.set(\amp, ~amp)}) ;
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

								if(~count == 2){
								// 0.4.wait;

								if(~b2 != nil, {
									if (~ampprepare != nil, { ~b2.set(\amp, ~amp); },{
									~ampprepare = nil;
									~b2.set(\gate, -4);
									// b.sendMsg("/tr", "sm: 2B off");
									["b2 off"++ classif].postln;
									p = Task({fork{4.wait; ~b2 = nil; 1.wait;p.reset; p.stop;}});
									p.start;
									x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Contra 0");});
									})
									},
									{ 	if(~b2== nil, {   
										~b2 = Synth(\Contra);  
										~worksynth = ~b2;	 
										// b.sendMsg("/tr", "sm: 2B on");
										"sm: B2 on".postln;
										~name = 'Contra';
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Contra 1");});
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
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Brass 0");});
									})
									},
								{ 	if(~b3 == nil, {   ~b3 = Synth(\Reus); 
								~name = 'Brass';
								~worksynth = ~a3;	
								// b.sendMsg("/tr", "sm: 3B on");
								"B3 on".postln;
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Brass 1");});
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
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Ambience 0");});
							})
						},  //long press
						{ 	if(~c1== nil, {   
						~c1 = Synth(\Ambience);
						~name = 'Ambience';
							 ~worksynth = ~c1;
							  //b.sendMsg("/tr", "sm: 1C on");
							  if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Ambin 1");});
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
					if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SawChoir 0");});
					// b.sendMsg("/tr", "sm: 2C off"); 
					x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); })},
						{ 	if(~c2 == nil, {
							~name = 'SawChoir';
							~c2 = Synth(~name);
							~worksynth = ~c2;
							// b.sendMsg("/tr", "sm: 2C on");
							if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SawChoir 1");});
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
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SinChoir 0");});
								p = Task({fork{4.wait; ~c3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
								})

								},
							{ 	if(~cc3 == nil, {   
								~c3 = Synth(\SinChoir);
							~name = 'SinChoir';
								~worksynth = ~c3;	
								// .sendMsg("/tr", "sm: 3C on");
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "SinChoir 1");});
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

					if(~count == 4, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.2.wait;
								if(~count == 4){
								// 0.4.wait;

								if(~c4 != nil,{
									if (~ampprepare != nil, { ~c4.set(\amp, ~amp); },{
									~ampprepare = nil;
									~c4.set(\gate,classif);
									// b.sendMsg("/tr", "sm: 4C off" ++ classif);
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "loca 0");});
								["4C off" ++ classif].postln;
								p = Task({fork{4.wait; ~c4 = nil; 1.wait;p.reset; p.stop;}});
								x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]); })},
							{ 	if(~c4 == nil, {
								~c4 = Synth(\Loca);
								~name = 'Loca';
								~worksynth = ~c4;
								// b.sendMsg("/tr", "sm: 4C on");
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "loca 1");});
								"4C on".postln;
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
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "BeatTrack 0");});
						["1D off" ++ classif].postln;
						p = Task({fork{4.wait; ~d1 = nil; 1.wait;p.reset; p.stop;}});
						p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]); })},
						{ 	if(~d1 == nil, { 
							~d1 = Synth(\BeatTrack); 
						~name = 'BeatTrack';
						~worksynth= ~d1;
							// b.sendMsg("/tr", "sm: 1D on");
							if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "BeatTrack 1");});
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
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "LFPulse 0");});
								["2D off" ++ classif].postln;
								p = Task({fork{4.wait; ~d2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]); }) },
								{ 	if(~d2 == nil, {
									 ~d2 = Synth(\LFPulse);
									~worksynth = ~d2;
									~name = 'LFPulse';
									// b.sendMsg("/tr", "sm: 2D on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "LFPulse 1");});
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
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Sequencer 0");});
								p = Task({fork{4.wait; ~d3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]); })},
								{ 	if(~d3 == nil, {   ~d3 = Synth(\Sequencer);
								~name = 'Sequencer';
									 ~worksynth = ~d3;
									// b.sendMsg("/tr", "sm: 3D on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Sequencer 1");});
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

					if(~count == 4 , {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.wait;
								if(~count == 4){
								// 0.4.wait;
								if(~d4 != nil,{
									if (~ampprepare != nil, { ~d4.set(\amp, ~amp); },{
									~ampprepare = nil;
									~d4.set(\gate, classif) ; 
									// b.sendMsg("/tr", "sm: 4D off" ++ classif);
								["4D off" ++ classif].postln;
								if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Moog 0");});
								p = Task({fork{4.wait; ~d4 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', ]); }) },
								{ 	if(~d4 == nil, {
									~d4 = Synth(\Moog);
									~name = 'Moog';
									~worksynth = ~d4;
									// b.sendMsg("/tr", "synth S on");
									if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/trigger", "Moog 1 ");});
								"4D ON".postln;
								x = Synth('blinker', ['outPin', 1, 'rate', 2, 'seq', 4]); }, {"sm: 4D on".postln}) }
								);  //short press

												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;
							});

						};


		// if(n != nil && ~worksynth != nil ,{n.sendMsg("/knurl/sm", ~worksynth);});


}
)

};

}, {  ~amp = LinLin.kr(pot2,40,180,0.7,3.7); ["amp:" ++ ~amp].postln; fork{~ampprepare = 1; "ampprepared".postln; 10.wait;~ampprepare = nil; "amp conventional".postln;} })   //amplitude is repgrogrammed
},{
	// b.sendMsg("/tr", d.put("sm:", "off");)
	
})}, "/trsm");
)




//~pot2 = count; ["amp:" ++ count].postln; fork{~ampprepare = 1;  10.wait;~ampprepare = nil} }