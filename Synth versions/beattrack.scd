SynthDef(\BeatTrack,{ |gate = 1, amp =1,  filter = 1, lin = 1,  src = 1, specint = 1|

	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 5000); //5000
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 0.06);  //0.06
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 10000); //10000
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.7);  //0.7
	var linsrc = LinLin.kr(  src , 0.0,1, 3, 1000); //1000

	var in = SoundIn.ar(0,1);

	var env = EnvGen.kr(Env.circle([0.001, 0.013, 0.83],[0.3,1,0.3]), gate, doneAction:2);  //~master

	var tr = Trig.kr(in,0.1);
	var ch = Changed.kr(tr,0.001);
	var bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), linsrc,0.3), 0.0);
	var hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 3000, 0.66,0.3), -0.5);
	var qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05),linspecint), 0.5);

	Out.ar([0,1], Ringz.ar([bsound + hsound + qsound],linfilter,linlin,0.05)*linamp);
}).add;


Synth(\BeatTrack)



SynthDef(\BeatTrack,{ |gate = 1, amp =1,  filter = 1, lin = 1,  freq = 1, specint = 1, gatef = 1, gateamp= 1, gatefi =1 , gatelin =1|

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(0).linlin( 0.0,1,3, 1000);
	var linamp = AnalogIn.ar(1).linlin( 0.0,1, 0.1, 0.06);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,1,  5, 10000);
	var linlin = AnalogIn.ar(1).linlin(0.0,1,0.025, 0.7);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var in = SoundIn.ar(0,1);

	var env = EnvGen.kr(Env.circle([0.001, 0.013, 0.83],[0.3,1,0.3]), gate, doneAction:2);  //~master

	var tr = Trig.kr(in,0.1);
	var ch = Changed.kr(tr,0.001);
	var bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), gatefreq,0.3), 0.0);
	var hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 3000, 0.66,0.3), -0.5);
	var qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), gatefreq*5), 0.5);

	Out.ar([0,1], Ringz.ar([bsound + hsound + qsound],gatefilter,gatelinlin,0.05)*gateampl);
}).add;


Synth(\BeatTrack)