/***** synth_programmingmode.scd *****/

(


// RECORD
SynthDef('newvoice', { arg out = 0, bufnum = 0, inp = 0;
    var formant;
	formant = SoundIn.ar(inp,1);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).add;

	
	
// overdub
SynthDef('overdubb', { arg out=0, bufnum=0, gate= 2 ;
    var formant,playbuf,env,sig;
    
    var an1 = AnalogIn.ar(0).linlin(0,0.7,500,5000) ;
    var an2 = AnalogIn.ar(1).linlin(0,0.7,500,5000) ;
    
	formant = Formant.ar(XLine.kr(50, an1, 4), an2, 800, 0.125);

	env = EnvGen.kr(Env.adsr(0, 1.29, 1, 3, 0.8, 2), gate, doneAction: 2);
    playbuf = RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, loop: 1);
	sig = env * playbuf;
}).add;


// Simple sample
SynthDef('simplestream', { arg out=0, bufnum=0, gate = 1, amp = 1;  
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		
		var an1 = AnalogIn.ar(0).linlin(0,0.7,0,BufRateScale.kr(c.bufnum)) ;
		var an2 = AnalogIn.ar(1).linlin(0,0.7,0.1,1) ;
    
		env = EnvGen.kr(Env.adsr(0, 1.29, an2, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, an1, loop: 1.0);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;

// beatmaker	
	SynthDef('beatmaker', { arg out=0, bufnum=0, gate = 1, amp = 1;
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		
		var an1 = AnalogIn.ar(0).linlin(0,0.7,0.1,8) ;
		var an2 = AnalogIn.ar(1).linlin(0,0.7,0.1,BufRateScale.kr(c.bufnum)) ;
    
    
		in =  SoundIn.ar(0,1);
		#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7); 
		ampa = Amplitude.kr(in,mul:amp);
	trig = Impulse.kr( an1); //LinLin.kr(freqT,40,2000,0.5,20)); //MouseY.kr(0.5, 200, 1));
		env = EnvGen.kr(Env.adsr(2, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), trig, an2,10 , 1);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;
	
)