SynthDef(\Ambience, { |out, gate = 1, amp = 0.1, specint = 1, filter = 1 ,freq = 0.51, lin = 1, gatef = 1, gateamp = 1, gatefi = 1, gatelin = 1,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var in, freqs, hasFreq,env,ampa,sig,mult,ringa;

 	var linfreq = LinLin.kr(freq,0.0,1, 0.14, 5.4);
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 0.08);
	var linfilter = LinLin.kr(filter, 0.0,1, 0.3, 1);
	var linlin = LinLin.kr(lin,0.0,1, 0.02, 0.66);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	freqs = (#[146.83, 293.66,415.30])*gatefreq;
	ringa = rings;
	env = EnvGen.kr(Env.asr(4, 0.21, 1.3), gate, doneAction:2);
	sig = SinOsc.ar([146.83, 293.66,415.30]*gatefreq, WhiteNoise.ar(gatefilter)*0.006, add: gatelinlin);

	Out.ar(0, (sig*env)*gateampl!2);
	Out.ar(1, Limiter.ar(sig*env, gateampl/3));

}).add;
