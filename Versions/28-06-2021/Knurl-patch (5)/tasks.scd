/***** tasks.scd *****/
	(
		~t = Task({ 
		fork{
            ~am1.set(\gate,-4);
            ~am2.set(\gate,-4);
            ~am3.set(\gate,-4);
            ~am4.set(\gate,-4);
            ~am5.set(\gate,-4);
            ~am6.set(\gate,-4);

            ~a1.set(\gate, -5.rand);
            ~a2.set(\gate, -5.rand);
            //~a3.set(\gate, -5.rand);
            ~a4.set(\gate, -5.rand);

            ~b1.set(\gate, -5.rand);
            ~b1.set(\gate, -5.rand);
            ~b2.set(\gate, -5.rand);
            ~b3.set(\gate, -5.rand);
            ~b4.set(\gate, -5.rand);

            ~c1.set(\gate, -5.rand);
            ~c2.set(\gate, -5.rand);
            ~c3.set(\gate, -5.rand);
            ~c4.set(\gate, -5.rand);

            ~d1.set(\gate, -5.rand);
            ~d2.set(\gate, -5.rand);
            ~d3.set(\gate, -5.rand);
            ~d4.set(\gate, -5.rand);
            
            ~motora.set(\gate,-4); 
            ~motorb.set(\gate,-4); 

            3.wait;
            1.do({
            ~a1 = nil;
            ~a2 = nil;
          //	~a3 = nil;
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
            n.sendMsg("/tr", " ALL Synths gate -4");
            1.wait;t.reset; t.stop;}});


 ~homophonic = Task({
 	fork{
	
	~scaledtime.wait;	
	{
		~vstorage[0].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
		~vstorage[1].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
		~vstorage[2].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
		~vstorage[3].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
	};
	~scaledtime.wait;
	{
		~vstorage[0].set('freq', ~an1,'amp', 0, 'filter', ~an2,'lin', 0);
		~vstorage[1].set('freq', ~an1,'amp', 0, 'filter', ~an2,'lin', 0);
		~vstorage[2].set('freq', ~an1,'amp', 0, 'filter', ~an2,'lin', 0);
		~vstorage[3].set('freq', ~an1,'amp', 0, 'filter', ~an2,'lin', 0);
	};
	~scaledtime.wait;
	{
		~vstorage[0].set('freq', ~an2,'amp', 0, 'filter', ~an1,'lin', 0);
		~vstorage[1].set('freq', ~an2,'amp', 0, 'filter', ~an1,'lin', 0);
		~vstorage[2].set('freq', ~an2,'amp', 0, 'filter', ~an1,'lin', 0);
		~vstorage[3].set('freq', ~an2,'amp', 0, 'filter', ~an1,'lin', 0);
	};
		
}
 });
 
 
  ~independent = Task({
fork{
	
	~scaledtime.wait;	
	{
		~vstorage[0].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
		~vstorage[3].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
	};
	~scaledtime.wait;
  {
    ~vstorage[1].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
    ~vstorage[2].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
  };
  	~scaledtime.wait;
    {
  		~vstorage[0].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
  		~vstorage[3].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
  	};
  	~scaledtime.wait;
    {
      ~vstorage[1].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
      ~vstorage[2].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
    };
    ~scaledtime.wait;
      {
        ~vstorage[0].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
        ~vstorage[3].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
      };
     ~scaledtime.wait;
      {
        ~vstorage[1].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
        ~vstorage[2].set('freq', 0,'amp', 0, 'filter', 0,'lin', 0);
      };
      
		
}
  });
  
  
   ~dispersive = Task({
loop{
	
	m.sendMsg('/knurlconsole', "Counterpoint dispersive '1 phase'");
	'1 phase'.postln;
	1.do{
		~vstorage[0].set('freq', 0.10,'amp', 1.0, 'filter', 0.0,'lin', 0.75);
		~vstorage[1].set('freq', 0.10,'amp', 1.0, 'filter', 0.0,'lin', 0.75);
		~vstorage[2].set('freq', 0.10,'amp', 0.50, 'filter', 0.50,'lin', 0.5);
		~vstorage[3].set('freq', 0.10,'amp', 0.50, 'filter', 0.50,'lin', 0.5);
	};
	~scaledtime.wait;
	m.sendMsg('/knurlconsole', "Counterpoint dispersive '2 phase'");
		'2 phase'.postln;
	1.do{
		~vstorage[0].set('freq', 0.8,'amp', 0.5, 'filter', 0.8,'lin', 0.5);
		~vstorage[1].set('freq', 2,'amp', 0.15, 'filter', 2,'lin', 0.5);
		~vstorage[2].set('freq', 0.1,'amp', 0.5, 'filter', 0.1,'lin', 0.5);
		~vstorage[3].set('freq', 0.5,'amp', 0.5, 'filter', 0.5,'lin', 0.5);
	};
	~scaledtime.wait;
	m.sendMsg('/knurlconsole', "Counterpoint dispersive '3 phase'");
	'3 phase'.postln;
	1.do{
		~vstorage[0].set('freq', 0,'amp', 1.50, 'filter', 0,'lin', 0.50);
		~vstorage[1].set('freq', 0,'amp', 1.50, 'filter', 0,'lin', 0.50);
		~vstorage[2].set('freq', 0,'amp', 1.50, 'filter', 0,'lin', 0.50);
		~vstorage[3].set('freq', 0,'amp', 1.50, 'filter', 0,'lin', 0.50);
	};
	~scaledtime.wait;
		
}
   });
      )