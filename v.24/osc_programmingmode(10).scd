/***** Oscdef_programingmode.scd *****/

OSCdef(\programingmode, {|msg|
	var id = msg[2], mode = msg[3],  count = msg[4],  an = msg[5], dig = msg[6];

	var an2 = an;
	var an1 = an;
	var freq =100;	
	var amp = 1;
	
		~mode = mode;
		~id = id;
		~dig = dig;
		~count = count;
		~freqT = 100;
		~ampT = 1;
		

		// ~freqT = LinLin.kr(freq,80, 2500, 3, 500);
		// ~ampT = LinLin.kr(amp,0.01, 1, 0.667, 1);



if ( ~mode == 1){

["pm:" ++ msg[4]].postln; 
n.sendMsg("/knurl/detect", "pm: " ++ ~count);

if (~dig== 1){

1.do{"programing mode".postln};

if(~id == 101) {
//~spec
if(~count == 1, {
	t = Task({

		fork{
		1.wait;
		if(~count == 1){
		if(~specon == nil, {
			~spec = { `[~freqT.rand*(1..4)] };
			n.sendMsg("/tr", "~spec1 (~freqT:" ++ ~freqT ++ ")");
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
			~specon = 1;
		},

			{
				~spec = { `[500.rand*(1..4)] };
				n.sendMsg("/tr", "~spec neutral");
				x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]);
				~specon = nil
			});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 2, {
	t = Task({

		fork{
		1.wait;
		if(~count == 2){
		if(~specon2 == nil, {
		~spec = { `[[~freqT, ~freqT*2, ~freqT*5, [~freqT + 230]], nil,  Array.rand(12, 0.1, 2,8)  ] } ;
		n.sendMsg("/tr", "~spec2 ( ~freqT:" ++ ~freqT ++ ")");
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
			~specon2 = 1
		},
		{
			~spec = { `[500.rand*(1..4)] };
			n.sendMsg("/tr", "~spec neutral");
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]);
			~specon2 = nil
		});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 3, {
	t = Task({
		fork{
		1.wait;
		if(~count == 3){
		if(~specon3 == nil, {
				~spec = {`[[900, 971, 1153, 1823, 1401], nil, [
				SinOsc.kr(~ampT).range(0.1,1),
				SinOsc.kr(~ampT*1.3).range(0.1,1),
				SinOsc.kr(~ampT*1.8).range(0.1,1),
				SinOsc.kr(~ampT*2).range(0.1,1),
				SinOsc.kr(~ampT*10).range(0.1,1)]]};
				n.sendMsg("/tr", "~spec3 (ampT:" ++ ~ampT ++ ")");
				x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
			~specon3 = 1;
		},

		{
			~spec = { `[500.rand*(1..4)] };
			// b.sendMsg("/tr",  "~spec neutral");
			 x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]);
			 ~specon3 = nil}

		)};

		1.wait;
		t.reset;
		t.stop;
	}});
	t.start;
});

if(~count == 4, {
	t = Task({

		fork{
		1.wait;
		if(~count == 4){
		if(~specon4 == nil, {
								n.sendMsg("/tr", "~spec4 ( ~freqT:" ++ ~freqT ++ ")");
								~spec = { `[50.rand*(1..4)] };
								x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]);
								~specon4 = 1;
		},
								{
								~spec = { `[500.rand*(1..4)] };
								n.sendMsg("/tr", "~spec neutral");
								x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4]);
								~specon4 = nil
								});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});
};
if(~id == 102) {
//~SCR

if(~count == 1, {
	t = Task({

		fork{
		1.wait;
		if(~count == 1){

		if(~startposon == nil, {
			~startpos =  {LinLin.kr(an1,0.2,0.9,0, BufFrames.kr(b))};
			n.sendMsg("/tr", "~startpos =  an1");
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
			~startpos = 1
		},

			{
									~trig = 1;
									~startpos = 0;
									~rate = {BufRateScale.kr(b)};
				n.sendMsg("/tr", "~src neutral");
				x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]);
				~startpos = nil
			});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 2, {
	t = Task({

		fork{
		1.wait;
		if(~count == 2){
		if(~trigon == nil, {
			~trig = {Impulse.kr(LinLin.kr(an2,0.2,0.9,0.5, 200))};
			n.sendMsg("/tr", "~trig = an2");
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
			~trigon = 1;
		},

		{
									~trig = 1;
									~startpos = 0;
									~rate = {BufRateScale.kr(b)};
			n.sendMsg("/tr", "~scr neutral");
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]);
			~trigon = nil
			
		});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 3, {
	t = Task({

		fork{
		1.wait;
		if(~count == 3){
		if(~rateon == nil, {
				~rate = {BufRateScale.kr(b) * LFNoise2.kr(XLine.kr(1, 20, 120, doneAction: 2), 1) };
				n.sendMsg("/tr", "	~rate ");
				x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
				~rateon = 1;
		},
		{
									~trig = 1;
									~startpos = 0;
									~rate = {BufRateScale.kr(b)};
			n.sendMsg("/tr",  "~scr neutral");
			 x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3])
		});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

// if(count == 4, {
// 	t = Task({

// 		fork{
// 		1.2.wait;
// 		if(~count == 4){
// 		0.2.wait;
// 		if(~dig == 1, {

// 								b.sendMsg("/tr", "~scr4 ");
// 								~src = {SinOsc.ar(~freqT.rand)};
// 								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4])},
// 								{
// 									~trig = 1;
// 									~startpos = 0;
// 									~rate = {BufRateScale.kr(b)};
// 								b.sendMsg("/tr", "~scr neutral");
// 								x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4])});
// 		1.wait;
// 		t.reset;
// 		t.stop;
// 		}}});
// 	t.start;
// });
};
if(~id == 103) {
//~format

if(~count == 1, {
	t = Task({
	fork{
		1.wait;
		if(~count == 1){
		if(~duron == nil, {
			~dur  = LinLin.kr(an1,0.2,0.9,2,8);
			n.sendMsg("/tr", "~dur  = an1");
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1]);
			~duron = 1
		},

			{
			~dur  = 8;
				n.sendMsg("/tr", "~dur  = 8;");
				x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]);
				~duron = nil
				 });
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 2, {
	t = Task({

		fork{
		1.wait;
		if(~count == 2){
		if(~suson == nil, {
			~sus = LinLin.kr(an2,0.2,0.9,2,10);
			n.sendMsg("/tr", "~sus = an2;" ++ ~amp);
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2]);
			~suson = 1;
		},

		{
			~sus = 2;
			n.sendMsg("/tr", "~sus = 2");
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]);
			~suson =nil
			
		});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 3, {
	t = Task({

		fork{
		1.wait;
		if(~count == 3){
			if(~widthon == nil, {
				~buffertime = LinLin.kr(an2,0.2,0.9,5,20);
				
				n.sendMsg("/tr", "~width = an2");
				x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 3]);
				~widthon = 1;
			},
			{
			~width = 1/2;
			n.sendMsg("/tr",  "~width = 1/2;");
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]);
			~widthon = nil;
			});

		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

if(~count == 4, {
	t = Task({

		fork{
		1.wait;
		if(~count == 4){
		if(~phaseon == nil, {

			b.sendMsg("/tr", "~iphase = an2");
			~iphase = LinLin.kr(an2,0.2,0.9,0.5,-0.5);
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 4]);
			~phaseon = 1;
		},
			{
			~iphase = 0.5;
			b.sendMsg("/tr", "~iphase = 0.5;");
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4]);
			~phaseon = nil;
				
			});
		1.wait;
		t.reset;
		t.stop;
		}}});
	t.start;
});

};
if(~id == 104) {
	//~subformat

	if(~count == 1) {
	t = Task({
		fork{
		1.wait;
		if(~count == 1){ if(~fu == nil,{ 
					"PM: on".postln;
						1.do{
										~bufnum = 0;
										~mul = 0.1371;
										~dur  = 8;
										~sus = 2;
										~curv = [-3];
										~width = 1/2;
										~spec = { `[500.rand*(1..4)] };

										~trig = {1};
										~startpos = {0};
										~rate = {BufRateScale.kr(~bufnum)};
										~src = { PlayBuf.ar(1, ~bufnum, ~rate.(), ~trig.(), ~startpos.(), loop: 1 )};
										~format = {LFGauss.kr([~dur + ~sus] , ~width, 0.7, 0,2)};
									
							~fu = { Limiter.ar(Klank.ar(~spec.(), ~src.()) * ~format.() , ~mul.()) !2 };
							~u = Task{ loop{ ~fu.play; ~dur.wait } }.play;
							};
							
			n.sendMsg("/knurl/live", "live code 1" );
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1])
			
		} , { "PM: off".postln;
			~u.stop;
			~fu = nil;
			b.sendMsg("/knurl/live", "live code 0");
				x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 1])
				 })
			};
	
		}});
		t.start;
	};

	if(~count == 2, {
	t = Task({
		fork{
		1.wait;
		if(~count == 2){
		if(~ampon == nil,{
			~mul = amp.exprange(0.1,1.3);
			b.sendMsg("/tr", "~dur = 8;" );
			"~dur = 8".postln;
			~ampon = 1;
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2])
		},
		{
			~mul = 0.39;
			["mul: 0.39"].postln;
			b.sendMsg("/tr", "~dur" ++ ~dur);
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]);
			~ampon = nil
		 });
		};
		1.wait;
		t.reset;
		t.stop;
		}});
	t.start;
});

	if(~count == 3, {
	t = Task({
		fork{
		1.wait;
		if(~count == 3){
		if(~ampon == nil,{
			~mul = amp.exprange(0.1,1.3);
			b.sendMsg("/tr", "~dur = 8;" );
			"~dur = 8".postln;
			~ampon = 1;
			x = Synth('blinker', ['outPin', 3, 'rate', 2, 'seq', 2])
		},
		{
			~mul = 0.39;
			["mul: 0.39"].postln;
			b.sendMsg("/tr", "~dur" ++ ~dur);
			x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]);
			~ampon = nil
		 });
		};
		1.wait;
		t.reset;
		t.stop;
		}});
	t.start;
});
};

}; //dig end
};  //mode end


}, "/trpm");

