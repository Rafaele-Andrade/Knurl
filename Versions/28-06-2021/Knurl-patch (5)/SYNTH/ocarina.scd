//
// Ocarina Synth for Knurl
//
// Designed by Timo Hoogland, www.timohoogland.com
// Knurl Hybrid Cello by Rafaele Maria Andrade
//

// boot the server
s.boot;

// Ocarina Synth with normal LinExp.kr() and LinLin.kr() scaling
(
SynthDef(\Ocarina, { | freq=0.2, amp=0.7, filter=0.2, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1, gate,
	res=0.15 |

	var freqT, hasFreq, env;

	var n, f1, f2, f3, f4, sum, resonz, freqs;
	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [260 - 780] exponantially
	// vibratoSpeed [5 - 18] linear
	// vibratoRange [4 - 15] linear

	// Scale to suggested ranges
	var scaledFreq = LinExp.kr(freq, 0, 1, 260, 780);
	var scaledAmp = LinLin.kr(amp, 0, 1, 0, 1);
	var vibrato = LinLin.kr(filter, 0, 1, 5, 18);
	var width = LinLin.kr(lin, 0, 1, 4, 15);

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gAmp = Gate.kr(scaledAmp, gateAmp);
	var gVib = Gate.kr(vibrato, gateFlt);
	var gWidth = Gate.kr(width, gateLin);

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	n = LPF.ar(HPF.ar(WhiteNoise.ar(1), 100), freq * 10);
	gFreq = OnePole.kr(gFreq, 0.3);

	f1 = SVF.ar(n, gFreq + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01);
	f2 = SVF.ar(n, (gFreq * 2.00124) + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01) * 0.3;
	f3 = SVF.ar(n, (gFreq * 3.00411) + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01) * 0.1;

	sum = LPF.ar(f1 + f2 + f3, gFreq * 5) * env;
	sum = FreeVerb.ar(sum, 0.4, 0.2, 0.5);

	Out.ar(0, sum);
}).add;
)


// Ocarina synth with AnalogIn.ar()
(
SynthDef(\Ocarina, { | freq=0.2, amp=0.7, filter=0.2, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1, gate,
	res=0.15 |

	var freqT, hasFreq, env;

	var n, f1, f2, f3, f4, sum, resonz, freqs;
	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [260 - 780] exponantially
	// vibratoSpeed [5 - 18] linear
	// vibratoRange [4 - 15] linear

	// Scale to suggested ranges
	var scaledFreq = AnalogIn.ar(0).linexp(0, 0.7, 260, 780);
	var scaledAmp = AnalogIn.ar(1).linlin(0, 0.7, 0, 1);
	var vibrato = AnalogIn.ar(0).linlin(0, 0.7, 5, 18);
	var width = AnalogIn.ar(1).linexp(0, 0.7, 4, 15);

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gAmp = Gate.kr(scaledAmp, gateAmp);
	var gVib = Gate.kr(vibrato, gateFlt);
	var gWidth = Gate.kr(width, gateLin);

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	n = LPF.ar(HPF.ar(WhiteNoise.ar(1), 100), freq * 10);
	gFreq = OnePole.kr(gFreq, 0.3);

	f1 = SVF.ar(n, gFreq + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01);
	f2 = SVF.ar(n, (gFreq * 2.00124) + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01) * 0.3;
	f3 = SVF.ar(n, (gFreq * 3.00411) + SinOsc.ar(gVib, 0, gWidth), 0.995, 0, 0.01) * 0.1;

	sum = LPF.ar(f1 + f2 + f3, gFreq * 5) * env;
	sum = FreeVerb.ar(sum, 0.4, 0.2, 0.5);

	Out.ar(0, sum);
}).add;
)
