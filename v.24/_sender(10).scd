/***** set_trillraw.scd *****/
(
k = 5;
~ndims = 1;
~kbuf = Buffer.alloc(s, k, ~ndims+1);

		
	SynthDef(\raw,{|t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 10;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x19; // I2C address of Trill sensor
	var noiseThresh = 40; // noise threshold, int: 5-255 (255=highest threshold)  //10
	var prescalerOpt = 4; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)
	var rawvals;
	var sig, ping,d1, gt, pc,ch ,step,t_trig_1;
	var ch1,pc1,gt1,step1,	t_trig_2 ;
	var ch2,pc2,gt2,step2,	t_trig_3 ;
	var ch3,pc3,gt3,step3,	t_trig_4 ;
	var mode, ch5;
	var lp0,lp1,lp2,lp3;
	var ch6,ch7, step6,step7, t_trig_am6, t_trig_am7;
	var in,freqT,hasFreq, sp1,sp2,sp3,sp4,sp5,sp6,mfcc,cent;   //color constitution
	var chl1;
	var amp;
	var tch,tch1,tch2,tch3;
	var cch,cch1,cch2,cch3, trmode, dig, dig1, dig2,dig3,trgt2,red,trred,an1but,an2but;
	var t_trig_8,t_trig_9;
	var chain, chaintrig, features, kbuf, classif, centroid, resynth;
	var bi1,bi2,bi3,bi4;
	var bt1,bt2,bt3,bt4;
	var t_trig_dm, op, inr,indel,inraw,res;
	var resa,reso,resn,result; 
	var resamp, resampo,resampn;
	var champ,stepamp,tramp;
	var an0,an1,an2,an3,an4,an5,an;
	var steppot1, chpot1,a;
	var stepc, stepc1, stepc2, stepc3;
	var stepi, stepi1, stepi2, stepi3;
	var potlin1, potlin2;
	var flow, flowa, flowaa, fra, fraq,fraqq, timo,timoa;
	
	//define buttons
	var ampGen = 2;
	var b1 = 1;
	var b2 = 2;
	var b3 = 3;//22;
	var b4 = 4;
	
	var m1 = 6;//7;//6;   modes
	var m2 = 7;    //stop all
	//var m3 = 8;   //   var switch
	//var m4 = 9; 
	
	var a1 = 5;//8;   //do lado dos digitais
	var a2 = 12;//9;   //do lado do managment
	
	// ~light1 = 1;  //sm  - blue
	// ~light2 = 5;  //pm  - green
	// ~light3 = 9;  //am  - yellow
	// ~light3 = 11;  //dm  - white
	
	// ~light3 = 3;  //stop  - red
	
    //--------------------------------------------------------- SoundIn
	in = SoundIn.ar(2,2); ///sensitivity
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 0.7); //pitch works but it is very heavy for bela
	amp = Amplitude.kr(in);
	
	 //--------------------------------------------------------- basic
	rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThresh, prescalerOpt, t_updateTrill);
	
		
	bt1 = rawvals[b1]/rawvals[b1];      //binary trigger
	bt2 = rawvals[b2]/rawvals[b2]; 
	bt3 = rawvals[b3]/rawvals[b3]; 
	bt4 = rawvals[b4]/rawvals[b4]; 
	
	bi1 = Trig.kr(bt1);              //o resultado é 1 ou zero
	bi2 = Trig.kr(bt2);  
	bi3 = Trig.kr(bt3);  
	bi4 = Trig.kr(bt4);  
	
	//--------------------------------------------------------- detectmode  (Autocorrelation)

			// inr = in.abs;
			// op = OnePole.ar(inr, 0.999);
			// inraw = op.log10*20;
			// indel =  DelayN.ar(inraw,0.002,0.002);
			// res =	((inraw - indel)*0.5);  //db per msec
		
			// //calcular a media do inico e fim  res
			// resa = Gate.kr( (
			// 	reso = Latch.kr(res,Impulse.kr(0.5));
			// 	resn = Latch.kr(res,Impulse.kr(0.09));
			// 	result = (resn/reso)*(-1);
			// 	), Trig.kr(res));
			
			// //calcular a media do inico e fim  amp
			// resamp = Gate.kr( (
			// 	resampo = Latch.kr(amp,Impulse.kr(0.5));
			// 	resampn = Latch.kr(amp,Impulse.kr(0.2));
			// 	resamp = (resampn /resampo)*(-1);
			// 	), Trig.kr(amp));

	
	//-------------------------------------------------------- start-to-start interval button 
	// ch = Trig.kr(Changed.kr(rawvals[1]),0.35);
	// gt = Trig.kr(Changed.kr(ch),0.25); //attenuate the reset
	// pc = Stepper.kr(Impulse.kr(10), gt,0.0,80);  //attenuate the data input
	
	 
	// ch1 = Trig.kr(Changed.kr(rawvals[2]),0.35);
	// gt1 = Trig.kr(Changed.kr(ch1),0.25); //attenuate the reset
	// pc1 = Stepper.kr(Impulse.kr(10), gt1,0.0,80);  //attenuate the data input
	

	// ch2 = Trig.kr(Changed.kr(rawvals[3]),0.35);
	// gt2 = Trig.kr(Changed.kr(ch2),0.25); //attenuate the reset
	// pc2 = Stepper.kr(Impulse.kr(10), gt2,0.0,80);  //attenuate the data input
	// trgt2 = Trig.kr(pc2);
	
	// ch3 = Trig.kr(Changed.kr(rawvals[4]),0.35);
	// gt3 = Trig.kr(Changed.kr(ch3),0.25); //attenuate the reset
	// pc3 = Stepper.kr(Impulse.kr(10), gt3,0.0,80);  //attenuate the data input
	
	
	//--------------------------------------------------------interval button 

	cch = Trig.kr(Changed.kr(rawvals[b1]),Gate.kr(0.6,Changed.kr(rawvals[b1])));
	cch1 = Trig.kr(Changed.kr(rawvals[b2]),Gate.kr(0.6,Changed.kr(rawvals[b2])));
	cch2 = Trig.kr(Changed.kr(rawvals[b3]),Gate.kr(0.6,Changed.kr(rawvals[b3])));
	cch3 = Trig.kr(Changed.kr(rawvals[b4]),Gate.kr(0.6,Changed.kr(rawvals[b4])));
	
	stepi = PulseCount.kr(cch, Impulse.kr(0.2));
	stepi1 = PulseCount.kr(cch1, Impulse.kr(0.2));
	stepi2 = PulseCount.kr(cch2, Impulse.kr(0.2));
	stepi3 = PulseCount.kr(cch3, Impulse.kr(0.2));
	
	t_trig_1 =  Trig.kr(cch,0.3);
	t_trig_2 =  Trig.kr(cch1,0.3);
	t_trig_3 =  Trig.kr(cch2,0.3);
	t_trig_4 =  Trig.kr(cch3,0.3);
	//--------------------------------------------------------counter button (analogue)
		

	stepc = PulseCount.kr(bi1, Impulse.kr(0.17));
	stepc1 = PulseCount.kr(bi2, Impulse.kr(0.17));
	stepc2 = PulseCount.kr(bi3, Impulse.kr(0.17));
	stepc3 = PulseCount.kr(bi4, Impulse.kr(0.17));

	//triger is simply the binary button
	
	
	// ----------------------------------------------------- Mode button
	ch5 = Trig.kr(Changed.kr(rawvals[m1]),0.35);
	mode = Stepper.kr(ch5, 0,0, 3,1);
	trmode = Changed.kr(mode);

	//-----------------------------------------------------EMMERGENCY button
	red = Trig.kr(Changed.kr(rawvals[m2]),1);
	trred = Changed.kr(red);
	
	// ----------------------------------------------------- switch freq dm
	fra = Trig.kr(Changed.kr(rawvals[b1]),0.35);
	fraq = Stepper.kr(fra, 0,0, 4,1);


	// ----------------------------------------------------- switch flowa
	flow = Trig.kr(Changed.kr(rawvals[b4]),0.35);
	flowa = Stepper.kr(flow, 5,1, 5,-1);

