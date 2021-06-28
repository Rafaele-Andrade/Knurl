SynthDef(\Ambience, { |out, gate = 1, amp = 0.1,  filter = 1 ,freq = 0.51, lin = 0, gatef = 1, gateamp = 1, gatefi = 1,gatelin = 1,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var freqs,sig,mult,ringa;


 	var linfreq = AnalogIn.ar(0).linlin(freq, 0.0,0.8, 0.14, 1.4);
 	var linamp = AnalogIn.ar(1).linlin(amp , 0.0,0.8, 0.02, 0.1);
	var linfi = AnalogIn.ar(0).linlin(filter , 0.0,0.8, 0.3, 1);
	var linlin = AnalogIn.ar(1).linlin(lin , 0.0,0.8, 0.02, 10.66);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(4, gateampl, 1.3), gate, doneAction:2);

	freqs = (#[146.83, 293.66,415.30])*gatefreq;
	ringa = rings*gatelinlin;

	sig = DynKlank.ar(`[freqs, amps, ringa], WhiteNoise.ar(gatefilter)*0.006,gatelinlin);
	Out.ar([0,1], sig*env)
}).add;


x = Synth(\Ambience);
x.set( \gatefi, 0 , \gatelin, 0)



SynthDef(\Ambience, { |out, gate = 1, amp = 0.1, specint = 1, filter = 1 ,freq = 0.51, lin = 1, gatef = 1, gateamp = 1, gatefi = 1, gatelin = 1,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var in, freqs, hasFreq,env,ampa,sig,mult,ringa;

 	var linfreq = MouseX.kr(0.14, 1.4);
 	var linamp = MouseY.kr( 0.02, 0.1);
	var linfilter = MouseX.kr( 0.3, 1);
	var linlin = MouseY.kr( 0.02, 10.66);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	freqs = (#[146.83, 293.66,415.30])*gatefreq;
	ringa = rings*gatelinlin;
	env = EnvGen.kr(Env.asr(4, gateampl, 1.3), gate, doneAction:2);
	sig = DynKlank.ar(`[freqs, amps, ringa], WhiteNoise.ar(gatefilter)*0.006,gatelinlin);

	Out.ar([0,1], sig*env)


}).add;





