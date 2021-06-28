
(

//construction

var w, a, r, b, q;
var text = " Mode of performance ";
w = Window("Frequency Monitor", Rect(500, 100, 1200, 800)).front;

a = StaticText(w, Rect(40, 10, 250, 80));
a.background_(Color.white);
a.stringColor_(Color.blue);
a.string = "MODE";
a.font_(Font("Corbel Light", 76));

b = StaticText(w, Rect(40 + 250, 10, 250, 80));
b.background_(Color.white);
b.stringColor_(Color.blue);
b.string = "PLAY";
b.font_(Font("Corbel Light", 76));

c = StaticText(w, Rect(40 + 500, 10, 250, 80));
c.background_(Color.white);
c.stringColor_(Color.blue);
c.string = "SOLO";
c.font_(Font("Corbel Light", 76));

d = StaticText(w, Rect(40 + 750, 10, 380, 80));
d.background_(Color.white);
d.stringColor_(Color.blue);
d.string = "FREQ-AMP";
d.font_(Font("Corbel Light", 76));

t = TextView(w.asView,Rect(40, 120, 660,520)).focus(true);
t.font_(Font("Courier",34));
{t.stringColor_(Color.blue)}.defer;


e = StaticText(w, Rect(720, 120, 380, 80));
e.background_(Color.white);
e.stringColor_(Color.blue);
e.string = "VOICE 1:";
e.font_(Font("Corbel Light", 40));

f = StaticText(w, Rect(720, 220, 380, 80));
f.background_(Color.white);
f.stringColor_(Color.blue);
f.string = "VOICE 2:";
f.font_(Font("Corbel Light", 40));

g = StaticText(w, Rect(720, 320, 380, 80));
g.background_(Color.white);
g.stringColor_(Color.blue);
g.string = "VOICE 3:";
g.font_(Font("Corbel Light", 40));

h = StaticText(w, Rect(720, 420, 380, 80));
h.background_(Color.white);
h.stringColor_(Color.blue);
h.string = "VOICE 4:";
h.font_(Font("Corbel Light", 40));

Button.new(w, Rect(45, 700, 200, 20)).states_([[ "close", Color.black, Color.rand ]]).action_({ w.close });

// simulation
{
	var mode = Stepper.kr(Impulse.kr(1.5),0,0,3,1);
	var function = Stepper.kr(Impulse.kr(2.3),0,0,3,1);
	var subfunction = Stepper.kr(Impulse.kr(3.2),0,0,2,1);
	var rewrite = Stepper.kr(Impulse.kr(0.6),0,0,1,1);

	var console = "SMf1".ascii;

	SendReply.ar(Impulse.ar(1), "/reply", [mode,function,subfunction,rewrite],101);
	//SendReply.ar(Impulse.ar(0.5), "/reply", [v1,v2,v3,v4],102);
	SendReply.ar(Impulse.ar(1.5), "/reply", [console[0],console[1],console[2],console[3]],103);

}.play;


OSCdef(\x, { |msg|
    var id, time, value;

	id = msg[2];
    ~m = msg[3];
	~f = msg[4];
	~s = msg[5];
	~r = msg[6];

	//id.postln;
	if (id == 101){
	if(~m == 0){ { a.string = " SM "}.defer;};
	if(~m == 1){ { a.string = " PM "}.defer;};
	if(~m == 2){ { a.string = " AM "}.defer;};
	if(~m == 3){ { a.string = " DM "}.defer;};

	if(~f == 0){ { b.string = " PLAY "}.defer;};
	if(~f == 1){ { b.string = " STOP "}.defer;};
	if(~f == 2){ { b.string = " SEND "}.defer;};
	if(~f == 3){ { b.string = " SET "}.defer;};

	if(~s == 0){ { c.string = " SOLO"}.defer;};
	if(~s == 1){ { c.string = " GROUP "}.defer;};
	if(~s == 2){ { c.string = " MOTOR "}.defer;};

	if(~r == 0){ { d.string = " FREQAMP "}.defer;};
	if(~r == 1){ { d.string = " FILLIN "}.defer;};
	};


	if(id == 103){ {t.setString ("\n Console: " ++ ~m ++ "\n", 0,1);}.defer;};

}, "/reply");


CmdPeriod.doOnce({ w.close });
w.onClose = { r.stop; q.free; b.free }; // clean up if the window closes

v = Slider(w, 130 @ 24);
v.action = {| view |
	// Sliders output values from zero to one.
	w.alpha = view.value;
};
v.value = 1;

w.alpha = 0.51;
w.front;
)


