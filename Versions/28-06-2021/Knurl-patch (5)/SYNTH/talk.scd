//
// Talk Synth for Knurl
//
// Designed by Timo Hoogland, www.timohoogland.com
// Knurl Hybrid Cello by Rafaele Maria Andrade
//

// boot the server
s.boot;

// Talk Synth with normal LinExp.kr() and LinLin.kr() scaling
(
SynthDef(\Talk, { | freq=0.2, amp=0.7, filter=0.2, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1, gate,
	res=0.15 |

	var freqT, hasFreq, env;
	var v1, v2, v3, v, r, base, interp, fmt1, fmt2, fmt3, f1, f2, f3, syn;

	// vowels:
	// 0 = oo, 1 = u, 2 = oh, 3 = uh,
	// 4 = er, 5 = a, 6 = ae, 7 = e,
	// 8 = i, 9 = ee, 10 = o, 11 = oe

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [87 - 240] exponantially
	// vowel [0 - 11] linear
	// range [0 - 11] linear
	// speed [0.2 - 50] exponantially

	// Scale to suggested ranges
	var scaledFreq = LinExp.kr(freq, 0, 1, 87, 240);
	var scaledAmp = LinLin.kr(amp, 0, 1, 0, 1);
	var vowel = LinLin.kr(filter, 0, 1, 0, 11);
	var speed = LinExp.kr(lin, 0, 1, 0.2, 50);

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gAmp = Gate.kr(scaledAmp, gateAmp);
	var gVowel = Gate.kr(vowel, gateFlt);
	var gSpeed = Gate.kr(speed, gateLin);

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	v1 = LocalBuf.newFrom(
		[ 299, 438, 569, 518, 490, 739, 660, 528, 400, 270, 399, 360 ]);
	v2 = LocalBuf.newFrom(
		[ 850, 998, 856, 1189, 1358, 1102, 1702, 1855, 2002, 2296, 709, 1546 ]);
	v3 = LocalBuf.newFrom(
		[ 2250, 2250, 2410, 2390, 1690, 2440, 2410, 2480, 2250, 301, 2420, 2346 ]);

	// selected start vowel
	v = Wrap.kr(gVowel, 0, 11);
	// selected end vowel
	r = Wrap.kr(v + 1, 0, 11);

	base = Saw.ar(gFreq, 0.5) + Saw.ar(gFreq * 0.5, 0.3, 0.5);

	interp = LFTri.kr(gSpeed, 0, 0.5, 0.5);
	fmt1 = (Index.kr(v1, v) * (1.0 - interp)) + (Index.kr(v1, r) * interp);
	fmt2 = (Index.kr(v2, v) * (1.0 - interp)) + (Index.kr(v2, r) * interp);
	fmt3 = (Index.kr(v3, v) * (1.0 - interp)) + (Index.kr(v3, r) * interp);

	f1 = BPF.ar(base, fmt1, res);
	f2 = BPF.ar(base, fmt2, res, 0.75);
	f3 = BPF.ar(base, fmt3, res, 0.2);

	// syn = f1 + f2 + f3;
	syn = OnePole.ar(f1 + f2 + f3, 0.9) * env;
	// syn = FreeVerb.ar(syn, 0.8, 0.5, 0.5);

	Out.ar([0, 1], syn);
}).add;
)


// Talk synth with AnalogIn.ar()
(
SynthDef(\Talk, { | freq=0.2, amp=0.5, filter=0.2, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1, gate,
	res=0.15 |

	var freqT, hasFreq, env;
	var v1, v2, v3, v, r, base, interp, fmt1, fmt2, fmt3, f1, f2, f3, syn;

	// vowels:
	// 0 = oo, 1 = u, 2 = oh, 3 = uh,
	// 4 = er, 5 = a, 6 = ae, 7 = e,
	// 8 = i, 9 = ee, 10 = o, 11 = oe

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [87 - 240] exponantially
	// vowel [0 - 11] linear
	// range [0 - 11] linear
	// speed [0.2 - 50] exponantially

	// Scale to suggested ranges
	var scaledFreq = AnalogIn.ar(0).linexp(0, 0.7, 87, 240);
	var scaledAmp = AnalogIn.ar(1).linlin(0, 0.7, 0, 1);
	var vowel = AnalogIn.ar(0).linlin(0, 0.7, 0, 11);
	var speed = AnalogIn.ar(1).linexp(0, 0.7, 0.2, 50);

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gAmp = Gate.kr(scaledAmp, gateAmp);
	var gVowel = Gate.kr(vowel, gateFlt);
	var gSpeed = Gate.kr(speed, gateLin);

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	v1 = LocalBuf.newFrom(
		[ 299, 438, 569, 518, 490, 739, 660, 528, 400, 270, 399, 360 ]);
	v2 = LocalBuf.newFrom(
		[ 850, 998, 856, 1189, 1358, 1102, 1702, 1855, 2002, 2296, 709, 1546 ]);
	v3 = LocalBuf.newFrom(
		[ 2250, 2250, 2410, 2390, 1690, 2440, 2410, 2480, 2250, 301, 2420, 2346 ]);

	// selected start vowel
	v = Wrap.kr(gVowel, 0, 11);
	// selected end vowel
	r = Wrap.kr(v + 2, 0, 11);

	base = Saw.ar(gFreq, 0.5) + Saw.ar(gFreq * 0.5, 0.3, 0.5);

	interp = LFTri.kr(gSpeed, 0, 0.5, 0.5);
	fmt1 = (Index.kr(v1, v) * (1.0 - interp)) + (Index.kr(v1, r) * interp);
	fmt2 = (Index.kr(v2, v) * (1.0 - interp)) + (Index.kr(v2, r) * interp);
	fmt3 = (Index.kr(v3, v) * (1.0 - interp)) + (Index.kr(v3, r) * interp);

	f1 = BPF.ar(base, fmt1, res);
	f2 = BPF.ar(base, fmt2, res, 0.75);
	f3 = BPF.ar(base, fmt3, res, 0.2);

	// syn = f1 + f2 + f3;
	syn = OnePole.ar(f1 + f2 + f3, 0.9) * env;
	// syn = FreeVerb.ar(syn, 0.8, 0.5, 0.5);

	Out.ar([0, 1], syn);
}).add;
)