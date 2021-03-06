/***** osc_management.scd *****/


OSCdef(\mode, { |msg| var id = msg[2], msgi = msg[3];

//Update the function
~id = id;

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
							});
							n.sendMsg("/tr", " ALL Synths gate -4");
							1.wait;t.reset; t.stop;}});



//MODE OF PERFORMANCES
if(~id == 100){
if (msgi == 0){1.do{"synth mode (0)".postln;  if(n != nil,{n.sendMsg("/tr", "sm");});}};
if (msgi == 1){1.do{"programming mode (1)".postln; if(n != nil ,{n.sendMsg("/tr", "pm");});}};
if (msgi == 2){1.do{"analogue mode (2)".postln; if(n != nil ,{n.sendMsg("/tr", "am");});}};
if (msgi == 3){1.do{"detectmode (3)".postln;  if(n != nil,{n.sendMsg("/tr", "dm");});}};
if (msgi == 4){1.do{"recordmode (4)".postln;  if(n != nil,{n.sendMsg("/tr", "rm");});}};
};


//FUNCTION
if(~id == 101){
if (msgi == 0){1.do{"PLAY (0)".postln;  if(n != nil,{n.sendMsg("/tr", "play");});}};
if (msgi == 1){1.do{"STOP (1)".postln; if(n != nil ,{n.sendMsg("/tr", "stop");});}};
if (msgi == 2){1.do{"SET (2)".postln; if(n != nil ,{n.sendMsg("/tr", "rewrite");});}};
if (msgi == 3){1.do{"STOP ALL (3)".postln; 	t.start;  if(n != nil,{n.sendMsg("/tr", "set");});}};
};


//INPUTS
if(~id == 102){
if (msgi == 0){1.do{"ALL INPUTS (0)".postln;  if(n != nil,{n.sendMsg("/tr", "ALL INPUTS (0)");});}};
if (msgi == 1){1.do{"INPUT 1 (1)".postln; if(n != nil ,{n.sendMsg("/tr", "INPUT 1 (1)");});}};
if (msgi == 2){1.do{"INPUT 2 (2)".postln; if(n != nil ,{n.sendMsg("/tr", "INPUT 2 (2)");});}};
if (msgi == 3){1.do{"INPUT 3 (3)".postln; if(n != nil,{n.sendMsg("/tr", "INPUT 3 (3)");});}};
if (msgi == 4){1.do{"INPUT 4 (4)".postln; if(n != nil,{n.sendMsg("/tr", "INPUT 4 (4)");});}};
};


//OUTPUTS
if(~id == 103){
if (msgi == 0){1.do{"ALL OUTPUTS (0)".postln;  if(n != nil,{n.sendMsg("/tr", "ALL OUTPUTS (0)");});}};
if (msgi == 1){1.do{"OUTPUT 1 (1)".postln; if(n != nil ,{n.sendMsg("/tr", "OUTPUT 1 (1)");});}};
if (msgi == 2){1.do{"OUTPUT 2 (2)".postln; if(n != nil ,{n.sendMsg("/tr", "OUTPUT 2 (2)");});}};
if (msgi == 3){1.do{"OUTPUT 3 (3)".postln; if(n != nil,{n.sendMsg("/tr", "OUTPUT 3 (3)");});}};
if (msgi == 4){1.do{"OUTPUT 4 (4)".postln; if(n != nil,{n.sendMsg("/tr", "OUTPUT 4 (4)");});}};
};



},'/manag')