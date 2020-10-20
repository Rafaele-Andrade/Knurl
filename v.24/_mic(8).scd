/***** _mic.scd *****/

	
	SynthDef('blinker', {arg outPin, rate=1, seq= 4;
var env = EnvGen.kr( Env.new([1,0],[seq,1]),doneAction:1);
DigitalOut.ar(outPin, LFPulse.ar(rate)*env)
}).add;



// {DelayL.ar(SoundIn.ar([2,4],10),0, 0.7)}.play

{FreeVerb.ar(LPF.ar(SoundIn.ar([2,4],10),5000),0.6,0.7,0.3)}.play
 //DelayL.ar(source, linphase, XLine.kr(0.03, linsrc,60))