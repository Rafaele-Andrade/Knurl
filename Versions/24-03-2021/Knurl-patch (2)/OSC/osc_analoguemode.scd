/***** osc_analoguemode.scd *****/

OSCdef(\analogmode, {|msg|
	var id = msg[2], mode = msg[3], but= msg[4];  //changer

	~mode = mode;     //analogue mode
	~id = id;         //id
	~but = but;

 	//In the analgue mode I use the approach matrix because It allows to reach more variations with less movements. I will navigate thourgh a matrix x y , x being music parameters chosed on the m1 , y for phys data m2
//risks: you have to be very precise, first I will be trying a small matrix of 4 possibilities each axis

	if(~mode == 2){   //analogmod

//In the analgue mode I use the approach matrix because It allows to reach more variations with less movements. I will navigate thourgh a matrix x y , x being music parameters chosed on the m1 , y for phys data m2
//risks: you have to be very precise, first I will be trying a small matrix of 4 possibilities each axis


	//////////////////// CHOOSE RAW SOUND
	
	if(~id == 108){

	  "Hello ".postln; 
	// n.sendMsg("/knurl/detect", "selecting osc. n." ++ ~pot ); 
	t = Task({
	fork{
																																			//Select
	if ((~but == 1) && (~am1 == nil),{  "HPF".postln }) ;   //don't complicate! turn off the synth everytime you want another one
	if ((~but == 2) && (~am2 == nil),{ "LPF".postln } );
	if ((~but == 3) && (~am3 == nil), {  "Notch".postln }) ;
	if ((~but == 4) && (~am4 == nil),{  "Comb".postln } );
	if ((~but == 5) && (~am5 == nil),{  "BPF".postln } );
	if ((~but == 6) && (~am6 == nil),{  "Resonz".postln }) ;
	if ((~but == 7) && (~am6 == nil),{  "Resonz".postln }) ;
	
	0.1.wait;
																																			//Evaluate	
	if ((~but == 1) && (~am1 == nil),{ ~am1 = Synth(\HPF); "HPF on".postln; n.sendMsg("/tr", "HPF") }) ;   //don't complicate! turn off the synth everytime you want another one
	if ((~but == 2) && (~am2 == nil),{ ~am2 = Synth(\LPF);"LPF".postln; n.sendMsg("/tr", "LPF"); } );
	if ((~but == 3) && (~am3 == nil), {~am3 = Synth(\Notch); "Notch".postln; n.sendMsg("/tr", "Notch 1"); }) ;
	if ((~but == 4) && (~am4 == nil),{ ~am4 = Synth(\Comb); "Comb".postln; n.sendMsg("/tr", "Comb"); } );
	if ((~but == 5) && (~am5 == nil),{ ~am5 = Synth(\BPF); "BPF".postln; n.sendMsg("/tr", "BPF"); } );
	if ((~but == 6) && (~am6 == nil),{ ~am6 = Synth(\Resonz); "Resonz".postln ; n.sendMsg("/tr", "Resonz");}) ;
	if ((~but == 7) && (~am6 == nil),{ ~am6 = Synth(\Resonz); "Resonz".postln ; n.sendMsg("/tr", ~lpot);}) ;
		}
	});
	t.reset;
	t.start;
	};
	

	//////////////////// REWRITE 
		
	if(~id == 101){ ~reprAn = 'stop one'.asSymbol; ~reprAn.postln};  //stop
	if(~id == 102){ ~reprAn = 'freq'.asSymbol; ~reprAn.postln};  //freq
	if(~id == 103){ ~reprAn = 'filter'.asSymbol;~reprAn.postln};		//filter
	if(~id == 104){ ~reprAn = 'mul'.asSymbol;~reprAn.postln};  //an


	//////////////////// COMPOSING THE CONNECTIONS

	 
	 //an2
	if(~id == 109){  

	 
	////////////////////
		
		if(~reprAn == 'stop one') {    //stop one synth
			t = Task({
	fork{
		//select
			if((~but == 1) && (~am1 != nil),{"HPF sel".postln;  });  
			if((~but == 2) && (~am2 != nil),{"LPF sel".postln});
			if((~but == 3) && (~am3 != nil),{"Notch sel".postln});
			if((~but == 4) && (~am4 != nil),{"am4".postln});
			if((~but == 5) && (~am5 != nil),{"am5".postln});
			if((~but == 6) && (~am6 != nil),{~am6.postln});
			
		
		2.wait; 
		if(~reprAn == 'stop one'){
			
	
		//connect
			if((~but == 1) && (~am1 != nil),{~am1.set(\gate, -4);  "stoped".postln; });
			if((~but == 2) && (~am2 != nil),{~am2.set(\gate, -4); });
			if((~but == 3) && (~am3 != nil),{~am3.set(\gate, -4); });
			if((~but == 4) && (~am4 != nil),{~am4.set(\gate, -4); });
			if((~but == 5) && (~am5 != nil),{~am5.set(\gate, -4); });
			if((~but == 6) && (~am6 != nil),{~am6.set(\gate, -4); });
			};
	}});
		t.reset;
		t.start;
	
			};
			
};

	
	
	
	////////////////////	connect analogue range to variable
			
		if(~reprAn == 'change') {    //for variable chnages
			t = Task({
	fork{
			if((~but == 1) && (~am1 != nil),{~am1.postln});
			if((~but == 2) && (~am2 != nil),{~am2.postln});
			if((~but == 3) && (~am3 != nil),{~am3.postln});
			if((~but == 4) && (~am4 != nil),{~am4.postln});
			if((~but == 5) && (~am5 != nil),{~am5.postln});
			if((~but == 6) && (~am6 != nil),{~am6.postln});
		2.wait; 
		if(~reprAn == 'change') { 
			if((~but == 1) && (~am1 != nil),{~am1.set(~reprAn, ~an)});
			if((~but == 2) && (~am2 != nil),{~am2.set(~reprAn, ~an)});
			if((~but == 3) && (~am3 != nil),{~am3.set(~reprAn, ~an)});
			if((~but == 4) && (~am4 != nil),{~am4.set(~reprAn, ~an)});
			if((~but == 5) && (~am5 != nil),{~am5.set(~reprAn, ~an)});
			if((~but == 6) && (~am6 != nil),{~am6.set(~reprAn, ~an)});
			};
	}});
		t.reset;
		t.start;
	
			}
	
	

		
	};  	///// mode end
		
	
}, "/tram");