/***** osc_analoguemode.scd *****/

OSCdef(\analogmode, {|msg|
	var id = msg[2], mode = msg[3], pot = msg[4].asInt, an = msg[5];  //changer
	~mode = mode; 
	~id = id;
	~pot = pot;
	~an = an;
//mode,trg,bt,prm	


	[~id,~pot, ~an].postln;
	if(~mode == 2){   //analogmode
	


	
	 //an2
	if(~id == 109){  
		
		
		if(~reprAn == 'stop'){
		n.sendMsg("/tr", "am: off"); "am: stop all".postln; 
		fork{ ~am1.free ; ~am2.free; ~am3.free; ~am4.free; ~am5.free; ~am6.free; 
		1.wait;
		~am1 = nil; ~am2 = nil; ~am3 = nil; ~am4 = nil;~am5 = nil;~am6 = nil;
		}
		};
		if(~reprAn != 'stop') { 
			if(~am1 != nil){~am1.set(~reprAn, ~an)};
			if(~am2 != nil){~am2.set(~reprAn, ~an)};
			if(~am3 != nil){~am3.set(~reprAn, ~an)};
			if(~am4 != nil){~am4.set(~reprAn, ~an)};
			if(~am5 != nil){~am5.set(~reprAn, ~an)};
			if(~am6 != nil){~am6.set(~reprAn, ~an)};
			}
	};
	
	if(~id == 101){ ~reprAn = 'stop'; ~reprAn.postln};  //stop
	if(~id == 102){ ~reprAn = 'freq'.asSymbol; ~reprAn.postln};  //freq
	if(~id == 103){ ~reprAn = 'filter'.asSymbol;~reprAn.postln};		//filter
	if(~id == 104){ ~reprAn = 'mul'.asSymbol;~reprAn.postln};  //an
	//if(~id == 104){ ~reprAn = "mul"};  //rq

	
	// fork{    ///it's in fork because the function erase itself if not in a sequence
	// // d.put("am:", "on");
	// 1.wait;
	
	if(~id == 108){  //an1  //choose
	
	// n.sendMsg("/knurl/detect", "selecting osc. n." ++ ~pot ); 
	
	
	//intenger
	if (~pot == 1) { ~am1 = Synth(\HPF); "HPF".postln } ;   //don't complicate! turn off the synth everytime you want another one
	if (~pot == 2) { ~am2 = Synth(\LPF);"LPF".postln } ;
	if (~pot == 3) { ~am3 = Synth(\Notch); "Notch".postln } ;
	if (~pot == 4) { ~am4 = Synth(\Comb); "Comb".postln } ;
	if (~pot == 5) { ~am5 = Synth(\BPF); "BPF".postln } ;
	if (~pot == 6) { ~am6 = Synth(\Resonz); "Resonz".postln } ;
	
	// if ((~pot >= 1) && (~pot <= 1.9), { if(~am1==nil){b.sendMsg("/tr", "am: HPF"); if(n != nil){n.sendMsg("/knurl/trigger","HPF 1")};"HPF".postln; ~name =  'HPF'; ~am1 = Synth(\HPF);	
	// x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}/*,{ if( ~am1 != nil){~am1.set(\gate,-4); ~am1.free; ~am1 = nil /*n.sendMsg("/KnurlLab","HPF 0")*/);
	// if ((~pot >= 2) && (~pot <= 2.9), { if(~am2==nil){b.sendMsg("/tr", "am: LPF"); 
	// if(n != nil){n.sendMsg("/knurl/trigger","LPF 1")};"LPF".postln; ~name = 'LPF'; ~am2 = Synth(\LPF); 
	// x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 2]);}}/*,{if( ~am2 != nil){~am2.set(\gate,-4); ~am2.free; ~am2 = nil /*n.sendMsg("/KnurlLab","LPF 0")*/);
	
	// if ((~pot >= 3) && (~pot <= 3.9), { if(~am3==nil){b.sendMsg("/tr", "am: Notch"); if(n != nil){n.sendMsg("/knurl/trigger","Notch 1")};"Notch".postln; ~name = 'Notch'; ~am3 = Synth(\Notch);  ~ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 3]);}}/*,{ if( ~am3 != nil){~am3.set(\gate,-4); ~am3.free; ~am3 = nil/*n.sendMsg("/KnurlLab","Notch 0")*/);
	// if ((~pot >= 4) && (~pot <= 4.9), { if(~am4==nil){b.sendMsg("/tr", "am: Comb"); if(n != nil){n.sendMsg("/knurl/trigger","Comb 1")};"Comb".postln; ~name = 'Comb'; ~am4 = Synth(\Comb);   x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 4]);}}/*,{ if( ~am4 != nil){~am4.set(\gate,-4); ~am4.free; ~am4 = nil/*n.sendMsg("/KnurlLab","Comb 0")*/);
	// if ((~pot >= 5) && (~pot <= 5.9), { if(~am5==nil){b.sendMsg("/tr", "am: BPF"); if(n != nil){n.sendMsg("/knurl/trigger","BPF 1")};"BBF".postln; ~name =  'BPF'; ~am5 = Synth(\BBF);     x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 5]);}}/*,{ if( ~am5 != nil){~am5.set(\gate,-4); ~am5.free; ~am5 = nil/*n.sendMsg("/KnurlLab","BPF 0")*/);
	// // if ((~pot >= 6) && (~pot <= 7), { if(~am6==nil){b.sendMsg("/tr", "am: Resonz"); if(n != nil){n.sendMsg("/knurl/trigger","Resonz 1")}; "Resonz".postln; ~name = 'Resonz'; ~am6 = Synth(\Resonz);    x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 6]);}},{ if( ~am6 != nil){~am6.set(\gate,-4); ~am5.free; ~am6 = nil/*n.sendMsg("/KnurlLab","Resonz 0")*/}});
	
	//console KnurlLab
	// if(n != nil){n.sendMsg("/Knurl/trigger",~worksynth.cs);}
	
	};
	

	
	// }
	

	}
	
		
		

}, "/tram");


