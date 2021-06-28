SynthDef(\Reus, { arg gate = 1, atk=0.02, amp=1, rel=2, src= 1, filter = 1, lin =1, specint = 4, gatef = 1, gateamp = 1, gatefi = 1 , gatelin= 1, freq = 1;
	var mix, t_trig, alert;

	var sig1 = SoundIn.ar(0,0.81); //0
	var sig2 = SoundIn.ar(1,0.81);  //1
	var pos1 = AnalogIn.ar(3);  // weird way to preamp
	var pos2 = AnalogIn.ar(5); // weird way to preamp

	var linfreq = LinLin.kr(freq, 0,1, 300, 3000);
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 3);
	var linfi = LinLin.kr(filter, 0.0,1, 100, 620);
	var linlin = LinLin.kr(lin, 0.0,1, 100, 1000);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(4, gateampl, 1.3), gate, doneAction:2);


	t_trig = sig1 > 0.01;
	mix = EnvGen.ar(Env.perc, gate: t_trig) * Saw.ar(WhiteNoise.ar.range(gatefilter,1000), mul: 0.2);
	sig1 = LeakDC.ar(sig1);
	pos1 = HPF.ar(pos1, gatelinlin) * 10;
	//pos1 = pos1.lag(0.1);

	mix = [sig1,sig2];
	mix = LPF.ar(LPF.ar(mix, gatefreq), gatefreq) ;
	mix = mix;
	mix = mix * SinOsc.ar(gatefilter*(pos1+1.0), mul: 1);
	// pos1.poll(1);
	Out.ar([0,1],Limiter.ar(mix*env,gateampl));
}).add;
