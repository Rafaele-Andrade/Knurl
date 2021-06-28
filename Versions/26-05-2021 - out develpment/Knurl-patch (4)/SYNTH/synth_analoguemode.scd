/***** synth_analoguemode.scd *****/

(



SynthDef(\Input, { // direct cut, no smooth transition
		| inBusA, inBusB, out=0, pos= -1,trig = 2, gate = 1 , gateinp = 1, gatesrc =1 ,gatefi =1 , gatemul =1, in = 0|

	var cycle,a; 
	
	var linin = AnalogIn.ar(0).linlin( 0.0,0.7,  500, 5000);
	var linsrc = AnalogIn.ar(1).linlin( 0.0,0.7, 0, 4);
	var linfi = AnalogIn.ar(0).linlin( 0.0,0.7,50, 500);
	var linmul = AnalogIn.ar(1).linlin(0.0,0.7,0.1, 0.5);

	var gateinput = Gate.kr(linin, gateinp);
	var gt = Gate.kr(linsrc,gatesrc);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = SinOsc.ar(gateinput, mul: gatefilter);
	var sig2 = Saw.ar(gateinput, mul: gatefilter);
	var sig3 = LFPulse.ar(gateinput, mul: gatefilter);
	var sig4 = SoundIn.ar(in, 0.1)*SinOsc.ar(gateinput, mul: gatefilter);


	a = [
		sig1,sig2,sig3,sig4
        ];

	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a)  * gatemult);

	}).add;



SynthDef(\Range, { // direct cut, no smooth transition
		| inBusA, inBusB, out=0, pos= -1,trig = 2, gate = 1 ,gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|

	var cycle,a; 
	
	
	var linin = AnalogIn.ar(0).linlin( 0.0,0.7,  500, 5000);
	var linsrc = AnalogIn.ar(1).linlin( 0.0,0.7, 0, 4);
	var linfi = AnalogIn.ar(0).linlin( 0.0,0.7,50, 500);
	var linmul = AnalogIn.ar(1).linlin(0.0,0.7,0.1, 0.5);

	var gateinput = Gate.kr(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);
	var gt = Gate.kr(linsrc,gatesrc);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = HPF.ar(In.ar(in), gatefilter , gatemult);
	var sig2 = LPF.ar(In.ar(in), gatefilter , gatemult);
	var sig3 = Notch.ar(In.ar(in), gatefilter , gatemult);
	var sig4 = BPF.ar(In.ar(in),gatefilter , gatemult);

	a = [
		sig1,sig2,sig3,sig4
        ];

	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a) );

	}).add;

SynthDef(\Multiply, { // direct cut, no smooth transition
		| inBusA, inBusB, out=0, pos= -1,trig = 2, gate = 1 , gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|

	var cycle,a ; 
	
	var linin = AnalogIn.ar(0).linlin( 0.0,0.7,  500, 5000);
	var linsrc = AnalogIn.ar(1).linlin( 0.0,0.7, 0, 4);
	var linfi = AnalogIn.ar(0).linlin( 0.0,0.7,50, 500);
	var linmul = AnalogIn.ar(1).linlin(0.0,0.7,0.1, 0.5);

	var gateinput = Gate.kr(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);
	var gt = Gate.kr(linsrc, gatesrc);
	
	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = CombL.ar(In.ar(gateinput), gatefilter , gatemult);
	var sig2 = PMOsc.ar(In.ar(gateinput), gatefilter , gatemult);
	var sig3 = Ringz.ar(In.ar(gateinput), gatefilter , gatemult);
	var sig4 = Resonz.ar(In.ar(gateinput),gatefilter , gatemult);


	a = [
		sig1,sig2,sig3,sig4
        ];

	cycle = a.size  * 0.5;

	
	Out.ar(out, Select.ar(gt, a));

	}).add;

SynthDef(\Source, { // direct cut, no smooth transition
		| inBusA, inBusB, out=0, pos= -1,trig = 2, gate = 1 , insrc =1, gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|
	var cycle,a; 
	
	var linin = AnalogIn.ar(0).linlin( 0.0,0.7,  500, 5000);
	var linsrc = AnalogIn.ar(1).linlin( 0.0,0.7, 0, 4);
	var linfi = AnalogIn.ar(0).linlin( 0.0,0.7,50, 500);
	var linmul = AnalogIn.ar(1).linlin(0.0,0.7,0.1, 0.5);

	var gatein = Gate.kr(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = HPF.ar(In.ar(gatein), In.ar(gatefilter), In.ar(gatemult));
	var sig2 = LPF.ar(In.ar(gatein),In.ar(gatefilter),  In.ar(gatemult));
	var sig3 = Notch.ar(In.ar(gatein),In.ar(gatefilter),  In.ar(gatemult));
	var sig4 = BPF.ar(In.ar(gatein),In.ar(gatefilter),  In.ar(gatemult));

	var gt = Gate.kr(linsrc, gatesrc);
	
	a = [
		sig1,sig2,sig3,sig4
        ];

	
	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a)* env);

	}).add;

)
