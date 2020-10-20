/**
(C) 2020 Rafaele Andrade  - Knurl 

**/

	"settings.scd".loadRelative;  
	
s.waitForBoot {

	n = NetAddr.new("127.0.0.1", 7562);    // create the NetAddr   //my screen 

	~buffertime = 5;
	~buftimewait = [~buffertime +1]; 


//take this out later
	d = Dictionary.new;
	n.sendMsg("/tr",
			d.put("sm:", "off");
			d.put("am:", "off");
			d.put("pm:", "off");
			d.put("dm:", "off");
	);
	n.sendMsg("/tr", 	d.cs);

	c = Buffer.alloc( s, ~buffertime * s.sampleRate, 1);
	~flow = 0.5;  //initial number for detection mode flow : this number will vary
		
		//Communication
		// "_ad_virus.scd".loadRelative;   //OSC Communication   //JUST TURN ON IF YOU HAVE INTERNET/COMPUTER CONECTON 
		// "_outvirus.scd".loadRelative; 
	
		//load synths & trackers
		"synth_synthmode.scd".loadRelative;
		"synth_analoguemode.scd".loadRelative;
		"synth_detectionmode.scd".loadRelative;
		
		//osc performances
		"_sender.scd".loadRelative;
		"_mic.scd".loadRelative;   //external synths
		
		//load oscdefs
		"osc_managment.scd".loadRelative;
		"osc_synthmode.scd".loadRelative;
		"osc_detectionmode_2.scd".loadRelative;
		"osc_programmingmode.scd".loadRelative;
		"osc_analoguemode.scd".loadRelative;
		
{ // Illustrates updating the baseline should the configuration change while the sketch is running
		loop {
			60.wait;
			"Reset Trill baseline in 10s...".postln;
			5.wait;
			"Baseline Reset".postln;
			~tr.set(\t_updateTrill, 1);
		};
	}.fork;
	
	//headphone level
s.sync;

// 

}