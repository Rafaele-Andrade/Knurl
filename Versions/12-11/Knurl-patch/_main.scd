/**
(C) 2020 Rafaele Andrade  - Knurl 

**/

	"settings.scd".loadRelative;  
	
s.waitForBoot {

	n = NetAddr.new("127.0.0.1", 7562);    // create the NetAddr   //my screen //"127.0.0.1"

	~buffertime = 5;
	~buftimewait = [~buffertime +1]; 


//take this out later
	d = Dictionary.new;
		
		
		~minrangecap = 100;
		~maxrangecap = 200;
		
	n.sendMsg("/tr", "Hello Dear, let's play!"); 
    
	c = Buffer.alloc( s, ~buffertime * s.sampleRate, 1);
	~flow = 0.5;  //initial number for detection mode flow : this number will vary
		
		//Communication
		// "/VIRUS/advirus.scd".loadRelative;   //OSC Communication   //JUST TURN ON IF YOU HAVE INTERNET/COMPUTER CONECTON 
		// "/VIRUS/outvirus.scd".loadRelative; 
	
		//load synths & trackers
		"/SYNTH/synth_synthmode.scd".loadRelative;
		"/SYNTH/synth_analoguemode.scd".loadRelative;
		"/SYNTH/synth_detectionmode.scd".loadRelative;
		
		//osc performances
		"sender.scd".loadRelative;
		"/OSC/osc_hybridsound.scd".loadRelative;   //external synths
		
		//load oscdefs
		"/OSC/osc_management.scd".loadRelative;
		"/OSC/osc_synthmode.scd".loadRelative;
		"/OSC/osc_detectionmode.scd".loadRelative;
		"/OSC/osc_programmingmode.scd".loadRelative;
		"/OSC/osc_analoguemode.scd".loadRelative;
		

		
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