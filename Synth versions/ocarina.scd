
(
SynthDef(\ocarina, {|freq=220, harmonics=0.5042, res=0.005, detune=1.1, strength=1|
	var n, f1, f2, f3, f4, sum, resonz;
	//f = SVF.ar(WhiteNoise.ar(0.5), freq, 0.99, 0, 1);

	n = WhiteNoise.ar(1);
	//n = PinkNoise.ar(1);

	resonz = Splay.arFill(4, { |i|
		Resonz.ar(n, freq*pow(i+1, harmonics), res) * pow(1 / (i+1), strength);
	}, 0, 50, 0, false);

/*	f1 = Resonz.ar(n, freq*(pow(1, harmonics)), res);
	f4 = Resonz.ar(n, freq*(pow(1, harmonics)) + detune, res);
	f2 = Resonz.ar(n, freq*(pow(2, harmonics)), res);
	f3 = Resonz.ar(n, freq*(pow(3, harmonics)), res);
	sum = f1 + f2 + f3 + f4;*/

	Out.ar([0, 1], resonz);

	//Out.ar([0, 1], [resonz, resonz]);
}).add;

// play the synth
~flute = Synth(\ocarina);
)

// adjust parameters
~flute.set(\freq, 155);  //freq
~flute.set(\harmonics, 0.5125);  //filter
~flute.set(\res, 0.005); // dont change
~flute.set(\detune, 34); // linlin
~flute.set(\strength, 3);  //mul

~flute.free;




(
SynthDef(\ocarina, {|freq=220, filter=0.5042, res=0.005, detune =1.1, mul = 1, strength=1, gate =1, gatef = 1, gateamp =1, gatefi=1, gatelin=1 |
	var n, f1, f2, f3, f4, sum, resonz;
	//f = SVF.ar(WhiteNoise.ar(0.5), freq, 0.99, 0, 1);

	var linfreq = AnalogIn.ar(0).linlin(0.0,0.7, 50,3000);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7, 0.02, 1);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7, 0.4, 2);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7, 0.1, 0.9);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var 	env = EnvGen.kr(Env.adsr(0, 1.29, linamp, 3, 0.8, 2), gate, doneAction: 2);

	n = WhiteNoise.ar(1);

	resonz = Splay.arFill(4, { |i|
		Resonz.ar(n, linfreq*pow(i+1, linfilter), res) * pow(1 / (i+1), strength);
	}, 0, 50, 0, false);


	Out.ar([0, 1], resonz*env);

	//Out.ar([0, 1], [resonz, resonz]);
}).add;

// play the synth
~flute = Synth(\ocarina);
)

// adjust parameters
~flute.set(\freq, 155);  //freq
~flute.set(\harmonics, 0.5125);  //filter
~flute.set(\res, 0.005); // dont change
~flute.set(\detune, 34); // linlin
~flute.set(\strength, 0.3);  //mul

~flute.free;