
SynthDef(\LFPulse,{ |gate = 1,amp =1,  filter = 1, lin = 1,  src = 1, specint = 1|
var in1, in2 ,freqT, hasFreq, a, b,signal,env, an,anm,linampa,ampa;
	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 23); //23
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 9.2);  //1.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50); //50
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.3);  //0.3
	var linsrc = LinLin.kr(  src , 0.0,1, 3, 20); //20

in1 = SoundIn.ar(0,1); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
in2 = SoundIn.ar(1,1); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 13.0; //not in use

#freqT, hasFreq = Pitch.kr(in1, ampThreshold: 0.02,median: 7);
freqT = freqT * hasFreq;
ampa = Amplitude.kr(in1);
linampa = LinLin.kr(ampa, 0.02,0.3, 0.01,0.7);
env = EnvGen.kr(Env.asr(2, linamp, 0.3), gate, doneAction:2);
a = SinOsc.ar([freqT, [freqT + linspecint ]*linampa]);
	b = SinOsc.ar(XLine.kr(4, linsrc,120));  //AnalogIn.ar(0)  b = SinOsc.ar(anm)
	rrand(a, b) * 1.81 ;
	signal = LPF.ar([b,in1],linfilter);
	OffsetOut.ar([0,1], signal*env!2);
}).add;