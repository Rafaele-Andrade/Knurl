/***** osc_hybridsound.scd *****/

	SynthDef('blinker', {arg outPin, rate=1, seq= 6;
    var env = EnvGen.kr( Env.new([1,0],[seq/2,1]),doneAction: 1); // sequencer is proportional to the rate
	DigitalOut.ar([0,2,4,8], LFPulse.ar(rate))
}).add;


  SynthDef(\Rawsound, {|out=0, freq=100, amp=2, lin=1, gate=1.0,   specint = 1,filter = 0.6|




	var amp1 = AnalogIn.ar(DC.ar(0)).linlin(0,0.8,0, 5);
	var amp2 = AnalogIn.ar(DC.ar(1)).linlin(0,0.8,0, 5);

	var in1 = LPF.ar(SoundIn.ar([1],2),500);
	var in2 = LPF.ar( SoundIn.ar([0],2),500);

	Out.ar([0,1], [in1,in2]!2)
}).add;

 SynthDef('motor', {arg outPin, rate=1,gate = 1;

var	env = EnvGen.kr(Env.asr(0.1, 1, 0.7), gate, doneAction:2);

	DigitalOut.ar(outPin, Phasor.ar(SinOsc.ar(1000),1,0.15)*env)

	}).add;
