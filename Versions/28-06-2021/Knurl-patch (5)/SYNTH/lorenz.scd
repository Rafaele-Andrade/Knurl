//
// Lorenz FM Synth for Knurl
//
// Designed by Timo Hoogland, www.timohoogland.com
// Knurl Hybrid Cello by Rafaele Maria Andrade
//

s.boot;

SynthDef(\Lorenz, { |
	freq=0.4, amp=0.2, filter=0.3, lin=0.4,
	gateFrq=1, gateAmp=1, gateFlt=1 , gateLin=1, gate |

	//The audience will be allow to change freq, amp, filter and lin
	var car, mod, idx, pan, fm, verb, verbMod, drv, freqT, hasFreq, env;

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [87 - 240] exponantially
	// modDepth [5 - 25] linear
	// lfoSpeed [2 - 38] exponantially
	// drive [ 5 - 50 ] exponantially

	// Scale to suggested ranges
	var scaledFreq = LinExp.kr(freq, 0, 1, 87, 240);
	var modDepth = LinLin.kr(filter, 0, 1, 5, 25);
	var drive = LinExp.kr(amp, 0, 1, 5, 50);
	var lfoSpeed = LinExp.kr(lin, 0, 1, 2, 38);
	var scaledAmp = pow(amp, 0.3); //inverse exponential scaling for amplitude

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gMod = Gate.kr(modDepth, gateAmp);
	var gDrive = Gate.kr(drive, gateFlt);
	var gLFO = Gate.kr(lfoSpeed, gateLin);
	var gAmp = Gate.kr(scaledAmp, gateAmp);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	car = OnePole.kr(gFreq, 0.995) + SinOsc.ar(0.52, mul: 1);
	mod = car * 0.5012;
	idx = mod * LorenzL.ar(20) * OnePole.kr(gMod, 0.99);

	fm = SinOsc.ar(car + SinOsc.ar(mod, 0, idx), mul: 0.1);

	drv = tanh(fm * gDrive) / sqrt(gDrive);
	drv = drv * env;

	verb = FreeVerb.ar(drv, mix: 1, room: 1, damp: 0.9);
	verbMod = SinOsc.kr(gLFO, mul:0.5, add:0.5) * 1.5;

	Out.ar([0, 1], (verb * verbMod) + drv);
}).add;

// play the synth
~lorenz = Synth(\Lorenz);

SynthDef(\Lorenz, { |
	freq=0.4, amp=0.2, filter=0.3, lin=0.4,
	gateFrq=1, gateAmp=1, gateFlt=1 , gateLin=1, gate |

	//The audience will be allow to change freq, amp, filter and lin
	var car, mod, idx, pan, fm, verb, verbMod, drv, freqT, hasFreq, env;

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [87 - 240] exponantially
	// modDepth [5 - 25] linear
	// lfoSpeed [2 - 38] exponantially
	// drive [ 5 - 50 ] exponantially

	// Scale to suggested ranges
	var scaledFreq = AnalogIn.ar(0).linexp(0, 0.7, 87, 240);
	var drive = AnalogIn.ar(1).linexp(0, 0.7, 5, 50);
	var modDepth = AnalogIn.ar(0).linlin(0, 1, 5, 25);
	var lfoSpeed = AnalogIn.ar(1).linexp(0, 1, 2, 38);
	var scaledAmp = pow(AnalogIn.ar(1), 0.3); //inverse exponential scaling for amplitude

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gMod = Gate.kr(modDepth, gateAmp);
	var gDrive = Gate.kr(drive, gateFlt);
	var gLFO = Gate.kr(lfoSpeed, gateLin);
	var gAmp = Gate.kr(scaledAmp, gateAmp);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	car = OnePole.kr(gFreq, 0.995) + SinOsc.ar(0.52, mul: 1);
	mod = car * 0.5012;
	idx = mod * LorenzL.ar(20) * OnePole.kr(gMod, 0.99);

	fm = SinOsc.ar(car + SinOsc.ar(mod, 0, idx), mul: 0.1);

	drv = tanh(fm * gDrive) / sqrt(gDrive);
	drv = drv * env;

	verb = FreeVerb.ar(drv, mix: 1, room: 1, damp: 0.9);
	verbMod = SinOsc.kr(gLFO, mul:0.5, add:0.5) * 1.5;

	Out.ar([0, 1], (verb * verbMod) + drv);
}).add;
