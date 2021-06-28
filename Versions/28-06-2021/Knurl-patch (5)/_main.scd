/**
KNURL
(C)Knurl lab  2020-2021

Knurl runs its communication through OSC messages. A function at "sender.scd" will send selected data to OSCDefs (functions) through specific ports.

This is sort of adaptation of a C++ programming design where you have a function defining and another organazing blocks of code.

This patch is suppose to run at Bela with these electronics settings:

4 INPUTS
4 OUTPUTS
4 LEDS
2 MOTORS
2 PoT
1 TRILCRAFT SENSOR (using 24 Pins)

**/

	"settings.scd".loadRelative;	//Load these settings file because the bela settings seems to not effect your configurations
	"/OSC/osc_hybridsound.scd".loadRelative;   // This file has the standard mic synth
	"tasks.scd".loadRelative;

s.waitForBoot {
		//START MODE
		~mode = 'SM';
		~function = 'play';
		~subfunction = 'solo'; 
		~rewrite = 'freqamp';
		~scaledtime =10;

	//Network
	n = NetAddr.new("127.0.0.1", 7562);    // inner NetAddr, here I send post messages to myself, such as:
	n.sendMsg("/tr", "Hello world! I am Knurl!");

	//Standard sound
	~a3 = Synth(\Rawsound);  


	~vstorage = List.new(4);
	~vstoragename = List.new(4);

	//	b = Buffer.read(s, "knurl_test_2.wav"); // remember to free the buffer later.


	//Buffer
	~buffertime = 5;
	~buftimewait = [~buffertime +1];
	
		
	~a = Buffer.alloc(s, 44100 * 2, 1 );
	~b = Buffer.alloc(s, 44100 * 2, 1 );
	~c = Buffer.alloc(s, 44100 * 2, 1 );
	c = Buffer.alloc(s, 44100 * 2, 1 );
	~d = Buffer.alloc(s, 44100 * 2, 1 );
	

	~tap = Buffer.alloc(s, 44100 * 2, 2);
	~flow = 0.5;  //initial number for detection mode flow : this number will vary
	


		//OSC SENDER
				"sender.scd".loadRelative;


		//OSC RECEIVER
			"/OSC/osc_management.scd".loadRelative;
			"/OSC/osc_run.scd".loadRelative;
			"tasks.scd".loadRelative;
			
		//Communication
				 "/VIRUS/advirus.scd".loadRelative;   //OSC Communication to receive //JUST TURN ON IF YOU HAVE INTERNET/COMPUTER CONNECTON
	//					 "/VIRUS/outvirus.scd".loadRelative;  //OSC Communication to send to platform or musicians  //JUST TURN ON IF YOU HAVE INTERNET/COMPUTER CONNECTON

		//Load synths & trackers
				"/SYNTH/synth_synthmode.scd".loadRelative;
				"/SYNTH/synth_analoguemode.scd".loadRelative;
		//	"/SYNTH/synth_detectionmode.scd".loadRelative;
				"/SYNTH/synth_programmingmode.scd".loadRelative;
		
		//load oscdefs
				"/OSC/osc_synthmode.scd".loadRelative;
		//		"/OSC/osc_detectionmode.scd".loadRelative;
				"/OSC/osc_programmingmode.scd".loadRelative;
				 "/OSC/osc_analoguemode.scd".loadRelative;
	//

s.sync;

//

}