/***** outvirus.scd *****/

OSCdef(\outvirus, {|msg|
	var  freq = msg[3], ampL = msg[4], bt = msg[5], an1  = msg[6], an2  = msg[7];  
	
    ~freq = freq;
    ~ampL = ampL;
    ~bt = bt;
    
    
    if (~function == 'send'){  //send
	m.sendMsg('/knurl', "Sending virus");
	if(m != nil,{ m.sendMsg('/knurl', ~freq, ~ampL, ~bt);  });  
	
    }
}, "/sendingvirus");

    /*****
{ // Illustrates updating the baseline should the configuration change while the sketch is running
		loop {
			60.wait;
			"Reset Trill baseline in 10s...".postln;
			5.wait;
			"Baseline Reset".postln;
			~tr.set(\t_updateTrill, 1);
		};
	}.fork;
	*****/