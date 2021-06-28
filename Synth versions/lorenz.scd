//
// SynthDef Sketch 1 for Knurl
//
// Designed by Timo Hoogland, www.timohoogland.com
// Knurl Hybrid Cello by Rafaele Maria Andrade
//

// boot the server
s.boot;
// show status and recording window
s.makeWindow;
// view recording path
thisProcess.platform.recordingsDir;
// start a recording
s.record;
// stop a recording
s.stopRecording;

(
SynthDef(\lorenzSynth, {|freq=63, modDepth=5, panSpeed=3, drive=3|
	var car, mod, idx, pan, fm, verb, verbMod, drv;

	car = freq + SinOsc.ar(0.52, mul: 1);
	mod = car * 0.5;

	idx = mod * LorenzL.ar(20) * modDepth;
	pan = SinOsc.ar(panSpeed);

	fm = Pan2.ar(
		SinOsc.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1),
		// Formant.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1, formfreq: 250, bwfreq: 100),
			pos: pan
		);

	// var verb = FreeVerb.ar(fm, mix: 1, room: 2, damp: 0.5);
	verb = GVerb.ar(fm, roomsize: 120, revtime: 7, damping: 0.6, spread: 25);
	verbMod = SinOsc.kr(freq: 3.32) + 0.5 + 0.5;

	// var mix = verb + fm;
	// Out.ar(0, fm);
	// Mix.ar([fm, verb]);

	drv = tanh(fm * drive) / sqrt(drive);

	Out.ar([0, 1], [(verb * verbMod + drv) * 0.5]);
}).add;
)

// play the synth
~lorenz = Synth(\lorenzSynth);

// adjust parameters
~lorenz.set(\freq, 0.2);
~lorenz.set(\freq, 200);
~lorenz.set(\modDepth, 3);
~lorenz.set(\panSpeed, 10);
~lorenz.set(\drive, 20);
~lorenz.set(\drive, 2);

~lorenz.free;

{SinOsc.kr(freq: 3.32) + 0.5 + 0.5}.plot(1);



SynthDef(\lorenzSynth, {|freq= 1, amp = 1, filter = 1 , lin = 1 ,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, modDepth=5, panSpeed=3, drive=3, gate|

	//The audience will be allow to change freq amo filter and lin

	var car, mod, idx, pan, fm, verb, verbMod, drv, freqT, hasFreq,env;


	// for some synths SoundIn has to be programmed separetaly, At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0,2);
	var sig2 = SoundIn.ar(1,2);

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = LinLin.kr(  freq , 0.0,1, 20,263);
	var linamp = LinLin.kr(  amp , 0.0,1, 0, 1);
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 20);
	var linlin = LinLin.kr( lin , 0.0,1, 1 ,10);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1,ampThreshold: 0.001,median: 7);


	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

	//And finally some music!
	car = gatefreq + SinOsc.ar(gatefreq, mul: 1);
	mod = car * 0.5;

	idx = mod * LorenzL.ar(gatefilter) * gatelinlin;
	pan = SinOsc.ar(panSpeed);

	fm = Pan2.ar(
		SinOsc.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1),
		// Formant.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1, formfreq: 250, bwfreq: 100)			pos: pan
		);

	// var verb = FreeVerb.ar(fm, mix: 1, room: 2, damp: 0.5);
	verb = FreeVerb.ar(fm, room: 2, damp: 0.6);
	verbMod = SinOsc.kr(freq: 3.32) + 0.5 + 0.5;

	// var mix = verb + fm;
	// Out.ar(0, fm);
	// Mix.ar([fm, verb]);

	drv = tanh(fm * drive) / sqrt(drive);
	drv = drv *env;

	Out.ar([0, 1], Limiter.ar([(verb * verbMod + drv)], gateampl) );
}).add;

// play the synth
~lorenz = Synth(\lorenzSynth);

// adjust parameters
~lorenz.set(\freq, 0.1);
~lorenz.set(\filter, 0.1);
~lorenz.set(\lin, 0.001);
~lorenz.set(\amp, 0);
~lorenz.set(\drve, 2);





SynthDef(\lorenzSynth, {|freq= 1, amp = 1, filter = 1 , lin = 1 ,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, modDepth=5, panSpeed=3, drive=3, gate|

	//The audience will be allow to change freq amo filter and lin

	var car, mod, idx, pan, fm, verb, verbMod, drv, freqT, hasFreq,env;


	// for some synths SoundIn has to be programmed separetaly, At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0,2);
	var sig2 = SoundIn.ar(1,2);

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(0).linlin(0.0,0.7, 20,263);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7, 0.01, 1);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7, 1, 20);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7, 1, 10);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1,ampThreshold: 0.001,median: 7);


	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

	//And finally some music!
	car = gatefreq + SinOsc.ar(gatefreq, mul: 1);
	mod = car * 0.5;

	idx = mod * LorenzL.ar(gatefilter) * gatelinlin;
	pan = SinOsc.ar(panSpeed);

	fm = Pan2.ar(
		SinOsc.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1),
		// Formant.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1, formfreq: 250, bwfreq: 100)			pos: pan
		);

	// var verb = FreeVerb.ar(fm, mix: 1, room: 2, damp: 0.5);
	verb = FreeVerb.ar(fm, room: 2, damp: 0.6);
	verbMod = SinOsc.kr(freq: 3.32) + 0.5 + 0.5;

	// var mix = verb + fm;
	// Out.ar(0, fm);
	// Mix.ar([fm, verb]);

	drv = tanh(fm * drive) / sqrt(drive);
	drv = drv *env;

	Out.ar([0, 1], Limiter.ar([(verb * verbMod + drv)], gateampl) );
}).add;


