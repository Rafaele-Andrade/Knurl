SynthDef(\Sequencer,{ arg out=0, lin = 0.2, amp = 0.01 , freq =1, filter = 4,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate =1 ;

    var a,cycle;

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(DC.ar(0)).linlin( 0.0,0.7,1, 5);
	var linamp = AnalogIn.ar(DC.ar(1)).linlin( 0.0,0.7, 0.01, 0.5);
	var linfilter = AnalogIn.ar(DC.ar(0)).linlin( 0.0,0.7,  2, 8);
	var linlin = AnalogIn.ar(DC.ar(1)).linlin(0.0,0.7,0.2, 1.5);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(8, gateampl, 1), gate, doneAction:2);

    a = [
		SinOsc.ar(20*gatefreq),
		SinOsc.ar(20*gatefreq),
		SinOsc.ar(10*gatefreq),
		RLPF.ar(Pulse.ar([10*gatefreq, 25*gatefreq], 0.5, 0.1), LFSaw.kr(gatefilter,0, 400, 80), 0.05)
        ];

	cycle = a.size  * 0.5;
	Out.ar([0,1],
		 Select.ar(LFSaw.kr(gatelinlin,0,cycle,cycle),a)  * env
    )
}).add;
