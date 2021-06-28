//
// SynthDef Sketch 2 for Knurl
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
~tap = Buffer.alloc(s, 44100 * 2, 2);

SynthDef(\Sparky, {| freq=220, deviate=0.05, reson=0.98, drive=2, dens=1, room=0.9|
	var trig, f, tone, drv, verb, dly;

	trig = Dust.ar(dens, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (deviate * freq) + freq);
	tone = SVF.ar(trig, f, reson, 1);

	drv = tanh(tone * 2) * 2;


	dly = PingPong.ar(~tap.bufnum, [drv, drv], 0.6, 0.6);
	verb = FreeVerb.ar(dly, 0.5, room, 0.7);

	Out.ar(0, verb);
}).add;

~dusty = Synth(\Sparky);
)

(
~dusty.set(\dens, 0.5);// amp 0.05 - 2
~dusty.set(\freq, 120);// 60- 520
~dusty.set(\deviate, 1.5);// lin 0.01 = 0.1
~dusty.set(\reson, 0.91);  //filter  0.9 = 1.1
)

~dusty.free;





~tap = Buffer.alloc(s, 44100 * 2, 2);

SynthDef(\Sparky, {| freq=1, amp = 1, lin=0.05, filter=0.98, drive=2, dens=1, room=0.9,gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate =1|
	var trig, f, tone, drv, verb, dly,env;


	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = LinLin.kr(  freq , 0.0,1, 60,420);
	var linamp = LinLin.kr(  amp , 0.0,1, 0.05, 2);
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.9, 1.1);
	var linlin = LinLin.kr( lin , 0.0,1, 0.01 ,0.1);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	trig = Dust.ar(gateamp, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gatefilter * gatefreq) + gatefreq);
	tone = SVF.ar(trig, f, gatelinlin, 1);

	drv = tanh(tone * 2) * 2;
	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

	dly = PingPong.ar(~tap.bufnum, [drv, drv], 0.6, 0.6);
	verb = FreeVerb.ar(dly, 0.5, room, 0.7);

	Out.ar(0, verb*env);
}).add;

~dusty = Synth(\Sparky);

(
~dusty.set(\amp, 0.5);// amp 0.05 - 2
~dusty.set(\freq, 0.31);// 60- 520
~dusty.set(\lin, 1.5);// lin 0.01 = 0.1
~dusty.set(\filter, 0.41);  //filter  0.9 = 1.1
)




SynthDef(\Sparky, {| freq=1, amp = 1, lin=0.05, filter=0.98, drive=2, dens=1, room=0.9,gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate = 1|
	var trig, f, tone, drv, verb, dly, env;


	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(0).linlin(0.0,0.7, 60,420);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7,0.05, 2);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7, 0.9, 1.1);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7, 0.01 ,0.1);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	trig = Dust.ar(gateamp, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gatefilter * gatefreq) + gatefreq);
	tone = SVF.ar(trig, f, gatelinlin, 1);

	drv = tanh(tone * 2) * 2;


	dly = PingPong.ar(~tap.bufnum, [drv, drv], 0.6, 0.6);
	verb = FreeVerb.ar(dly, 0.5, room, 0.7);

	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);
	Out.ar(0, verb*env);

}).add;

~dusty = Synth(\Sparky);

(
~dusty.set(\amp, 0.5);// amp 0.05 - 2
~dusty.set(\freq, 0.31);// 60- 520
~dusty.set(\lin, 1.5);// lin 0.01 = 0.1
~dusty.set(\filter, 0.41);  //filter  0.9 = 1.1
)
