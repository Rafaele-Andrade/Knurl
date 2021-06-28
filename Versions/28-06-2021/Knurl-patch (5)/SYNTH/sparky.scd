//
// SynthDef Sketch 2 for Knurl
//
// Designed by Timo Hoogland, www.timohoogland.com
// Knurl Hybrid Cello by Rafaele Maria Andrade
//

// boot the server
s.boot;

~tap = Buffer.alloc(s, 44100 * 2, 2);

SynthDef(\Sparky, {| freq=0.2, amp=0.5, filter=0.7, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1,
	reson=0.97, room=0.97 |

	var trig, f, tone, bit, verb, dly;

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [220 - 2200] exponantially
	// dens [0.5 - 2] linear
	// down [0 - 1] logarithmically
	// deviate [ 0.01 - 1 ] linear

	var scaledFreq = LinExp.kr(freq, 0, 1, 220, 2200);
	var dens = LinLin.kr(amp, 0, 1, 0.5, 2);
	var down = pow(filter, 0.5);
	var deviate = LinLin.kr(lin, 0, 1, 0.01, 1);

	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gDens = Gate.kr(dens, gateAmp);
	var gDown = Gate.kr(down, gateFlt);
	var gDeviate = Gate.kr(deviate, gateLin);

	// dust noise generator, trigger random frequency deviation and trigger resonant bandpass filter
	trig = Dust.ar(gDens, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gDeviate * gFreq) + gFreq);
	tone = SVF.ar(trig, f, reson, 1);

	// smooth downsampling of samplerate
	bit = Decimator.ar(tone, 44100 * (1 - gDown));

	dly = PingPong.ar(~tap.bufnum, [bit, bit], 0.333, 0.5);
	verb = FreeVerb.ar(dly, 0.4, room, 0.8);

	Out.ar(0, verb);
}).add;



SynthDef(\Sparky, {| freq=0.2, amp=0.5, filter=0.7, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1,
	reson=0.97, room=0.97 |

	var trig, f, tone, bit, verb, dly;

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [220 - 2200] exponantially
	// dens [0.5 - 2] linear
	// down [0 - 1] logarithmically
	// deviate [ 0.01 - 1 ] linear

	var scaledFreq = AnalogIn.ar(0).linlin(0, 0.7, 220, 2200);
	var dens = AnalogIn.ar(1).linlin(0, 0.7, 0.5, 2);
	var down = pow(AnalogIn.ar(0).linlin(0, 0.7, 0, 0.99), 0.5);
	var deviate = AnalogIn.ar(1).linlin(0, 0.7, 0.01, 1);

	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gDens = Gate.kr(dens, gateAmp);
	var gDown = Gate.kr(down, gateFlt);
	var gDeviate = Gate.kr(deviate, gateLin);

	// dust noise generator, trigger random frequency deviation and trigger resonant bandpass filter
	trig = Dust.ar(gDens, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gDeviate * gFreq) + gFreq);
	tone = SVF.ar(trig, f, reson, 1);

	// smooth downsampling of samplerate
	bit = Decimator.ar(tone, 44100 * (1 - gDown));

	dly = PingPong.ar(~tap.bufnum, [bit, bit], 0.333, 0.5);
	verb = FreeVerb.ar(dly, 0.4, room, 0.8);

	Out.ar(0, verb);
}).add;
