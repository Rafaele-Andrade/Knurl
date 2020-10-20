/***** osc_detectionmode_2.scd *****/

		
		
OSCdef(\detectmodefreq, {|msg|
	var id = msg[2], mode = msg[3],freqL = msg[4], freq = msg[5], flow = msg[6], ampL = msg[7], bt = msg[8];  
	//the current fre1, the avarage data , the flow trig, amp, button for timo
    var freqa, freqf,freqb,freqc,freqd,freqe,freqg;
    
    freq = freq*50;  //redesign to your tuning
    ~freqL = freqL;
    ~ampL = ampL;
    ~bt = bt;
    ~mode = mode;
    ~id = id;
    // freq = Gate.kr(freq, Impulse.kr(0.4));//Changed.kr();
    //freqL = freqL*100;
    
    	~freqa = freq*1.1;
		~freqb = freq*1.6;
		~freqc = freq*2.1;
		~freqd = freq*3;
		~freqe = freq*4;
		~freqf = freq*4;
		~freqg = freq*5.5;
		

	if(~mode == 3){   //detectionmode
	
	~flow = flow*0.1;
	["dm:" ++ ~flow ++ msg[3..] ].postln;

//sending to Timo
	if(n != nil ){n.sendMsg("/knurl/detect",  "freq:" ++ ~freqL); };
	if(n != nil ){n.sendMsg("/knurl/detect", "amp:" ++ ~ampL);  };
	if(n != nil ){n.sendMsg("/knurl/detect", "trig:" ++ ~bt ); };
	
	
	// if (freq <=  freqa ) { if(~dm1 ==nil){b.sendMsg("/tr", "dm: gap"); /*n.sendMsg("/KnurlLab","HPF 1");*/"gap".postln; ~dm1 = Synth(\gap);	 ~worksynth = ~dm1; x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}} {if( ~dm1 != nil){~dm1.set(\gate,-4); /*n.sendMsg("/KnurlLab","HPF 0")*/}};
	if ((~freqL >= ~freqa) &&  (~freqL <=  ~freqb) , { if(~dm2==nil){ if(n != nil  ,{n.sendMsg("/knurl/trigger", "reverb 1");});"reverb".postln; ~name = 'Reverb'; ~dm2 = Synth(\Reverb);	/* ~worksynth = ~dm2;*/ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}{~dm2.set(\gate,-4); ~dm2.free; ~dm2 = nil; "reverb free".postln/*n.sendMsg("/KnurlLab","HPF 0")*/}});
	if ((~freqL >= ~freqb) &&  (~freqL <=  ~freqc) , { if(~dm3==nil){ if(n != nil  ,{n.sendMsg("/knurl/trigger", "formlet 1");});"formlet".postln; ~name = 'Formlet'; ~dm3 = Synth(\Formlet);	/* ~worksynth = ~dm3; */x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}, {if( ~dm3 != nil){~dm3.set(\gate,-4);~dm3.free; ~dm3 = nil;  "formlet free".postln/*n.sendMsg("/KnurlLab","HPF 0")*/}});
	if ((~freqL >= ~freqc) &&  (~freqL <=  ~freqd) , { if(~dm4==nil){if(n != nil ,{n.sendMsg("/knurl/trigger", "delay 1");});"delay".postln; ~name = 'Delay'; ~dm4 = Synth(\Delay);	 /*~worksynth = ~dm4;*/ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}, {if( ~dm4 != nil){~dm4.set(\gate,-4); ~dm4.free; ~dm4 = nil; /*n.sendMsg("/KnurlLab","HPF 0")*/}});
	if ((~freqL >= ~freqd) &&  (~freqL <=  ~freqe) , { if(~dm5==nil){ if(n != nil ,{n.sendMsg("/knurl/trigger", "friction 1");}); ~name = 'Friction'; "friction".postln; ~dm5 = Synth(\Friction);	/* ~worksynth = ~dm5;*/ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}, {if( ~dm5 != nil){~dm5.set(\gate,-4);  ~dm5.free; ~dm5 = nil;/*n.sendMsg("/KnurlLab","HPF 0")*/}});
	if ((~freqL >= ~freqe) &&  (~freqL <=  ~freqf) , { if(~dm6==nil){ if(n != nil,{n.sendMsg("/knurl/trigger", "gap");});"gap".postln; ~name = 'Gap'; ~dm6 = Synth(\Gap);	/* ~worksynth = ~dm6;*/ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}, {if( ~dm6 != nil){~dm6.set(\gate,-4);  ~dm6.free; ~dm6 = nil;/*n.sendMsg("/KnurlLab","HPF 0")*/}});
	if ((~freqL >= ~freqf) &&  (~freqL <=  ~freqg) , { if(~dm7==nil){if(n != nil,{n.sendMsg("/knurl/trigger", "res");});"res".postln; ~name = 'Res'; ~dm7 = Synth(\Res);	 /*~worksynth = ~dm7;*/ x = Synth('blinker', ['outPin', 9, 'rate', 2, 'seq', 1]);}}, {if( ~dm7 != nil){~dm7.set(\gate,-4);  ~dm7.free; ~dm7 = nil;/*n.sendMsg("/KnurlLab","HPF 0")*/}});
			
	
	//knurl conosle
	// if(n != nil){n.sendMsg("/KnurlLab",~worksynth.cs);}	
	}
}, "/trdm");