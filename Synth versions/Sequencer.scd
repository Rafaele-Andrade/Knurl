
SynthDef(\Sequencer,{ arg out=0, filter = 0, amp = 0, lin = 0,  src = 0, specint = 0, pulse3 = 3, gate = 1;
    var a,cycle,env,in1,in2;
	var linspecint, linamp, linfilter, linlin , linsrc;

	linspecint = LinLin.kr(  specint , 0.0,1, 50, 90); //50
	linamp = LinLin.kr(  amp , 0.0,1, 3, 13.8);  //13.8
	linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 0.1);
	linlin = LinLin.kr(  lin , 0.0,1, 0, 0.4);  //0.3
	linsrc = LinLin.kr(  src , 0.0,1, 40, 90); //90

	in1 =SoundIn.ar(0,1);// LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
	in2 =SoundIn.ar(1,1);

    a = [
		SinOsc.ar(linsrc)*in1,
		Saw.ar(linspecint)*in2,
		Pulse.ar(pulse3)*in1;
        ];
    cycle = a.size  * linlin;
	env = EnvGen.kr(Env.adsr(1.6, linamp, linamp, 1),gate,doneAction:2);
    Out.ar([0,1],
        Select.ar(LFSaw.kr(linfilter,0.0,cycle,cycle),a) * env
    )
}).add;

Synth(\Sequencer)


(
x = SynthDef(\Sequencer,{ arg out=0, lin = 0.2, amp = 0.01 , freq =1, filter = 4;

    var a,cycle;

    a = [
		SinOsc.ar(200*freq),
		SinOsc.ar(250*freq),
		SinOsc.ar(107*freq),
		RLPF.ar(Pulse.ar([100*freq, 25*freq], 0.5, 0.1), LFSaw.kr(filter,0, 400, 80), 0.05)
        ];

	cycle = a.size  * 0.5;
    Out.ar(out,
		 Select.ar(LFSaw.kr(lin,0,cycle,cycle),a)  * amp
    )
}).play;

)


x.set("freq",0.4)
x.set("lin",1.4)
x.set("amp",0.04)
x.set("filter",8)


(
SynthDef(\Sequencer,{ arg out=0, lin = 0.2, amp = 0.01 , freq =1, filter = 4,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate =1 ;

    var a,cycle;

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(0).linlin( 0.0,0.7,1, 5);
	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7, 0.01, 0.5);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7,  2, 8);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7,0.2, 1.5);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

    a = [
		SinOsc.ar(200*gatefreq),
		SinOsc.ar(250*gatefreq),
		SinOsc.ar(107*gatefreq),
		RLPF.ar(Pulse.ar([100*gatefreq, 25*gatefreq], 0.5, 0.1), LFSaw.kr(gatefilter,0, 400, 80), 0.05)
        ];

	cycle = a.size  * 0.5;
	Out.ar([0,1],
		 Select.ar(LFSaw.kr(gatelinlin,0,cycle,cycle),a)  * gateamp
    )
}).add;

)


x.set("freq",0.4)
x.set("speed",1.4)
x.set("amp",0.04)
