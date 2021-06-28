

// sins

SynthDef(\SinOsc,
		{
		arg gate = 1,in = 0, out = 0, ampin, freq = 1, filter = 1, rq = 1, mul = 1;

	var linrq = LinLin.kr( rq , 0.0,1, 40, 400); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.37, 3.78);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

	var sig = SinOsc.ar(linfreq);
	var env = EnvGen.kr(Env.adsr(8, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);


	Out.ar(out,sig*env);
}).add;


SynthDef(\Saw,
		{
		arg gate = 1,in = 0, out = 0, ampin, freq = 1, filter = 1, rq = 1, mul = 1;

	var linlin = LinLin.kr( rq , 0.0,1, 40, 400); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.37, 3.78);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 100);  //0.5

	var sig = LFSaw.ar(linfreq,linlin, linfilter);
	var env = EnvGen.kr(Env.adsr(8, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);


		Out.ar(out,sig*env);
}).add;


Synth(\Saw)

SynthDef(\LFPulse,
		{
		arg gate = 1,in = 0, out = 0, ampin, freq = 1, filter = 1, rq = 1, mul = 1;

	var linlin = LinLin.kr( rq , 0.0,1, 40, 400); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.37, 3.78);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

	var sig = LFPulse.ar(linfreq,linlin, linfilter);
	var env = EnvGen.kr(Env.adsr(8, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);

	Out.ar(out,sig*env);
}).add;

//range and source




SynthDef(\HPF,
		{
		arg gate =1,in = 0, in2 = 21, out = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1, mul = 1;

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 0.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.17, 0.74);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 100, 300);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.001, 1);  //0.5

	var env = EnvGen.kr(Env.adsr(3,  0.2, mul, 3, 0.8, 2), gate, doneAction: 2);

		var sig =  HPF.ar(In.ar(), freq, mul: );
		Out.ar(out,sig*env!2);
}).add;




SynthDef(\HPF,
		{
		arg gate =1,in = 0, in2 = 21, out = 0, out2 = 1, ampin, freq = 1, filter = 1, rq = 1, mul = 1;
		var input, freqf,hasFreq,amp,sig,env;
		//freq	filter	rq	mul

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 0.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.17, 0.74);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 100, 300);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.001, 1);  //0.5

			input =  In.ar(in,3).mean;
			#freqf, hasFreq = Pitch.kr(input,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(3,  0.2, mul, 3, 0.8, 2), gate, doneAction: 2);
		    sig =  HPF.ar(Saw.ar([linfreq*freqf], 1), FSinOsc.kr(XLine.kr(0.7, linfilter, 20), 0, 3600, 4000), 5);

			Out.ar(out,sig*env!2);
}).add;


SynthDef(\LPF,
		{
		arg gate = 1,in = 0, out = 0, ampin, freq = 1, filter = 1, rq = 1, mul = 1;
		var input, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 40, 400); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.37, 3.78);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

	input =  In.ar(input,2);
	#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);

	env = EnvGen.kr(Env.adsr(8, 0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);

	sig =  LPF.ar(Saw.ar([linfreq*freqf],0.1), SinOsc.kr(XLine.kr(0.7,linfilter,20),0,360,linrq));

	Out.ar(out,sig*env);
}).add;



SynthDef(\Notch,
		{
		arg gate =1, in1 = 20, in2 = 21, out1 = 0, out2 = 1,ampin, freq = 1, filter = 1, rq = 1, mul =1;
		var in, freqf,hasFreq,amp,sig,env;

	var linrq = LinLin.kr( rq , 0.0,1, 0.01, 1.3); //0.3
	var linmul = LinLin.kr( mul , 0.0,1, 0.01, 0.16);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 40, 400);
	var linfreq = LinLin.kr(  freq , 0.0,1, 0.01, 1);  //0.5

	in =  In.ar([0,1],3);
	#freqf, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7);
			env = EnvGen.kr(Env.adsr(2,  0.2, linmul, 3, 0.8, 2), gate, doneAction: 2);
		sig =	Notch.ar(Ringz.ar(SinOsc.ar([linfreq*freqf])),freqf,linrq);
			Out.ar([out1,out2],Limiter.ar(sig*env,0.3));
}).add;

Synth(\Notch)

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