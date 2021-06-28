SynthDef(\Sparky, {
	| freq=1, amp = 1, lin=0.05, filter=0.98,
	drive=2, dens=1, room=0.9,gatef = 1,
	gateamp= 1, gatefi =1 , gatelin =1, gate = 1,
	audiencecontrol = 0, |
	var trig, f, tone, drv, verb, dly, env;


	//D
	var linfreq = AnalogIn.ar(0).linlin(0.0,0.7, 60,420);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7,0.05, 2);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7, 0.9, 1.1);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7, 0.01 ,0.1);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

//Due safety reasons, these variables may have to be Scaled between 0 and 1

	trig = Dust.ar(gateamp, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gatefilter * gatefreq) + gatefreq);
	tone = SVF.ar(trig, f, gatelinlin, 1);

	drv = tanh(tone * 2) * 2;


	dly = PingPong.ar(c.bufnum, [drv, drv], 0.6, 0.6);
	verb = FreeVerb.ar(dly, 0.5, room, 0.7);

	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);
	Out.ar(0, verb*env);

}).add;





	~a = 1;
{
	var an = MouseX.kr(0,0.51);
	var t = Gate.kr(Impulse.kr(an),~a);

	var a = SinOsc.ar(200);
	var b = Saw.ar(60);
	var ab = { Dseq([a,b], inf) } * 100;
	Demand.kr(t, 0, ab).poll(t)
}.play



~a = 1;
~b = 1;
SynthDef('trg',{arg     b = 1        ;
    var trig, seq,ai, bi, freq;
	ai = 200;
	bi = 600;
	trig =         Impulse.kr(b);
    seq = Dseq([ai,bi], inf);
	freq = Demand.kr(trig, 0, seq ).poll(1);
    Out.ar(0,  SinOsc.ar(freq) * 0.1;);
}).add;

a = Synth('trg')    ;

a.set('b', 0 )