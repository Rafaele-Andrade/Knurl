s.quit;
s.options.memSize = 65536;  // e.g., could be different for
s.boot;
s.options.memSize = 8192 * 64;

SynthDef(\Input, { // direct cut, no smooth transition
		| inBusA, inBusB, out=0, pos= -1,trig = 2, gate = 1 , gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|

	var cycle,a;

	var linin = MouseX.kr(  50, 1000);
	var linsrc = MouseX.kr( 0, 4);
	var linfi = MouseX.kr(500, 5000);
	var linmul = MouseX.kr(0.2, 0.5);


	var gateinput = Gate.kr(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);
	var gt = Gate.kr(linsrc,gatesrc);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = SinOsc.ar(gateinput, gatefilter);
	var sig2 = Saw.ar(gateinput, gatefilter);
	var sig3 = LFPulse.ar(gateinput, gatefilter);
	var sig4 = SoundIn.ar(in, gatefilter);


		//var testPos = pos;
		//var testPos = EnvGen.kr(Env.new(levels:[-1,1,-1], times:[1,2,5]), doneAction:2);

	a = [
		sig1,sig2,sig3,sig4
        ];

	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a)  * gatemult);

	}).add;


a = Synth(\Input, [\out , 0, \in, 0]);


SynthDef(\Range, { // direct cut, no smooth transition
	| out = 1, gate = 1 ,gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|

	var cycle,a;

	var linin = MouseX.kr(  50, 1000);
	var linsrc = MouseY.kr( 0, 4);
	var linfi = MouseX.kr(500, 5000);
	var linmul = MouseX.kr(0.2, 0.5);

	var gateinput = Gate.ar(linin, gateinp);
	var gatefilter = Gate.ar(linfi, gatefi);
	var gatemult = Gate.ar(linmul, gatemul);
	var gt = Gate.ar(linsrc,gatesrc);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = SinOsc.ar(gateinput, gatefilter);
	var sig2 = Saw.ar(gateinput, gatefilter);
	var sig3 = LFPulse.ar(gateinput, gatefilter);
	var sig4 = Dust.ar(gateinput,gatefilter);



	a = [
		sig1,sig2,sig3,sig4
        ];

	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a)*0.5 );

	}).add;



a = Synth(\Input, [\out , 0, \in, 0])
x = Synth(\Range, [\out , 0, \in, 0])



SynthDef(\Multiply, { // direct cut, no smooth transition
		| out = 0, inBusA, inBusB, outBus=0, pos= -1,trig = 2, gate = 1 , gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0|

	var cycle,a ;

	var linin = MouseX.kr(  50, 1000);
	var linsrc = MouseX.kr( 0, 2);
	var linfi = MouseX.kr(500, 5000);
	var linmul = MouseX.kr(0.2, 0.5);

	var gateinput = Gate.ar(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);

	var env = EnvGen.kr(Env.asr(4, 1, 1), gate, doneAction:2);

	var sig1 = CombL.ar(SinOsc.ar(gateinput), gatefilter , gatemult);
	var sig2 = PMOsc.ar(SinOsc.ar(gateinput), gatefilter , gatemult);
	//var sig3 = Ringz.ar(SinOsc.ar(gateinput), gatefilter , gatemult);
	//var sig4 = Resonz.ar(SinOsc.ar(gateinput),gatefilter , gatemult);

	var gt = Gate.kr(linsrc, Impulse.kr(0.51));
	a = [
		sig1,sig2//, sig3//,sig4
        ];

	cycle = a.size  * 0.5;


	Out.ar(out, Select.ar(gt, a)*0.1);

	}).add;

a = Synth(\Input, [\out , 5, \in, 0])
x = Synth(\Range, [\out , 6, \in, 5])
x = Synth(\Multiply, [\out , 0, \in, 0])

SynthDef(\Source, { // direct cut, no smooth transition
		| inBusA, inBusB, outBus=0, out = 1, pos= -1,trig = 2, gate = 1 , insrc =1, gatesrc = 1, gateinp =1 ,gatefi =1 , gatemul =1, in =0, infi = 1 , inmul = 1|
	var cycle,a;
	var linin = MouseX.kr(  0, 3);
	var linsrc = MouseY.kr( 0, 4);
	var linfi = MouseX.kr(0, 4);
	var linmul = MouseX.kr(0.2, 0.5);


	var gatein = Gate.kr(linin, gateinp);
	var gatefilter = Gate.kr(linfi, gatefi);
	var gatemult = Gate.kr(linmul, gatemul);

	var env = EnvGen.kr(Env.asr(4, 0.21, 1), gate, doneAction:2);

	var sig1 = HPF.ar(In.ar(in), In.ar(infi),In.ar(inmul));
	var sig2 = LPF.ar(In.ar(in),In.ar(infi),In.ar(inmul) );
	var sig3 = Notch.ar(In.ar(in),In.ar(infi), mul: In.ar(inmul)  );
	var sig4 = BPF.ar(In.ar(in),In.ar(infi), mul: In.ar(inmul));

	var gt = Gate.kr(linsrc, gatesrc);

	a = [
		sig1,sig2,sig3,sig4
        ];


	cycle = a.size  * 0.5;

	Out.ar(out, Select.ar(gt, a)* env);

	}).add;

a = Synth(\Input, [\out , 3, \in, 0])
a.set(\out , 2)
a.set(\out , 3, \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
b = Synth(\Range, [\out , 0, \in, 0])
b.set(\out , 6)
b.set(\out , 6,  \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
b.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 , \gatesrc ,1)

x = Synth(\Multiply, [\out , 0, \in, 0])
x.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 , \gatesrc ,1)




//  D1

a = Synth(\Input, [\out , 0, \in, 0]);

//  D2

x = Synth(\Range, [\out , 0, \in, 0])


//  D3

x = Synth(\Multiply, [\out , 0, \in, 0])


//  D4

(

x = Synth(\Source, [\out , 0, \in, 3 , \infi, 4 ,\inmul, 5]);
~source = Synth('Source', [\out , 0, \in, 3 , \infi, 4 ,\inmul, 5]);

a = Synth(\Input, [\out , 3, \in, 0]);
b = Synth(\Range, [\out , 4, \in, 0]);
c = Synth(\Multiply, [\out , 5, \in, 0]);

)
(
a.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
b.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
c.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
)

	fork{
		~source = Synth('Source', [\out , 0, \in, 3 , \infi, 4 ,\inmul, 5]);
		0.5.wait;
		~input = Synth(\Input, [\out , 3, \in, 0]);
		~range  = Synth(\Range, [\out , 4, \in, 0]);
		~mul = Synth(\Multiply, [\out , 5, \in, 0]);
		0.5.wait;
		(
				~input.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
				~range.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
				~mul.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
			);
		10.wait;

		};

//  D4

x = Synth(\Source, [\out , 0, \in, 3 , \infi, 4 ,\inmul, 5])

(
a = Synth(\Input, [\out , 3, \in, 0]);
b = Synth(\Range, [\out , 4, \in, 0]);
c = Synth(\Multiply, [\out , 5, \in, 0])
)




x = Synth(\Source, [\out , 0, \in, 3 , \infi, 4 ,\inmul, 1])


(
a = Synth(\Input, [\out , 3, \in, 0]);
b = Synth(\Range, [\out , 4, \in, 0]);
c = Synth(\Multiply, [\out , 1, \in, 0])
)


(
a.set(\out , 3, \in, 0 );
b.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
c.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
)






