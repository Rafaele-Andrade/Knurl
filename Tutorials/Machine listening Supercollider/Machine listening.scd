


1 - Intro Machine listening   /Artificial intelligence

What is my goal:
To make Knurl has its own voice, as if I am playing with another performer/instrument.


What do I want to keep in mind:
Modes of listening
To hear and to understand isnt the same: we have different modes of listening
More data, more coplex but more precise you can tune your objective (this can be positive or negative)
Symbol x Data



2 - Decisions for this prototype:

As a performer, what I only expect from another agent is syncrony. I choose to undesrtand how machine listening could build an virtual based on my sonic decisions. The data analyzed isnt symbolic.

Data: Gestalt
Homophony               Polyphony                             Antiphony
Voices together         voices supporting eachother           voices completely independent of eachother


Classification:
Those items can be classified by:
Amount of speed of the phrases. classif 0 - 4  (average of events, Oneset)
Amount of delta of each event classif  (hasFreq)


Filter:
That means we already have a filter:
My data is only available when I have 2 voices  (INPUT (Mix.new(2,4)) & Electronic (0,1))


Build thinking:
3 states of analyzis are important to this 'brain':

(Referencial) Conditional:
	- Repetition
	- variation

(Analytical) Receiving Formats:
	Performer can trigger an 'advice' the machine what she is thinking:
	1 - Exposition
	2 - Variation
	3 - Cadence
	4 - Reexposition

(Sensorial) Transposition:
	Programming rates for tranposing the system to another data0 into sensorial spacial memory (the buttons change its .



Structure:
- Buffer
- Tracker (Onset, hasFreq (on/off)
- OSCdef (receive)
- Build thinking


=



References:
Simple track (Collins, Supercollider book. p.445)


b = Buffer.alloc(s,1024,1);

(
x = {
	var in, fft, loud;
	in = SoundIn.ar(0);
	fft = FFT(b.bufnum,in);
	loud= Loudness.kr(fft);
	loud.poll(20);
	Out.ar(0,Pan2.ar(in));
}.play
)


Onset detection
b = Buffer.alloc(s,1024,1);

(
x = {
	var in, fft, array;
	in = SoundIn.ar(0);
	fft = FFT(b.bufnum,in);
	array = MFCC.kr(fft);
	array.size.postln;
	Out.kr(0,array);
	Out.ar(0,Pan2.ar(in));
}.play
)
c = Bus.new('control', 0 , 13);
c.getn(13,{arg val; {val.plot}.defer});



(
var ms;
w = Window("Thirtheen MFCC coef", Rect(200,400,300,300));
ms = MultiSliderView(w,Rect(10,10,260,280));
ms.value_(Array.fill(13,0.0));
ms.valueThumbSize_(20);
ms.indexThumbSize_(20.0);
ms.gap_(0);

w.front;

r = {
	inf.do{
		c.getn(13,{arg val;{ms.value_(val*0.9)}.defer});
		0.04.wait;
	};
}.fork;
)




dan stowell


b = Buffer.alloc(s,512);

(
x = {
	var in, fft, onsets, trig,pips;

	in = SoundIn.ar(0);
	fft = FFT(b,in);
	onsets = Onsets.kr(fft, MouseX.kr(0,1), \complex);
	trig = SendTrig.kr(onsets);
	pips = SinOsc.ar(880, 0 , EnvGen.kr(Env.perc(0.0001,0.1,0.2),onsets));
	Out.ar(0, ((in*0.01) + pips).dup);
}.play
)

(
a = OSCresponder(s.addr, '/tr', {arg time, responder, msg;
	[time, responder,msg].postln;
}).add;
)


(
a = OSCdef(s.addr, '/tr', {arg time, responder, msg;
	fork{[time, responder,msg].poll; 1.wait}
})
)
a.play
