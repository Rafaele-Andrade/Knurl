/***** osc_hybridsound.scd *****/
	
	SynthDef('blinker', {arg outPin, rate=1, seq= 6;
    var env = EnvGen.kr( Env.new([1,0],[seq/2,1]),doneAction: 1); // sequencer is proportional to the rate
	DigitalOut.ar([0,2,4,8], LFPulse.ar(rate))
}).add;

	
  SynthDef(\Rawsound, {|out=0, freq=100, amp=2, lin=1, gate=1.0,   specint = 1,filter = 0.6|

	
	var amp1 = AnalogIn.ar(DC.ar(0)).linlin(0,0.8,0,5); // preamp
	var filt = AnalogIn.ar(DC.ar(1)).linlin(0,0.8,0,20);  // preamp
		
	var in1 = LeakDC.ar(SoundIn.ar([0,1],2).mean);
	var in2 = LeakDC.ar(SoundIn.ar([0,1],1).mean);
 //[amp1,filt].poll(1);
	Out.ar(1, Limiter.ar(in2, 0.4));  // electronic
	Out.ar(0, Compander.ar(in1, mul:6))   // acoustic
}).add; 


 SynthDef('motor', {arg outPin, rate=1,gate = 1;

var	env = EnvGen.kr(Env.asr(0.1, 1, 0.7), gate, doneAction:2);
   
	DigitalOut.ar(outPin, AnalogIn.ar(DC.ar(1)).linlin(0,0.8,0.01,0.3)*env)
	
	}).add;
	

	
	
