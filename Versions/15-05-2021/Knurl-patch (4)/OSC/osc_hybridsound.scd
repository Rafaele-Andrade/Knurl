/***** osc_hybridsound.scd *****/
	
	SynthDef('blinker', {arg outPin, rate=1, seq= 6;
    var env = EnvGen.kr( Env.new([1,0],[seq/2,1]),doneAction: 1); // sequencer is proportional to the rate
	DigitalOut.ar([0,2,4,8], LFPulse.ar(rate))
}).add;


  SynthDef(\Rawsound, {|out=0, freq=100, amp=2, lin=1, gate=1.0,   specint = 1,filter = 0.6|

	
	var amp1 = AnalogIn.ar(0).linlin(0,0.78,0.05, 1);
	var filt = AnalogIn.ar(1).linlin(0,0.78,100, 1000);	
		
	var in1 = SoundIn.ar([1],0.2);
	var in2 = SoundIn.ar([0],0.2);
	
	var comp1 = AmpComp.kr(freq, freq/1.2,0.5);
	

	Out.ar([0,1], [in1,in2]!2)   
}).add; 

 SynthDef('motor', {arg outPin, rate=1,gate = 1;

var	env = EnvGen.kr(Env.asr(0.1, 1.43, 0.7), gate, doneAction:2);
   
	DigitalOut.ar(outPin, Phasor.ar(SinOsc.ar(1000),1,0.15)*env)
	
	}).add;