// ----------------------------------------------------- switch timo
	timo = Trig.kr(Changed.kr(rawvals[b2]),0.35);
	timoa = Stepper.kr(timo, 0,0, 4,1);

	//-----------------------------------------------------Long Press button  - not using

		// lp0 = Trig.kr(Changed.kr(rawvals[1]),1);
		// lp1 = Trig.kr(Changed.kr(rawvals[2]),1);
		// lp2 = Trig.kr(Changed.kr(rawvals[3]),1);
		// lp3 = Trig.kr(Changed.kr(rawvals[4]),1);
	
	//-----------------------------------------------------Solar range  // don't track here otherwise it's to much cpu
	
	an0 = 1;
	an1 = 1;
	an2 = 1;
	an3 = 1;
	an4 = 1;
	an5 = 1;
	
	// an0 = LinLin.kr(AnalogIn.ar(0),0.001,0.9, 0.1,1);
	// an1 = LinLin.kr(AnalogIn.ar(1),0.001,0.9, 0.1,1);
	// an2 = LinLin.kr(AnalogIn.ar(2),0.001,0.9, 0.1,1);
	// an3 = LinLin.kr(AnalogIn.ar(3),0.001,0.9, 0.1,1);
	// an4 = LinLin.kr(AnalogIn.ar(4),0.001,0.9, 0.1,1);
	// an5 = LinLin.kr(AnalogIn.ar(5),0.001,0.9, 0.1,1);
	
	//	-----------------------------------------------------Analogue button

	//Analogue but
	an1but = HPF.kr(rawvals[a1]/rawvals[a1],50);   // pot analogue choose
	an2but = HPF.kr(rawvals[a2]/rawvals[a2],50);   // amp & pot
	
	t_trig_8 = Trig.kr(an1but,1);  //dur 1 filters the possible multiple trigger
	t_trig_9 = Trig.kr(an2but,1);	//dur 1 filters the possible multiple trigger
	
	//	-----------------------------------------------------Color pot chooser
	// chpot1 = Trig.kr(an1but,0.4);
	// steppot1 = Stepper.kr(chpot1,0,0,6);
	
	// a = [an0,an1,an2,an3,an4,an5];
        
	 //an = Select.ar(steppot1, a);
	 an = 1;
	// trpot = Changed.kr(chpot2);
	
	//	----------------------------------------------------- Digital Amplitude button 
	
	// champ = Trig.kr(Changed.kr(rawvals[22]),Gate.kr(0.6,Changed.kr(rawvals[22])));
	// stepamp = PulseCount.kr(champ, Impulse.kr(0.2));
	// tramp = Changed.kr(champ);
	

	//-----------------------------------------------------MFCC color constitution

	chain = FFT(LocalBuf(128), in);
 	chaintrig = chain > -0.0001;

	features = [SpecCentroid.kr(chain)]; // just one 1D feature here
	classif = KMeansRT.kr(~kbuf, features, k, chaintrig);
	 //classif.poll(chaintrig);

	// classif = Gate.kr(classif,Trig.kr(an1but));
 	  // Now we read the centroid position back out of the buffer and sonify
 	centroid = KMeansRT.getCentroid(~kbuf, classif, ~ndims).at(0);


 // pot analogue
 
 potlin1 = LinLin.kr(rawvals[a1],10,70,0,7); 
 potlin2 = LinLin.kr(rawvals[a2],10,70,0,7); 
	// ~pot1 = LinLin.kr(pot,50,180,1,6); 
	// ~pot1 = ~pot1.asInt;  //integer not decimal
	
	// ----------------------------------------------------- OSCSEND
	SendReply.kr(trmode, "/manag", [mode],106); 
	SendReply.kr(trred, "/manag", [red],117);

	SendReply.kr(bi1, "/trsm", [mode,stepc,classif,bi1],101);
	SendReply.kr(bi2, "/trsm", [mode,stepc1, classif,bi2],102);
	SendReply.kr(bi3, "/trsm", [mode,stepc2, classif,bi3],103);
	SendReply.kr(bi4, "/trsm", [mode,stepc3, classif,bi4],104);
	SendReply.kr(t_trig_8, "/trsm",[mode,0,rawvals[a1],0],108);   //  amplitude
	SendReply.kr(t_trig_9, "/trsm",[mode,0,rawvals[a2],0],109);   //   attack
	
