OSCdef(\mode, { |msg| var id = msg[2], msgi = msg[3], msgu = msg[4];
var vstorage, homophonic, independent, dispersive, st;

//Update the function
~idi = id;
~msgi = msgi;
~msgu = msgu;


//msg.postln;
//x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 8]); //~a.free

~t = Task({ 
		fork{

            if(~a1 != nil){~a1.set(\gate, -5)};   //hey! attention! esse nome vc usa para analog 
            if(~a2 != nil){~a2.set(\gate, -5)};   //hey! attention! esse nome vc usa para analog 
            if(~a3 != nil){ ~a3.set(\gate, -5)};
            if(~a4 != nil){ ~a4.set(\gate, -5)};
            
            if(~b1 != nil){~b1.set(\gate, -5)};
            if(~b2 != nil){~b2.set(\gate, -5)};
            if(~b3 != nil){ ~b3.set(\gate, -5)};

            if(~c1 != nil){~c1.set(\gate, -5)};
            if(~c2 != nil){~c2.set(\gate, -5)};
            if(~c3 != nil){ ~c3.set(\gate, -5)};


           if(~d1 != nil){ ~d1.set(\gate, -5)};
           if(~d2 != nil){ ~d2.set(\gate, -5)};
           if(~d3 != nil){ ~d3.set(\gate, -5)};

         if(~motora != nil){ ~motora.set(\gate, -5)};
         if(~motorb != nil){ ~motorb.set(\gate, -5)};

			if(~input != nil){~input.set('gate',0)};
			if(~range != nil){~range.set('gate',0)};
			if(~mul != nil){  ~mul.set  ('gate',0)};
			if(~source != nil){~source.set('gate',0)};

            
		   if(~nv1 != nil){ ~nv1.set(\gate, -5)};
           if(~od1 != nil){ ~od1.set(\gate, -5)};
           if(~ss1 != nil){ ~ss1.set(\gate, -5)};
           if(~bm1 != nil){ ~bm1.set(\gate, -5)};
			
			if(~nv2 != nil){~nv2.set(\gate, -5.rand)};
            if(~od2 != nil){~od2.set(\gate, -5.rand)};
            if(~ss2 != nil){~ss2.set(\gate, -5.rand)};
            if(~bm2 != nil){~bm2.set(\gate, -5.rand)};
            
			if(~nv3 != nil){~nv3.set(\gate, -5.rand)};
			if(~od3 != nil){~od3.set(\gate, -5.rand)};
			if(~ss3 != nil){~ss3.set(\gate, -5.rand)};
            if(~bm3 != nil){~bm3.set(\gate, -5.rand)};
            
            if(~nv4 != nil){~nv4.set(\gate, -5.rand)};
            if(~od4 != nil){~od4.set(\gate, -5.rand)};
            if(~ss4 != nil){~ss4.set(\gate, -5.rand)};
            if(~bm4 != nil){~bm4.set(\gate, -5.rand)};
            
         
            
            1.do({
            ~a1 = nil;
            ~a2 = nil;
          	~a3 = nil;
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
            m.sendMsg("/knurlconsole", " ALL Synths off");
            1.wait;
            ~t.reset; 
            ~t.stop;}});

            
//MODE OF PERFORMANCES -inactive
if(~idi == 100){
if (~msgi == 0){"synth mode (0)".postln;  ~mode = 'SM'; if(n != nil,{n.sendMsg("/tr", "sm");});};
if (~msgi == 1){"programming mode (1)".postln; ~mode = 'PM'; if(n != nil ,{n.sendMsg("/tr", "pm");});};
if (~msgi == 2){"analogue mode (2)".postln; ~mode = 'AM'; if(n != nil ,{n.sendMsg("/tr", "am");});};
if (~msgi == 3){"detectmode (3)".postln;  ~mode = 'DM'; if(n != nil,{n.sendMsg("/tr", "dm");});};
};


//FUNCTION -inactive
if(~idi == 101){
if (~msgi == 0){"Play (0)".postln; ~function = 'play'; };
if (~msgi == 1){"Set (1)".postln;  ~function = 'set';};
if (~msgi == 2){"Stop (2)".postln; ~function = 'stop'; };
if (~msgi == 3){"Adjust (3)".postln;  ~function = 'adjust'; };
if (~msgi == 4){"Connect (4)".postln;  ~function = 'connect';};
};


// SUBFUNCTION  -inactive
if(~idi == 102){


		if (~function == 'play'){
			if (~msgi == 0){ ~subfunction = 'solo'; 'solo'.postln};
			if (~msgi == 1){ ~subfunction = 'group'; 'group'.postln};
			if (~msgi == 2){ ~subfunction = 'machine'; 'machine'.postln};
		};

		if (~function == 'set'){
			if (~msgi == 0){ ~subfunction = 'envelope'};
			if (~msgi == 1){ if(~subi == nil,{ ~subfunction = 'counterpoint'; ~subi =1},{ ~subfunction = 'counterpoint set';~subi = nil})};
			if (~msgi == 2){ ~subfunction = 'routing'};
			[~subfunction,~msgi].postln;
		};

		if (~function == 'stop'){
			if (~msgi == 0){ ~subfunction = 'stop all'; ~t.start};
			if (~msgi == 1){ ~subfunction = 'stop group'; };
			if (~msgi == 2){ ~subfunction = 'stop one'; };
			~subfunction.postln;
		};

		if (~function == 'adjust'){
			if (~msgi == 0){ ~subfunction = 'tune'};
			if (~msgi == 1){ ~subfunction = 'siri'};
			if (~msgi == 2){ ~subfunction = 'reset all'};
			~subfunction.postln;

		};
		
		if (~function == 'connect'){};
		//		fork{loop{n.sendMsg("/tr", "virus out"); 2.wait}}}; 

	
};


//  REWRITE -active
if(~idi == 103){

		if (~subfunction == 'solo'){
			~lastsynth.postln;
			if (~msgi == 0 ) { ~rewrite = 'freqamp';	~lastsynth.set('gatef', 1,'gateamp', 1,'gatefi', 0,'gatelin', 0); ' a1:freq/a2:amp'.postln};  // a1:freq/a2:amp
			if (~msgi == 1 ) { ~rewrite = 'filin';	~lastsynth.set('gatef', 0,'gateamp', 0,'gatefi', 1,'gatelin', 1);' a1:filter/a2:lin'.postln}; //a1:filter/a2:lin
			if (~msgi == 2 ) { ~rewrite = 'freeze';	~lastsynth.set('gatef', 0,'gateamp', 0,'gatefi', 0,'gatelin', 0); ' freeze'.postln};
		};
		
		if (~subfunction == 'group'){  //you will receive nil if one of the voices wasn't added 
		if (~msgi == 0)
		{
			~vstorage[0].set('gatef', 1,'gateamp', 1,'gatefi', 0,'gatelin', 0);
			~vstorage[1].set('gatef', 1,'gateamp', 1,'gatefi', 0,'gatelin', 0);
			~vstorage[2].set('gatef', 1,'gateamp', 1,'gatefi', 0,'gatelin', 0);
			~vstorage[3].set('gatef', 1,'gateamp', 1,'gatefi', 0,'gatelin', 0);
			'freq amp'.postln;  ~rewrite = 'freqamp';
		};

		if (~msgi == 1)
		{
			~vstorage[0].set('gatefi', 1,'gatelin', 1,'gatef', 0,'gateamp', 0);
			~vstorage[1].set('gatefi', 1,'gatelin', 1,'gatef', 0,'gateamp', 0);
			~vstorage[2].set('gatefi', 1,'gatelin', 1,'gatef', 0,'gateamp', 0);
			~vstorage[3].set('gatefi', 1,'gatelin', 1,'gatef', 0,'gateamp', 0);
			'filter lin'.postln;  ~rewrite = 'filin';
		};

		if (~msgi == 2)
		{
			~vstorage[0].set('gatef', 0,'gateamp', 0, 'gatefi', 0,'gatelin', 0);
			~vstorage[1].set('gatef', 0,'gateamp', 0, 'gatefi', 0,'gatelin', 0);
			~vstorage[2].set('gatef', 0,'gateamp', 0, 'gatefi', 0,'gatelin', 0);
			~vstorage[3].set('gatef', 0,'gateamp', 0, 'gatefi', 0,'gatelin', 0);
			'freezing group'.postln; ~rewrite = 'freeze';
		};
		~rewrite.postln;
		};

		if (~subfunction == 'machine'){
		
			if (~msgi == 0){ ~rewrite = 'motor1';
				if( ~motora == nil, {"motor 1 (on)".postln; ~motora = Synth('motor', ['outPin', 6])},{~motora.set(\gate,-4); ~motora = nil;"motor 1 (off)".postln;})};
			if (~msgi == 1){ ~rewrite = 'motor2';
				if( ~motorb == nil, {"motor 2 (on)".postln; ~motorb = Synth('motor', ['outPin', 7])},{~motorb.set(\gate,-4); ~motorb = nil;"motor 2 (off)".postln;})};
		~rewrite.postln;
		};
		
		if (~subfunction == 'synths'){
			if (~msgi == 0){ ~rewrite = 'freeze'};
			if (~msgi == 1){ ~rewrite = 'gate open'};
		};

		if (~subfunction == 'envelope'){
			if (~msgi == 0){ ~rewrite = 'stringsfade'};
			if (~msgi == 1){ ~rewrite = 'circular'};
			if (~msgi == 2){ ~rewrite = 'brass'};
		};

		if (~subfunction == 'counterpoint'){
			if (~msgi == 0){ ~rewrite = 'homophonic'; ~rewrite.postln; ~homophonic.start};
			if (~msgi == 1){ ~rewrite = 'dispersive'; ~rewrite.postln; ~dispersive.start};
			if (~msgi == 2){ ~rewrite = 'independent'; ~rewrite.postln; ~independent.start};
		};
		
		
		if (~subfunction == 'counterpoint set'){
			if (~msgi == 0){ ~rewrite = 'scaledtime';    ~scaledtime = ~a1.linlin(0,0.8,4,120); m.sendMsg('/knurlconsole', "scaledtime:" ++ ~scaledtime);};
			if (~msgi == 1){ ~rewrite = 'resetandstop';  ~dispersive.stop; ~dispersive.reset;  ~homophonic.stop; ~homophonic.reset;  ~independent.stop; ~independent.reset; };
			if (~msgi == 2){ ~rewrite = 'loop';};
		};

		if (~subfunction == 'routing'){
		~msgi = LinLin.kr(~msgi,0,0.7,0,3);
		~msgu = LinLin.kr(~msgu,0,0.7,0,3);
			if (~msgi == 0){ ~rewrite = 'in'; [~rewrite ++ ~msgi].postln; ~lastsynth.set('in',~msgi)};
			if (~msgi == 1){ ~rewrite = 'out'; [~rewrite ++ ~msgu].postln; ~lastsynth.set('out',~msgu)};
			
		};

		if ( ~subfunction == 'stop all'){ ~st.start};
		if ( ~subfunction == 'stop group'){vstorage[0].set('gate', -4); vstorage[1].set('gate', -4); vstorage[2].set('gate', -4); vstorage[3].set('gate', -4) };
		if ( ~subfunction == 'stop one'){~lastsynth.set('gate', -4)};

};


m.sendMsg('/knurlbuttons', ~mode, ~function, ~subfunction, ~rewrite);
//[~mode, ~function, ~subfunction, ~rewrite].postln
},'/manag')