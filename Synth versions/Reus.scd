SynthDef(\Reus, { arg gate = 1, atk=0.02, amp=2, rel=2, src = 3000, filter = 620, lin =1000, specint = 4;
	var pos1, pos2, sig1, sig2;
	var mix, t_trig, alert, env;
	sig1 = SoundIn.ar(0,1); //0
	sig2 = SoundIn.ar(1,1);  //1
	pos1 = AnalogIn.ar(3);  //4
	pos2 = AnalogIn.ar(5);

	t_trig = sig1 > 0.01;
	mix = EnvGen.ar(Env.perc, gate: t_trig) * Saw.ar(WhiteNoise.ar.range(100,1000), mul: 0.2);
	sig1 = LeakDC.ar(sig1);
	pos1 = HPF.ar(pos1, lin) * 100;
	//pos1 = pos1.lag(0.1);


	env = EnvGen.kr(Env.adsr(3, 0.01, amp, 3, 0.6, 2), gate, doneAction: 2);
	mix = [sig1,sig2] ;
	mix = LPF.ar(LPF.ar(mix, src), src) * 1;
	mix = mix;// + PitchShift.ar(mix, pitchRatio: specint);
	mix = mix * SinOsc.ar(filter*(pos1+1.0), mul: 1);
	// pos1.poll(1);
	Out.ar([0,1],Limiter.ar(mix*env,3));
}).add;



SynthDef(\Reus, { arg gate = 1, atk=0.02, amp=5, rel=2, src = 3000, filter = 620, lin =1000, specint = 4, gatef = 1, gateamp = 1, gatefi = 1 , gatelin= 1, freq = 1;
	var mix, t_trig, alert;

	var sig1 = SoundIn.ar(0,0.21); //0
	var sig2 = SoundIn.ar(1,0.21);  //1
	var pos1 = AnalogIn.ar(3);  // weird way to preamp
	var pos2 = AnalogIn.ar(5); // weird way to preamp

	var linfreq = AnalogIn.ar(0).linlin( 0.0,0.8, 300, 3000);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.8, 0.002, 3);
	var linfi = AnalogIn.ar(0).linlin( 0.0,0.8, 100, 620);
	var linlin = AnalogIn.ar(1).linlin( 0.0,0.8, 100, 1000);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(4, gateampl, 1.3), gate, doneAction:2);


	t_trig = sig1 > 0.01;
	mix = EnvGen.ar(Env.perc, gate: t_trig) * Saw.ar(WhiteNoise.ar.range(gatefilter,1000), mul: 0.2);
	sig1 = LeakDC.ar(sig1);
	pos1 = HPF.ar(pos1, gatelinlin) * 100;
	//pos1 = pos1.lag(0.1);

	mix = [sig1,sig2];
	mix = LPF.ar(LPF.ar(mix, gatefreq), gatefreq) ;
	mix = mix;
	mix = mix * SinOsc.ar(gatefilter*(pos1+1.0), mul: 1);
	// pos1.poll(1);
	Out.ar([0,1],Limiter.ar(mix*env,gateampl));
}).add;
