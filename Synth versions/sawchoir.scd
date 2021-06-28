
// COMPUTER VERSION

Synth(\SinChoir)



SynthDef(\SinChoir, {
	|out=0, sus=0.49, freq=30, atk=8, amp=1, filter = 40, specint = 1, src = 1, rel=0.2, mod=0.8, lin=1, gate=1, curve=1,modFreq=80.1, modDur=0.24, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=12, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd, in, amc,pita,pitc,pitb,pitd, pit, pity, pite,hasFreq,ampOut;
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.3, 3); //70
	var linamp = LinLin.kr(  amp , 0.0,1, 0.02, 0.2);  //0.5
	var linfilter = LinLin.kr(  filter , 0.0,1, 4, 40); //1.2
	var linlin = LinLin.kr(  lin , 0.0,1, 0.22, 2.3);  //0.21
	var linsrc = LinLin.kr(  src , 0.0,1, 0.1, 0.9); //3100

	in = SoundIn.ar(0,1); //In.ar(2); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0; //SoundIn.ar([2,3],2);
	amc = Amplitude.kr(in,mul:linamp);
	ampOut = LinLin.kr(amc,0.002,0.1,0.4,1.9);


	#pit, hasFreq = Pitch.kr(in, ampThreshold: 0.09,median: 7);
	pity = Latch.kr(pit,pit * hasFreq);


	pita = Gate.kr(pity, Impulse.kr(linsrc));
	pitb = Gate.kr(pity*linspecint, Impulse.kr(0.7));
	pitc = Gate.kr(pity*linspecint*0.2, Impulse.kr(0.1));
	pitd = Gate.kr(pity*linspecint*0.7, Impulse.kr(0.3));
	pite = Gate.kr(pit, Impulse.kr(0.19));

	env = EnvGen.ar(Env([0, 0.23, 1, 0], [atk, amp, rel], [4,2,-2], curve), gate, 1, doneAction:2);
	osca = PMOsc.ar([pita +45,pita+95], 1 * 2, Line.kr(modFrom, modTo*0.1, modDur)) * 0.8 ;
	oscb = PMOsc.ar([pit,pitb+65] * 1/2, pitb * 0.25, Line.kr(modFrom, modTo*0.5, modDur*2)) * 0.3 ;
	oscc = PMOsc.ar([pit,pitc+67] * 1/6, pitc, Line.kr(modFrom, modTo, modDur*0.3)) * 0.20 ;
	oscd = PMOsc.ar([pit,pitd+98]* 0.25, pitd * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, linfilter, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));
	// sig = Pan2.ar(sig * env, StandardL.ar(70,1,lin,2));
  	Out.ar([0,1], sig*0.1!2);
}).add;



// BELA VERSION

SynthDef(\SinChoir, {
	|in = 0, out=0, sus=0.49, freq=30, atk=8, amp=1, filter = 40, specint = 1, src = 1, rel=0.2, mod=0.8, lin=1, gate=1, curve=1,modFreq=80.1, modDur=0.24, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=12, grEnvAtk=0.1, grEnvRel=0.5, gatef = 1, gateamp =1, gatefi = 1, gatelin = 1|
	var sig, env, osca, oscb, oscc, oscd, osce, inp ,pita,pitc,pitb,pitd, pit, pity, pite,hasFreq,ampOut;

	var linfreq = AnalogIn.ar(0).linlin(0.0,0.7, 0.3,3);
 	var linamp = AnalogIn.ar(1).linlin( 0.0,0.7, 0.02, 0.2);
	var linfilter = AnalogIn.ar(0).linlin( 0.0,0.7, 4, 20);
	var linlin = AnalogIn.ar(1).linlin(0.0,0.7, 0.1, 0.9);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	inp = SoundIn.ar(in,1);


	#pit, hasFreq = Pitch.kr(inp, ampThreshold: 0.09,median: 7);
	//The frequency of a highe mul is holded through this hold gate;
	pity = Latch.kr(pit,pit * hasFreq).poll(1);


	//Here I create a 'choir' of counterpoint by giving different impulses on each voice. Each voice also takes one different register (Soprano, COntralto , Tenor, BASS)
	pita = Gate.kr(pity, Impulse.kr(0.9));
	pitb = Gate.kr(pity*gatefreq, Impulse.kr(0.7));
	pitc = Gate.kr(pity*gatefreq*0.2, Impulse.kr(0.1));
	pitd = Gate.kr(pity*gatefreq*1.2, Impulse.kr(0.3));
	pite = Gate.kr(pit/2, Impulse.kr(0.05));

	env = EnvGen.ar(Env([0, 0.23, 1, 0], [atk, 1, rel], [4,2,-2], curve), gate, 1, doneAction:2);

	osca = PMOsc.ar([pity,pita], 1 * 2, Line.kr(modFrom, modTo*0.1, modDur)) * 0.8 ;
	oscb = PMOsc.ar([pity,pitb] * 1/2, pitb * 0.25, Line.kr(modFrom, modTo*0.5, modDur*2)) * 0.3 ;
	oscc = PMOsc.ar([pity,pitc] * 1/6, pitc, Line.kr(modFrom, modTo, modDur*0.3)) * 0.20 ;
	oscd = PMOsc.ar([pity,pitd]* 0.25, pitd * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	osce = PMOsc.ar([pity,pite]* 0.25, pite * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;

	sig = HPF.ar(osca + oscb + oscc + oscd, gatefilter, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));

	// sig = Pan2.ar(sig * env, StandardL.ar(70,1,lin,2));
  	Out.ar([0,1], sig*gateampl !2);
}).add;
