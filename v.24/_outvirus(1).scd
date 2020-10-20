/***** virus.scd *****/
OSCdef(\outvirus, {|msg|
	var  freq = msg[3], ampL = msg[4].asFloat, bt = msg[5];  
	
	// msg[3..].postln;
    ~freq = freq;
    ~ampL = ampL;
    ~bt = bt;
    
	
	
	//sending messgaes to Timo, if he's online
	if(n != nil,{ n.sendMsg('/knurl/freq', ~freq);  });  //"vai".postln;
	if(n != nil,{ n.sendMsg('/knurl/amp', ~ampL*10);  });  //"vai".postln;
	if(n != nil,{ n.sendMsg('/knurl/bt', ~bt);  });  //"vai".postln;

}, "/trvirus");

    
{ // Illustrates updating the baseline should the configuration change while the sketch is running
		loop {
			60.wait;
			"Reset Trill baseline in 10s...".postln;
			5.wait;
			"Baseline Reset".postln;
			~tr.set(\t_updateTrill, 1);
		};
	}.fork;