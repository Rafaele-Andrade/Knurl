/***** osc_hybridsound.scd *****/
	
	SynthDef('blinker', {arg outPin, rate=1, seq= 4;
var env = EnvGen.kr( Env.new([1,0],[seq,1]),doneAction:1);
DigitalOut.ar(outPin, LFPulse.ar(rate)*env)
}).add;

SynthDef(\Rawsound, {|out=0, sus=0.45, cent=0, surface=0.0, sharp = 1 , tartini = 2.4694,freq=100, atk=0.02, amp=0.525, rel=2, lin=1,gate=1.0,curve=2,  specint = 1, filter=1, src=1|
	var freqT,hasFreq;
	var in1 = SoundIn.ar(2,amp);
	var in2 = SoundIn.ar(4,amp);
	var env = EnvGen.kr(Env.adsr(2, 1.29, 10, 3, 0.8, 2), gate, doneAction: 2);
	Out.ar([0,1], LPF.ar(Mix.new([in2, in1]),3000)*env!2) //9
}).add; 

//  SynthDef(\Rawsound, {|out=0, sus=0.45, cent=0, reflection = 0.1, surface=0.0, sharp = 1 , round = 0.17, tartini = 2.4694,freq=100, atk=0.02, amp=4, rel=2, lin=1,gate=1.0,curve=2,  specint = 1, filter=1, src=1|
// 	var mix;
// 	var in1 = SoundIn.ar(2,1);
// 	var in2 = SoundIn.ar(4,1);
// 	var freqT, hasFreq;
// 	var env = EnvGen.kr(Env.adsr(2, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
// 	#freqT, hasFreq = Pitch.kr(in2, ampThreshold: 0.07,median: 7);
// 	mix = Mix.new([in2,  in1]);
// 	Out.ar([0,1], in2*env)   //9
// }).add;

// SynthDef(\Raw, {|out=0, sus=0.45, surface=0.0, freq=100, atk=0.02, amp=10, rel=2, lin=1,gate=1.0,curve=2,  specint = 1, filter=1, src=1|
// 	var in = SoundIn.ar(2,amp);
// 	Out.ar([0,1], FreeVerb.ar(LPF.ar(in,5000),0.6,0.7,0.3,mul:1))
// }).add;





//color variations  SinOsc.ar(freqT/[4.4694 + cent],mul:0.047)*hasFreq, SinOsc.ar(freqT*[tartini + cent],mul:0.005)*hasFreq,

//altered tartini
//cents out  - cents 
//round sharp
//

 //RAW SOUND OF KNURL
 
 
 //FreeVerb
 //Colour
 //Loudness
 //par & impar harmonic enhance
 