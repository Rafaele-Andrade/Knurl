/***** osc_programmingmode.scd *****/
/***** Oscdef_programingmode.scd *****/

OSCdef(\programingmode, {|msg|
	var vstorage, id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];


		~mode = mode;
		~id = id;
		~dig = dig;
		~count = count;

		vstorage = List.new(8);

if ( ~mode == 1){

if ( ~function == 'play'){  /***** play *****/

	if (~subfunc == 'solo' && ~rewrite == 'freq/amp' &&	~lastsynth != nil , {	~lastsynth.set('gatefreq', 1,'gateamp', 1,'gatefilter', 0,'gatelin', 0)});
	if (~subfunc == 'solo' && ~rewrite == 'filter/lin' &&	~lastsynth != nil, {	~lastsynth.set('gatefilter', 1,'gatelin', 1,'gatefreq', 0,'gateamp', 0)});
	if (~subfunc == 'solo' && ~rewrite == 'freeze', {	~lastsynth.set('gatefreq', 0,'gateamp', 0, 'gatefilter', 0,'gatelin', 0)});

	if (~subfunc == 'group' && ~rewrite == 'freq/amp',
	{
	vstorage[0].set('gatefreq', 1,'gateamp', 1,'gatefilter', 0,'gatelin', 0);
	vstorage[1].set('gatefreq', 1,'gateamp', 1,'gatefilter', 0,'gatelin', 0);
  vstorage[2].set('gatefreq', 1,'gateamp', 1,'gatefilter', 0,'gatelin', 0);
  vstorage[3].set('gatefreq', 1,'gateamp', 1,'gatefilter', 0,'gatelin', 0);
	});

	if (~subfunc == 'group' && ~rewrite == 'filter/lin',
	{
	vstorage[0].set('gatefilter', 1,'gatelin', 1,'gatefreq', 0,'gateamp', 0);
	vstorage[1].set('gatefilter', 1,'gatelin', 1,'gatefreq', 0,'gateamp', 0);
	vstorage[2].set('gatefilter', 1,'gatelin', 1,'gatefreq', 0,'gateamp', 0);
	vstorage[3].set('gatefilter', 1,'gatelin', 1,'gatefreq', 0,'gateamp', 0);
	});

	if (~subfunc == 'group' && ~rewrite == 'freeze',
	{
	vstorage[0].set('gatefreq', 0,'gateamp', 0, 'gatefilter', 0,'gatelin', 0);
	vstorage[1].set('gatefreq', 0,'gateamp', 0, 'gatefilter', 0,'gatelin', 0);
	vstorage[2].set('gatefreq', 0,'gateamp', 0, 'gatefilter', 0,'gatelin', 0);
	vstorage[3].set('gatefreq', 0,'gateamp', 0, 'gatefilter', 0,'gatelin', 0);
	});
};


if ( ~function == 'set'){  /***** play *****/
if(~subfunc == 'envelope') { ~lastsynth.set('startenv',)};

if(~subfunc == 'counterpoint') {~lastsynth == 1};

if(~subfunc == 'route') {
	fork{ 2.wait;
		if(~rewrite == 'in'){if(~dig == 1 && ~first == nil){ ~a1.set('out', ~counter)}};
			if(~rewrite == 'out'){ if(~dig == 1 && ~first == nil){ ~a1.set('out', ~counter)}};
			}
};

}
/***** -------------active buttons *****/
	if(~id == 101){
			fork{
			2.wait;
			if(~count == 1 && ~nv1 == nil, {  ~nv1 = Synth(\newvoice, [\bufnum, ~a]); 'recording a'.postln});
			if(~count == 2 && ~nv2 == nil, {  ~nv2 = Synth(\newvoice, [\bufnum, ~b]); 'recording b'.postln});
			if(~count == 3 && ~nv3 == nil, {  ~nv3 = Synth(\newvoice, [\bufnum, ~c]); 'recording c'.postln});
			if(~count == 4 && ~nv4 == nil, {  ~nv4 = Synth(\newvoice, [\bufnum, ~d]); 'recording d'.postln});

			if(~count == 1 && ~nv1 != nil, { vstorage.add(~nv1); 'recording a add group'.postln});
			if(~count == 2 && ~nv2 != nil, { vstorage.add(~nv2); 'recording b add group'.postln});
			if(~count == 3 && ~nv3 != nil, { vstorage.add(~nv3); 'recording c add group'.postln});
			if(~count == 4 && ~nv4 != nil, { vstorage.add(~nv4); 'recording d add group'.postln});
			};
		};

		if(~id == 102){
			fork{
			2.wait;
			if(~count == 1 && ~od1 == nil, {  ~od1 = Synth('overdubb', [\bufnum, ~a]); 'overdubble a'.postln});
			if(~count == 2 && ~od2 == nil, {  ~od2 = Synth('overdubb', [\bufnum, ~b]); 'overdubble b'.postln});
			if(~count == 3 && ~od3 == nil, {  ~od3 = Synth('overdubb', [\bufnum, ~c]); 'overdubble c'.postln});
			if(~count == 4 && ~od4 == nil, {  ~od4 = Synth('overdubb', [\bufnum, ~d]); 'overdubble d'.postln});

			if(~count == 1 && ~od1 != nil, { vstorage.add(~nv1); 'recording a add group'.postln});
			if(~count == 2 && ~od2 != nil, { vstorage.add(~nv2); 'recording b add group'.postln});
			if(~count == 3 && ~od3 != nil, { vstorage.add(~nv3); 'recording c add group'.postln});
			if(~count == 4 && ~od4 != nil, { vstorage.add(~nv4); 'recording d add group'.postln});
			};
		};

		if(~id == 103){
			fork{
			2.wait;
			if(~count == 1 && ~ss1 == nil, {  ~ss1 = Synth('simplestream', [\bufnum, ~a]); 'simplestream a'.postln});
			if(~count == 2 && ~ss2 == nil, {  ~ss2 = Synth('simplestream', [\bufnum, ~b]); 'simplestream b'.postln});
			if(~count == 3 && ~ss3 == nil, {  ~ss3 = Synth('simplestream', [\bufnum, ~c]); 'simplestream c'.postln});
			if(~count == 4 && ~ss4 == nil, {  ~ss4 = Synth('simplestream', [\bufnum, ~d]); 'simplestream d'.postln});

			if(~count == 1 && ~ss1 != nil, { vstorage.add(~ss1); 'recording a add group'.postln});
			if(~count == 2 && ~ss2 != nil, { vstorage.add(~ss2); 'recording b add group'.postln});
			if(~count == 3 && ~ss3 != nil, { vstorage.add(~ss3); 'recording c add group'.postln});
			if(~count == 4 && ~ss4 != nil, { vstorage.add(~ss4); 'recording d add group'.postln});
			};
		};

		if(~id == 104){
			fork{
			2.wait;
			if(~count == 1 && ~bm1 == nil, {  ~bm1 = Synth('beatmaker', ['bufnum', ~a]); 'beatmaker a'.postln});
			if(~count == 2 && ~bm2 == nil, {  ~bm2 = Synth('beatmaker', ['bufnum', ~b]); 'beatmaker b'.postln});
			if(~count == 3 && ~bm3 == nil, {  ~bm3 = Synth('beatmaker', ['bufnum', ~c]); 'beatmaker c'.postln});
			if(~count == 4 && ~bm4 == nil, {  ~bm4 = Synth('beatmaker', ['bufnum', ~d]); 'beatmaker d'.postln});

			if(~count == 1 && ~bm1 != nil, { vstorage.add(~bm1); 'recording a add group'.postln});
			if(~count == 2 && ~bm2 != nil, { vstorage.add(~bm2); 'recording b add group'.postln});
			if(~count == 3 && ~bm3 != nil, { vstorage.add(~bm3); 'recording c add group'.postln});
			if(~count == 4 && ~bm4 != nil, { vstorage.add(~bm4); 'recording d add group'.postln});
			};
		};

	};

	if ( ~function == 2){   /***** set *****/

			if(~id == 101){
			fork{
			2.wait;
			if(~count == 1){  ~buffertime = 1};
			if(~count == 2){  ~buffertime = 2};
			if(~count == 3){  ~buffertime = 3};
			if(~count == 4){  ~buffertime = 4};
			};
		};


	};

	if ( ~function == 1){   /***** stop *****/

	}
}
}, "/trpm");
