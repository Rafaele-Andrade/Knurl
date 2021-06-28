(


w = Window.new("GUI Introduction",
	Rect(Window.screenBounds.width/2,Window.screenBounds.height/2,1000,800));

w.background_(Color.white);

t = TextView(w.asView,Rect(10,10, 200,250))
    .focus(true)
    .background_(Color.blue);

c = TextView(w.asView,Rect(110,10, 60,50))
    .focus(true);
w.front;



{ SendReply.ar(Impulse.ar(0.5), "/reply", [Stepper.kr(Impulse.kr(0.5),0,0,3,1), SinOsc.ar(0.3)]); 0 }.play;

)

(

OSCdef(\x, { |msg|
    var time, value;
    ~t = msg[3];
    ~value = msg[4];

	if(~t == 0){ { t.setString("\n SM \n", 12, 6) }.defer;};
	if(~t == 1){ { t.setString("\n PM \n", 12, 6) }.defer;};
	if(~t == 2){ { t.setString("\n AM \n", 12, 6) }.defer;};
	if(~t == 2){ { t.setString("\n DM \n", 12, 6) }.defer;};


	if(~t == 0){ { c.setString("\n Play \n", 12, 6) }.defer;};
	if(~t == 1){ { c.setString("\n Set \n", 12, 6) }.defer;};
	if(~t == 2){ { c.setString("\n Stop \n", 12, 6) }.defer;};
	if(~t == 2){ { c.setString("\n Send \n", 12, 6) }.defer;};

}, "/reply");

)



t = TextView(w.asView,Rect(10,10, 500,200))
t.setString (~t.cs, 12, 6);

	fork { { t.setString(~t.poll(1), 12, 6) }.defer;  1.wait };

t.setString ("\nA replacement String\n", 12, 6);


a = Button.new(w,Rect(10,0,80,30));
a.string = "hello button";
a.states_([
            ["SM", Color.black, Color.rand],
            ["PM", Color.black, Color.rand],
            ["AM", Color.black, Color.rand],
            ["DM", Color.black, Color.rand]
        ]);
a.background_(Color.blue );

a.action_(~t.postln);
s = Slider.new(w,Rect(95,0,150,30));
c = CompositeView.new(w,Rect(20,35,100,60));
StaticText.new(c,Rect(0,0,80,30)).string_("Hello");
StaticText.new(c,Rect(20,30,80,30)).string_("World!");
b.action = { c.visible = b.value.asBoolean.not };
s.action = { c.bounds = Rect( s.value * 150 + 20, 35, 100, 100 ) };