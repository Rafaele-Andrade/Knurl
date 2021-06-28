
(
var w, a, r, b, q;
var text = " Mode of performance ";
w = Window("Frequency Monitor", Rect(500, 100, 1200, 800)).front;

a = StaticText(w, Rect(40, 10, 250, 80));
a.background_(Color.white);
a.stringColor_(Color.blue);
a.string = "MODE";
a.font_(Font("Corbel Light", 80));

b = StaticText(w, Rect(40 + 250, 10, 250, 80));
b.background_(Color.white);
b.stringColor_(Color.blue);
b.string = "PLAY";
b.font_(Font("Corbel Light", 80));

c = StaticText(w, Rect(40 + 500, 10, 250, 80));
c.background_(Color.white);
c.stringColor_(Color.blue);
c.string = "SOLO";
c.font_(Font("Corbel Light", 80));

b = StaticText(w, Rect(40 + 750, 10, 380, 80));
b.background_(Color.white);
b.stringColor_(Color.blue);
b.string = "FREQ-AMP";
b.font_(Font("Corbel Light", 80));

t = TextView(w.asView,Rect(40, 120, 660,520)).focus(true);
t.setFont(Font("Times", 88), [text.size - 1],  47);

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


s.waitForBoot({

    b = Bus.new(\control, 0, 1);

    q = SynthDef(\Docs_FreqMonitor, {
        var freq, snd,data;
        freq = LFNoise0.ar(2, 400, 650);
        snd = SinOsc.ar(freq, 0, 0.02);
		data = Stepper.kr(Impulse.kr(0.5),0,0,3,1);
        //Out.ar(0, snd);
        Out.kr(b.index, data); // output the frequency to a control bus
    }).play;

    r = Routine {
        {
            // Set the value of the StaticText to the value in the control bus.
            // Setting GUI values is asynchronous, so you must use .defer in the system clock.
            // Also you must check if the window is still open, since Routine will continue for at least
            // one step after you close the window.
            b.get({ |v|
                {
                    if(w.isClosed.not) {
						if(v == 0){a.string = " SM " };
						if(v == 1){a.string = " PM " };
						if(v == 2){a.string = " AM " };
						if(v == 3){a.string = " DM " };
                    }
                }.defer
            });

            0.01.wait;
        }.loop

    }.play
});

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


w.alpha = 0.51;
w.front;


Font.availableFonts
