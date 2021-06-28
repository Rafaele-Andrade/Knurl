/***** osc_analoguemode.scd *****/

OSCdef(\analogmode, {|msg|
	var id = msg[2], mode = msg[3], function = msg[4], rewrite = msg[5],  but= msg[6], an1 = msg[7], an2 = msg[8] ;  //changer

	~moding = mode;     //analogue mode
	~ido = id;         //id
	~but = but;
	~funct = function;
	~rewriti = rewrite;
	~an1 = an1;
	~an2 = an2;
	
	if(~moding == 2){   //analogmod


	if(~funct == 0){ //play 

		
	if(~ido == 104,
	{ if(~input == nil, 
			{ fork {~input = Synth('Input'); 'input'.postln; 1.wait; ~input.set(\gatefi ,0 ,  \gatemul ,0 );} },    //FIRST TIME PRESSING
			{ if(~gatei == nil,
						{~input.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,1 ,  \gatemul ,1); ~gatei = 1;   'hold inp src input'.postln},   //SECOND TIME PRESSING
						{~input.set(\gatesrc, 1 ,\gateinp ,1 ,  \gatefi ,0 ,  \gatemul ,0); ~gatei = nil; 'hold fi lin input'.postln});}
	)},
	{ if(~input != nil){~input.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0); 'hold all input'.postln}}
	);
	
	if(~ido == 103,
	{ if(~range == nil, 
			{ fork {~range = Synth('Range'); 'input'.postln; 1.wait; ~range.set(\gatefi ,0 ,  \gatemul ,0 );} },    //FIRST TIME PRESSING
			{ if(~gatei == nil,
						{~range.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,1 ,  \gatemul ,1); ~gatei = 1;   'hold inp src input'.postln},   //SECOND TIME PRESSING
						{~range.set(\gatesrc, 1 ,\gateinp ,1 ,  \gatefi ,0 ,  \gatemul ,0); ~gatei = nil; 'hold fi lin input'.postln});}
	)},
	{ if(~range != nil){~range.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0); 'hold all input'.postln}}
	);
	
	if(~ido == 102,
	{ if(~mul == nil, 
			{ fork {~mul = Synth('Multiply'); 'input'.postln; 1.wait; ~mul.set(\gatefi ,0 ,  \gatemul ,0 );} },    //FIRST TIME PRESSING
			{ if(~mul == nil,
						{~mul.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,1 ,  \gatemul ,1); ~gatei = 1;   'hold inp src input'.postln},   //SECOND TIME PRESSING
						{~mul.set(\gatesrc, 1 ,\gateinp ,1 ,  \gatefi ,0 ,  \gatemul ,0); ~gatei = nil; 'hold fi lin input'.postln});}
	)},
	{ if(~mul != nil){~mul.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0); 'hold all input'.postln}}
	);
	
	if(~ido == 101,
	{ if(~source == nil, 
			{ 
		fork{
		1.do{~input.free; ~range.free; ~mul.free};
		2.wait;
		~source = Synth('Source', [\out , 0, \in, 3 , \infi, 4 ,\inmul, 5]);
		0.5.wait;
		~input = Synth(\Input, [\out , 3, \in, 0]);
		~range  = Synth(\Range, [\out , 4, \in, 0]);
		~mul = Synth(\Multiply, [\out , 5, \in, 0]);
		0.5.wait;
		(
				~input.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
				~range.set(\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 );
				~mul.set( \gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0 )
			);
		10.wait;
		
		}; },    //FIRST TIME PRESSING
			{ if(~source == nil,
						{~source.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,1 ,  \gatemul ,1); ~gatei = 1;   'hold inp src input'.postln},   //SECOND TIME PRESSING
						{~source.set(\gatesrc, 1 ,\gateinp ,1 ,  \gatefi ,0 ,  \gatemul ,0); ~gatei = nil; 'hold fi lin input'.postln});}
	)},
	{ if(~source != nil){~source.set(\gatesrc, 0 ,\gateinp ,0 ,  \gatefi ,0 ,  \gatemul ,0); 'hold all input'.postln}}
	);
	
	
	if(~rewriti == 1){ //play routing outputs
		
	if(~ido == 101){ if(~input== nil){ fork{ 2.wait; ~input.set('out',~but)}}};  
	if(~ido == 102){ if(~range== nil){ fork{ 2.wait; ~range.set('out',~but)}}};  
	if(~ido == 103){ if(~mul== nil)  { fork{ 2.wait; ~mul.set('out',~but)}}};  
	if(~ido == 104){ if(~source== nil){fork{ 2.wait; ~source.set('out',~but)}}};  
	};
	
	if(~rewriti == 2){ //play routing inputs
		
	if(~ido == 101){ if(~input== nil){ fork{ 2.wait; ~input.set('in',~but)}}};  
	if(~ido == 102){ if(~range== nil){ fork{ 2.wait; ~range.set('in',~but)}}};  
	if(~ido == 103){ if(~mul== nil)  { fork{ 2.wait; ~mul.set('in',~but)}}};  
	if(~ido == 104){ if(~source== nil){fork{ 2.wait; ~source.set('in',~but)}}};  
	};
	
	
	}; //play 

	if(~funct == 1){ //set
		
	if(~rewriti == 0){ //set freq amp
		
	if(~ido == 101,{ ~input.set('freq',~an1 , 'amp',~an2, 'gatef1',1)},{~input.set('gatef1',0)});
	if(~ido == 102,{ ~range.set('freq',~an1 , 'amp',~an2, 'gater1',1)},{~input.set('gater1',0)});
	if(~ido == 103,{ ~mul.set  ('freq',~an1 , 'amp',~an2, 'gatem1',1)},{~input.set('gatem1',0)});
	if(~ido == 104,{ ~source.set('freq',~an1 , 'amp',~an2, 'gates1',1)},{~input.set('gates1',0)});

	};
	
	if(~rewrite == 1){ //set lin amp
		
	if(~ido == 101,{ ~input.set('freq',~an1 , 'amp',~an2, 'gatef2',1)},{~input.set('gatef2',0)});
	if(~ido == 102,{ ~range.set('freq',~an1 , 'amp',~an2, 'gater2',1)},{~input.set('gater2',0)});
	if(~ido == 103,{ ~mul.set  ('freq',~an1 , 'amp',~an2, 'gatem2',1)},{~input.set('gatem2',0)});
	if(~ido == 104,{ ~source.set('freq',~an1 , 'amp',~an2, 'gates2',1)},{~input.set('gates2',0)});

	};
	
	}; //set 

	if(~funct == 2){ //stop 
		
	if(~id == 101,{ ~input.set('gate',0);  ~input = nil});
	if(~id == 102,{ ~range.set('gate',0);  ~range = nil });
	if(~id == 103,{ ~mul.set  ('gate',0);  ~mul = nil });
	if(~id == 104,{ ~source.set('gate',0); ~source = nil});

		
	}; //stop 



		
	};  	///// mode end
		
	
}, "/tram");