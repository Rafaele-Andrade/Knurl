/***** synth_analoguemode.scd *****/


//ps:
////attack more close to the triigger because it is analogue music!
(


SynthDef(\HPF,
		{
		arg gate =1,in1 = 2, in2 = 21, out1 = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1, mul = 1;
		var in, freqf,hasFreq,amp,sig,env;
		//freq	filter	rq	mul

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 0.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.17, 0.74);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 100, 300); 
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.001, 1);  //0.5   //here you might modify the freq and make Tartini effect (sums of 2 notes , become 3)

			in =  SoundIn.ar([2,4],3);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(3,  0.2, mul, 3, 0.8, 2), gate, doneAction: 2);
			amp = Amplitude.kr(in);
		sig =  HPF.ar(Saw.ar([linfreq*freqf], 1), FSinOsc.kr(XLine.kr(0.7, linfilter, 20), 0, 3600, 4000), 5);
			Out.ar([out1,out2],sig*env);
}).add;


SynthDef(\LPF,
		{
		arg gate =1,in1 = 20, in2 = 21, out1 = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1, mul = 1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 40, 400); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.37, 3.78);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50); 
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

			in =  SoundIn.ar([2,4],3);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(8, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
			amp = Amplitude.kr(in);
		sig =  LPF.ar(Saw.ar([linfreq*freqf],0.1), SinOsc.kr(XLine.kr(0.7,linfilter,20),0,360,linrq));
			Out.ar([out1,out2],sig*env);
}).add;



SynthDef(\Notch,
		{
		arg gate =1, in1 = 20, in2 = 21, out1 = 0, out2 = 1,ampin, freq = 1, filter = 1, rq = 1, mul =1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 1.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.01, 0.16);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 40, 400); 
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

			in =  SoundIn.ar([2,4],3);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(2,  0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
		sig =	Notch.ar(Ringz.ar(SinOsc.ar([linfreq*freqf])),freqf,linrq);
			Out.ar([out1,out2],Limiter.ar(sig*env,0.3));
}).add;

//cool but the output is chennel 1 & 2 ? TRY TO DEBUG FOR  &1

SynthDef(\BPF,
		{
		arg gate =1, in1 = 20, in2 = 21, out1 = 0, out2 = 1,ampin, freq = 1, filter = 1, rq = 1 , mul= 1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 0.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.17, 1.64);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 100, 300); //dd
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);   //0.5

			in =  SoundIn.ar([2,4],3);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(5,  0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
			sig =BPF.ar(Saw.ar([freqf*linfreq,freqf*0.3],0.5), FSinOsc.kr(XLine.kr(0.7,linfilter,20),0,3600,4000), linrq);
			Out.ar([out1,out2],sig*env);
}).add;

SynthDef(\Resonz,
		{
		arg gate =1,in1 = 20, in2 = 21, out1 = 0, out2 = 1, ampin, freq = 0.51, filter = 1, rq = 1, mul =1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq, 0.0,1, 0.001, 0.01); //0.3
	var linmul = LinLin.kr( mul, 0.0,1, 1.3, 6.14);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 100, 3000); 
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

			in =  SoundIn.ar(2,2);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.092,median: 7);
			env = EnvGen.kr(Env.adsr(2,  0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
			amp = Amplitude.kr(in);
			sig = Resonz.ar(LFTri.ar(Mix.new([linfreq*freqf,linfreq*freqf*1.2,linfreq*freqf*5.2])), linfilter, linrq, mul: hasFreq);
			Out.ar([out1,out2],sig*env);
}).add;


//updated in 13.10 (reason: Comb effect was not visible or usable, dont follow aesthethic of the osund, more how they can become a tool for the system)
SynthDef(\Comb,
		{
		arg gate =1,in1 = 10, in2 = 11, out1 = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1 ,mul= 1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 0.2); //0.3
	var linmul = LinLin.kr( mul, 0.0,1, 0.07, 0.0184);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.01, 0.71); 
		var linfreq = LinLin.kr(  freq , 0.0,1, 300, 1700);  //0.5

			in =  SoundIn.ar([2,4],3);
			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(2, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
			amp = Amplitude.kr(in);
		sig =  CombL.ar(Pulse.ar(0.3, mul: SinOsc.ar(30)), 0.3, 0.4, 5,0.71);
			Out.ar([out1,out2],sig*env);
}).add; 

// SynthDef(\Comb,
// 		{
// 		arg gate =1,in1 = 10, in2 = 11, out1 = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1 ,mul= 1;
// 		var in, freqf,hasFreq,amp,sig,env;

// 	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 2.2); //0.3
// 	var linmul = LinLin.kr( mul, 0.0,1, 0.07, 0.0184);  //2.2
// 	var linfilter = LinLin.kr(  filter , 0.0,1, 0.01, 0.71); 
// 	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //var linfreq = LinLin.kr(  freq , 0.0,1, 300, 1700);  //0.5

// 			in =  SoundIn.ar([2,4],3);
// 			#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
// 			env = EnvGen.kr(Env.adsr(2, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
// 			amp = Amplitude.kr(in);
// 		sig =  CombL.ar(LPF.ar(WhiteNoise.ar(0.3),linfreq), XLine.kr(0.0001, linfilter, 20), linrq);
// 			Out.ar([out1,out2],sig*env);
// }).add;
)
