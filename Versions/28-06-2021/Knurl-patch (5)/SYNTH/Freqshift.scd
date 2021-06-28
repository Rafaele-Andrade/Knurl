
SynthDef(\FreqShift,{| in=0, out=0, feedback=0.4, lin=1, src=1, specint=1, gate = 1, amp = 1,filter =1,  gatef = 1, gateamp = 1, gatefi = 1 , gatelin= 1|
	var effect,env;

	var sig1 = SoundIn.ar(0,1); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 3.0;
	var sig2 = SoundIn.ar(1,1); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;//In.ar([2,4], 2);

	var linfreq = LinLin.kr(  specint , 0.0,1, 0.01, 0.14); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.3, 5);  //2.2
	var linfi = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 200, 2000); //1040.1

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	env = EnvGen.kr(Env.adsr(3, 0.01, gateampl, 3, 0.6, 2), gate, doneAction: 2);
	// effect = Mix.ar([sig1,sig2] ;//+ LocalIn.ar(1);
	effect = FreqShift.ar([sig1,sig2], LFNoise2.ar(gatefreq, linsrc));
	effect = DelayC.ar(effect, gatelinlin, GbmanN.ar(gatefilter).range(0.1,0.2));
	// LocalOut.ar(effect * feedback*env);
	Out.ar(1, Limiter.ar(effect*env, 0.4));
	Out.ar(0,effect*gateampl)
	}).add;