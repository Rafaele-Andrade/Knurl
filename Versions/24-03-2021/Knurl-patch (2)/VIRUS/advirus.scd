/***** advirus.scd *****/
//Receive mannipulation

thisProcess.openUDPPort(6000); 				//receiveport

m = NetAddr.new("192.168.1.146", 8000 );    //rafa  - knurl live coding   + remote mercury conection  //ethernet

o = NetAddr.new("192.168.6.1", 8000 );   //timo - local

fork{ loop{ m.sendMsg('/knurl/healthcheck', "I'm fine, playing well!");  1.wait}};  //"vai".postln;
fork{ loop{ o.sendMsg('/knurl/healthcheck', "I'm fine, playing well!");  1.wait}};  //"vai".postln;


(

OSCdef.new(\virusset, { arg msg,time,addr,port;

	var synth = msg[1].asSymbol;   	// variable = [ "\" ++ variable ++ "'"];
	var variable = msg[2].asSymbol;   // sm,pm,am,dm // for letters
	var prm = msg[3].asFloat;       //1,2,3,4  
	
	~variable = variable;
	~prm = prm;
	~name = synth; 
	// 1) trigerring variations of the previous synth.
	//  \knurl reverb 0.1
	// [synth,~variable,~prm].postln;
	// ~worksynth.set(~variable, ~prm);
 	 //if(~synth != ~changerec, { Synth(~synth,[~variable, ~prm] );  m.sendMsg('/knurl/health', ~synth, ~variable , ~prm); ~changerec = ~synth});    //"vai".postln; //~worksynth.postln;

[~name, ~state].postln;

if( (~name == 'RecTrack') && (~a1 != nil ),{~a1.set(~variable, ~prm); });
if( (~name == 'RecPlay') && (~a2 != nil ),{~a2.set(~variable, ~prm); });
if( (~name == 'AudFeedback') && (~a3 != nil ),{~a3.set(~variable, ~prm); });
if( (~name == 'SinS') && (~a4 != nil ),{~a4.set(~variable, ~prm); });
if( (~name == 'FreqShift') && (~b1 != nil ),{~b1.set(~variable, ~prm)});
if( (~name == 'Contra') && (~b2 != nil ),{~b2.set(~variable, ~prm)});
if( (~name == 'Reus') && (~b3 != nil ),{~b3.set(~variable, ~prm)});
if( (~name == 'Hildur') && (~b4 != nil ),{~b4.set(~variable, ~prm)});
if( (~name == 'Ambience') && (~c1 != nil ),{~c1.set(~variable, ~prm)});
if( (~name == 'SawChoir') && (~c2 != nil ),{~c2.set(~variable, ~prm)});
if( (~name == 'SinChoir') && (~c3 != nil ),{~c3.set(~variable, ~prm)});
if( (~name == 'Loca') && (~c4 != nil ),{~c4.set(~variable, ~prm)});
if( (~name == 'BeatTrack') && (~d1 != nil ),{~d1.set(~variable, ~prm)});
if( (~name == 'LFPulse') && (~d2 != nil ),{~d2.set(~variable, ~prm)});
if( (~name == 'Sequencer') && (~d3 != nil ),{~d3.set(~variable, ~prm)});
if( (~name == 'Moog') && (~d4 != nil ),{~d4.set(~variable, ~prm)});


//Analogue mode
if( (~name == 'HPF') && (~am1 != nil ),{~am1.set(~variable, ~prm)});
if( (~name == 'LPF') && (~am2 != nil ),{~am2.set(~variable, ~prm)});
if( (~name == 'Notch') && (~am3 != nil ),{~am3.set(~variable, ~prm)});
if( (~name == 'Comb') && (~am4 != nil ),{~am4.set(~variable, ~prm)});
if( (~name == 'BPF') && (~am5 != nil ),{~am5.set(~variable, ~prm)});
if( (~name == 'Resonz') && (~am6 != nil ),{~am6.set(~variable, ~prm)});

//de mode
if( (~name == 'Gap') && (~dm1 != nil ),{~dm1.set(~variable, ~prm)});
if( (~name == 'Res') && (~dm2 != nil ),{~dm2.set(~variable, ~prm)});
if( (~name == 'Friction') && (~dm3 != nil ),{~dm3.set(~variable, ~prm)});
if( (~name == 'Converb') && (~dm4 != nil ),{~dm4.set(~variable, ~prm)});
if( (~name == 'Reverb') && (~dm5 != nil ),{~dm5.set(~variable, ~prm)});
if( (~name == 'Formlet') && (~dm6 != nil ),{~dm6.set(~variable, ~prm)});
if( (~name == 'Delay') && (~dm7 != nil ),{~dm7.set(~variable, ~prm)});



//	if(~shift == ~name)
}, '/knurl/change');


OSCdef.new(\virustrg, { arg msg,time,addr,port;


	var synth = msg[1].asSymbol ;   // sm,pm,am,dm // for letters
	var state = msg[2].asInt;         //1,2,3,4

	
	~name = synth;
	~state = state;
	
	//knurl trig
	// if (~state == 1 && ~synthrec == nil,{	[synth, state].postln;  Synth(~namesynth); n.sendMsg('/knurl/health', ~synth, ~variable , ~prm); fork{~synthrec = 1; 3.wait; ~synthrec =nil}}); // to avoid rewrite 
	// if(~state == 0,{ Synth(~namesynth, [\gate,-3]);});
	
[~name, ~state].postln;
//off
if((~state == 0) && (~name == 'RecTrack') && (~a1 != nil ),{~a1.set(\gate,-3);});
if((~state == 0) && (~name == 'RecPlay') && (~a2 != nil ),{~a2.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'AudFeedback') && (~a3 != nil ),{~a3.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'SinS') && (~a4 != nil ),{~a4.set(\gate,-3);  });

if((~state == 0) && (~name == 'FreqShift') && (~b1 != nil),{
~b1.set(\gate,-3); 
p = Task({fork{2.wait; ~b1 = nil; 1.wait;p.reset; p.stop;}});
p.start;
"hey".postln });
if(( ~state == 0) && (~name == 'Contra') && (~b2 != nil ),{~b2.set(\gate,-3); 
p = Task({fork{2.wait; ~b2 = nil; 1.wait;p.reset; p.stop;}});
p.start;
});
if(( ~state == 0) && (~name == 'Reus') && (~b3 != nil ),{~b3.set(\gate,-3); 
p = Task({fork{2.wait; ~b3 = nil; 1.wait;p.reset; p.stop;}});
p.start;
});
if(( ~state == 0) && (~name == 'Hildur') && (~b4 != nil ),{~b4.set(\gate,-3);  
p = Task({fork{2.wait; ~b4 = nil; 1.wait;p.reset; p.stop;}});
p.start;
});
if(( ~state == 0) && (~name == 'Ambience') && (~c1 != nil ),{~c1.set(\gate,-3); 
p = Task({fork{2.wait; ~c1 = nil; 1.wait;p.reset; p.stop;}});
p.start; });
if(( ~state == 0) && (~name == 'SawChoir') && (~c2 != nil ),{~c2.set(\gate,-3); 
p = Task({fork{2.wait; ~c2 = nil; 1.wait;p.reset; p.stop;}});
p.start;
});
if(( ~state == 0) && (~name == 'SinChoir') && (~c3 != nil ),{~c3.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Loca') && (~c4 != nil ),{~c4.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'BeatTrack') && (~d1 != nil ),{~d1.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'LFPulse') && (~d2 != nil ),{~d2.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Sequencer') && (~d3 != nil ),{~d3.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Moog') && (~d4 != nil ),{~d4.set(\gate,-3);  });

//Analogue mode
if(( ~state == 0) && (~name == 'HPF') && (~am1 != nil ),{~am1.set(\gate,-3)});
if(( ~state == 0) && (~name == 'LPF') && (~am2 != nil ),{~am2.set(\gate,-3)});
if(( ~state == 0) && (~name == 'Notch') && (~am3 != nil ),{~am3.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Comb') && (~am4 != nil ),{~am4.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'BPF') && (~am5 != nil ),{~am5.set(\gate,-3)});
if(( ~state == 0) && (~name == 'Resonz') && (~am6 != nil ),{~am6.set(\gate,-3);  });

//de mode
if(( ~state == 0) && (~name == 'Gap') && (~dm1 != nil ),{~dm1.set(\gate,-3)});
if(( ~state == 0) && (~name == 'Res') && (~dm2 != nil ),{~dm2.set(\gate,-3)});
if(( ~state == 0) && (~name == 'Friction') && (~dm3 != nil ),{~dm3.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Converb') && (~dm4 != nil ),{~dm4.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Reverb') && (~dm5 != nil ),{~dm5.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Formlet') && (~dm6 != nil ),{~dm6.set(\gate,-3);  });
if(( ~state == 0) && (~name == 'Delay') && (~dm7 != nil ),{~dm7.set(\gate,-3);  });


//on
if((~state == 1) && (~name == 'RecTrack') && (~a1 == nil ),{~a1 = Synth(\RecTrack); });
if((~state == 1) && (~name == 'RecPlay') && (~a2 == nil ),{~a2 = Synth(\RecPlay); });
if(( ~state == 1) && (~name == 'AudFeedback') && (~a3 == nil ),{~a3 = Synth(\AudFeedback); });
if(( ~state == 1) && (~name == 'SinS') && (~a4 == nil ),{~a4 = Synth(\Sins); });
if((~state == 1) && (~name == 'FreqShift') && (~b1 == nil),{~b1 = Synth(\FreqShift); "heyaa".postln });
if(( ~state == 1) && (~name == 'Contra') && (~b2 == nil ),{~b2 = Synth(\Contra); });
if(( ~state == 1) && (~name == 'Reus') && (~b3 == nil ),{~b3 = Synth(\Reus); });
if(( ~state == 1) && (~name == 'Hildur') && (~b4 == nil ),{~b4 = Synth(\Hildur); });
if(( ~state == 1) && (~name == 'Ambience') && (~c1 == nil ),{~c1 = Synth(\Ambience); });
if(( ~state == 1) && (~name == 'SawChoir') && (~c2 == nil ),{~c2 = Synth(\SawChoir); });
if(( ~state == 1) && (~name == 'SinChoir') && (~c3 == nil ),{~c3 = Synth(\SinChoir); });
if(( ~state == 1) && (~name == 'Loca') && (~c4 == nil ),{~c4 = Synth(\Loca); });
if(( ~state == 1) && (~name == 'BeatTrack') && (~d1 == nil ),{~d1 = Synth(\BeatTrack); });
if(( ~state == 1) && (~name == 'LFPulse') && (~d2 == nil ),{~d2 = Synth(\LFPulse); });
if(( ~state == 1) && (~name == 'Sequencer') && (~d3 == nil ),{~d3 = Synth(\Sequencer); });
if(( ~state == 1) && (~name == 'Moog') && (~d4 == nil ),{~d4 = Synth(\Moog); });


//Analogue mode
if(( ~state == 1) && (~name == 'HPF') && (~am1 == nil),{~am1 = Synth(\HPF); });
if(( ~state == 1) && (~name == 'LPF') && (~am2 == nil),{~am2 = Synth(\LPF); });
if(( ~state == 1) && (~name == 'Notch') && (~am3 == nil),{~am3 = Synth(\Notch); });
if(( ~state == 1) && (~name == 'Comb') && (~am4 == nil),{~am4 = Synth(\Comb); });
if(( ~state == 1) && (~name == 'BPF') && (~am5 == nil),{~am5 = Synth(\BPF); });
if(( ~state == 1) && (~name == 'Resonz') && (~am6 == nil),{~am6 = Synth(\Resonz); });

//de mode
if(( ~state == 1) && (~name == 'Gap') && (~dm1 == nil),{~dm1 = Synth(\Gap); });
if(( ~state == 1) && (~name == 'Res') && (~dm2 == nil),{~dm2 = Synth(\Res); });
if(( ~state == 1) && (~name == 'Friction') && (~dm3 == nil),{~dm3 = Synth(\Friction); });
if(( ~state == 1) && (~name == 'Converb') && (~dm4 == nil),{~dm4 = Synth(\Converb); });
if(( ~state == 1) && (~name == 'Reverb') && (~dm5 == nil),{~dm5 = Synth(\Reverb); });
if(( ~state == 1) && (~name == 'Formlet') && (~dm6 == nil),{~dm6 = Synth(\Formlet); });
if(( ~state == 1) && (~name == 'Delay') && (~dm7 == nil),{~dm7 = Synth(\Delay); });

    
}, '/knurl/trigger');

// OSCdef.new(\virussch, { arg msg,time,addr,port;

// 	var plan = msg[1];   // sm,pm,am,dm // for letters
// 	var prm = msg[2].asFloat;         //1,2,3,4

// 	// 2) Schedulling the coming events
// 	//  /knurl plan 6
// 	if(msg != msg){
// 	if( ~tasktime != nil ){ ~tasktime = prm};
// 		// [variable,prm].postln
// 	}

// }, 'knurl/schedule');

);
