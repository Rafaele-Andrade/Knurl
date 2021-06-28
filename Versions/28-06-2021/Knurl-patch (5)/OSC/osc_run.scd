/***** osc_run.scd *****/
OSCdef(\mod, { |msg| var id = msg[2], msgi = msg[3], msgu = msg[4];
var vstorage, homophonic, independent, dispersive, st;
~ida = id;
//Update the function

if (~ida == 110){  ~lastsynth.set('freq',msgi, 'amp', msgu,'filter',msgi, 'lin', msgu);  };

//if (~ida == 111){  ~a1 = msgi; ~a2 =  msgu};

},'/runner')