//	SendReply.kr(t_trig_8, "/trdm", [mode, classif,  rawvals[a1]],108);  //[freq, sp1,sp2,sp3,sp4,sp5,sp6]
//	SendReply.kr(t_trig_9, "/trdm", [mode, classif,  rawvals[a2]],109);  //amp
	
	SendReply.kr(Trig.kr(Impulse.kr(~flow)), "/trdm", [mode, freqT,fraq,flowa,amp, timoa],110);  //new detection mode
	
	SendReply.kr(Trig.kr(Impulse.kr(4)), "/trvirus", [freqT,amp, timoa],120);  //sending constant messages to Timo
	
	
	SendReply.kr(t_trig_1, "/trpm", [mode, stepi, an,cch],101);
	SendReply.kr(t_trig_2, "/trpm", [mode, stepi1, an,cch1],102);
	SendReply.kr(t_trig_3, "/trpm", [mode, stepi2, an,cch2],103);
	SendReply.kr(t_trig_4, "/trpm", [mode, stepi3, an,cch3],104);
	SendReply.kr(t_trig_8, "/trpm",[mode,0,rawvals[a1],0],108);   //  amplitude
	SendReply.kr(t_trig_9, "/trpm",[mode,0,rawvals[a2],0],109);   //   attack
	
	SendReply.kr(t_trig_8, "/tram", [mode,potlin1,potlin2],108);  //play and choose
	SendReply.kr(t_trig_9, "/tram", [mode,potlin2,potlin2],109);  //stop and 
	SendReply.kr(bi1, "/tram", [mode,0,0],101);    //add variations digital buttons
	SendReply.kr(bi2, "/tram", [mode,0,0],102);
	SendReply.kr(bi3, "/tram", [mode,0,0],103);
	SendReply.kr(bi4, "/tram", [mode,0,0],104);


	sig = SinOsc.ar((1..numTouchPads) * 50, mul: Lag.kr(rawvals.linlin(0.0, 300, 0.0, 1.0), 0.1)) * 0.6;
	sig = Splay.ar(sig);
	sig = CombL.ar(sig.sum, 0.2, 0.2, 3.0, mul: 0.4) + sig;
	
	ping = EnvGen.ar(Env.perc, t_updateTrill) * SinOsc.ar(440);
	
	sig + ping;
	}).play;


);
