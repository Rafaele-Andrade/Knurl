OSCdef(\mode, { |msg| var id = msg[2], msgi = msg[3];

//Update the function
~id = id;
~msgi = msgi;

x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 8]); //~a.free


	t = Task({ fork{
							~am1.set(\gate,-4);
							~am2.set(\gate,-4);
							~am3.set(\gate,-4);
							~am4.set(\gate,-4);
							~am5.set(\gate,-4);
							~am6.set(\gate,-4);

							~a1.set(\gate, -5.rand);
							~a2.set(\gate, -5.rand);
							//~a3.set(\gate, -5.rand);
							~a4.set(\gate, -5.rand);

							~b1.set(\gate, -5.rand);
							~b1.set(\gate, -5.rand);
							~b2.set(\gate, -5.rand);
							~b3.set(\gate, -5.rand);
							~b4.set(\gate, -5.rand);

							~c1.set(\gate, -5.rand);
							~c2.set(\gate, -5.rand);
							~c3.set(\gate, -5.rand);
							~c4.set(\gate, -5.rand);

							~d1.set(\gate, -5.rand);
							~d2.set(\gate, -5.rand);
							~d3.set(\gate, -5.rand);
							~d4.set(\gate, -5.rand);

							~motora.set(\gate,-4);
							~motorb.set(\gate,-4);

							3.wait;
							1.do({
							~a1 = nil;
							~a2 = nil;
						//	~a3 = nil;
							~a4 = nil;
							~a5 = nil;
							~b1 = nil;
							~b2 = nil;
							~b3 = nil;
							~b4 = nil;
							~b5 = nil;
							~c1 = nil;
							~c2 = nil;
							~c3 = nil;
							~c4 = nil;
							~c5 = nil;
							~d1 = nil;
							~d2 = nil;
							~d3 = nil;
							~d4 = nil;
							~d5 = nil;

							~motora = nil;
							~motorb = nil;
							});
							n.sendMsg("/tr", " ALL Synths gate -4");
							1.wait;t.reset; t.stop;}});



// FUNCTION - MODE OF PERFORMANCES - switch buttons
if(~id == 100){
if (msgi == 0){1.do{"synth mode (0)".postln;  if(n != nil,{n.sendMsg("/tr", "sm");});}};
if (msgi == 1){1.do{"programming mode (1)".postln; if(n != nil ,{n.sendMsg("/tr", "pm");});}};
if (msgi == 2){1.do{"analogue mode (2)".postln; if(n != nil ,{n.sendMsg("/tr", "am");});}};
if (msgi == 3){1.do{"detectmode (3)".postln;  if(n != nil,{n.sendMsg("/tr", "dm");});}};
if (msgi == 4){1.do{"recordmode (4)".postln;  if(n != nil,{n.sendMsg("/tr", "rm");});}};
};


//FUNCTION
if(~id == 101){
if (msgi == 0){1.do{"Play (0)".postln; ~function = 'play';  if(n != nil,{n.sendMsg("/tr", "Play");});}};
if (msgi == 1){1.do{"Set (1)".postln;  ~function = 'set'; if(n != nil ,{n.sendMsg("/tr", "Set");});}};
if (msgi == 2){1.do{"Stop (2)".postln; ~function = 'stop'; if(n != nil ,{n.sendMsg("/tr", "Stop");});}};
if (msgi == 3){1.do{"Adjust (3)".postln;  ~function = 'set'; 	t.start;   if(n != nil,{n.sendMsg("/tr", "Adjust");});}};
if (msgi == 4){1.do{"Send (4)".postln;  ~function = 'send'; if(n != nil ,{n.sendMsg("/tr", "Send");})}};
};


// SUBFUNCTION - HOW of the function
if(~id == 102){

		if (~function == 'play'){
			if (msgi == 0){ ~subfunction == 'var'};
			if (msgi == 1){ ~subfunction == 'synths'};
		};

		if (~function == 'set'){
			if (msgi == 0){ ~subfunction == 'envelope'};
			if (msgi == 1){ ~subfunction == 'counterpoint'};
			if (msgi == 2){ ~subfunction == 'routing'};
		};

		if (~function == 'stop'){
			if (msgi == 0){ ~subfunction == 'stop all'};
			if (msgi == 1){ ~subfunction == 'stop group'};
			if (msgi == 2){ ~subfunction == 'stop one'};
		};

		if (~function == 'set'){
			if (msgi == 0){ ~subfunction == 'tune'};
			if (msgi == 1){ ~subfunction == 'siri'};
			if (msgi == 3){ ~subfunction == 'reset all'};
			if (msgi == 4){ ~subfunction == 'motor1';
				if( ~motora == nil, {"motor 1 (on)".postln; ~motora = Synth('motor', ['outPin', 6])},{~motora.set(\gate,-4); ~motora = nil;"motor 1 (off)".postln;})};
			if (msgi == 5){ ~subfunction == 'motor2';
				if( ~motorb == nil, {"motor 2 (on)".postln; ~motorb = Synth('motor', ['outPin', 7])},{~motorb.set(\gate,-4); ~motorb = nil;"motor 2 (off)".postln;})};
			if (msgi == 6){ ~subfunction == 'n. voice storage'; ~voicestorage = 4;}
		};
};



//  REWRITE - Adjust your settings
if(~id == 103){
		if (~subfunction == 'var'){
			if (msgi == 0){ ~rewrite == 'a1:freq/a2:amp'};
			if (msgi == 1){ ~rewrite == 'a1:filter/a2:lin'};
		};

		if (~subfunction == 'synths'){
			if (msgi == 0){ ~rewrite == 'freeze'};
			if (msgi == 1){ ~rewrite == 'gate open'};
		};

		if (~subfunction == 'envelope'){
			if (msgi == 0){ ~rewrite == 'stringsfade'};
			if (msgi == 1){ ~rewrite == 'circular'};
			if (msgi == 2){ ~rewrite == 'brass'};
			if (msgi == 3){ ~rewrite == 'percussive loop'};
		};

		if (~subfunction == 'counterpoint'){
			if (msgi == 0){ ~rewrite == 'circular'};
			if (msgi == 1){ ~rewrite == 'brass'};
			if (msgi == 2){ ~rewrite == 'percussive loop'};
			if (msgi == 3){ ~rewrite == 'percussive loop'};
			if (msgi == 4){ ~rewrite == 'percussive loop'};
		};

		if (~subfunction == 'routing'){
		};

		if (~function == 'stop'){
			if (msgi == 0){ ~rewrite == 'circular'};
			if (msgi == 1){ ~rewrite == 'brass'};
		};


};




},'/manag')