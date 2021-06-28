//  INSTRUCTIONS


                    Knurl              |    Computer bridge               |     Platform or other Collaborator
ip adress         192.168.3.2          |          x                       |                x
port                 6000              |         7000                     |               8000


// Quit the server to avoid excessive messages into your sc console
s.quit;

// Allows to receive from port
thisProcess.openUDPPort(7000);


// Send to Knurl
m = NetAddr.new("192.168.30.1", 6000 );

//try to send something, like:
fork{loop {m.sendMsg('/knurl', "hey") ; 2.wait;}}

//or trigger one synth, like:
m.sendMsg('/knurl/trigger',  'Ambience',0) ;

m.sendMsg('/knurl/trigger',  'Reus',1) ;



//  PATCH


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

OSCdef(\x, { arg msg, time, addr, recvPort;

	msg.postln(1);
	 ~id = msg[0];
    ~a = msg[1];
	~b = msg[2];
	~c = msg[3];
	~d = msg[4];

	//~e = msg[3];
	//~f = msg[3];
	//~g = msg[3];
	//~h = msg[3];
	{ a.string = ~a }.defer;
	{ b.string = ~b }.defer;
	{ c.string = ~c }.defer;
	{ d.string = ~d }.defer;

},'/knurlbuttons');



//to receive (only for internal test)
o = OSCFunc({ arg msg, time, addr, recvPort;
	~msg = msg[1];
	 //[msg, time, addr, recvPort].postln(1);
	fork{
	{t.setString ("\n Console: " ++ ~msg )}.defer;

		1.wait;
	}

}, '/knurlconsole'); // create the OSCFunc


//to receive (only for internal test)
o = OSCFunc({ arg msg, time, addr, recvPort;
msg.postln;

	~e = msg[1];
	~f = msg[2];
	~g = msg[3];
	~h = msg[4];

	{ e.string = " VOICE 1: " ++ ~e }.defer;
	{ f.string = " VOICE 2: " ++ ~f }.defer;
	{ g.string = " VOICE 3: " ++ ~g }.defer;
	{ h.string = " VOICE 4: " ++ ~h }.defer;

}, '/knurlvstorage'); // create the OSCFunc


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


