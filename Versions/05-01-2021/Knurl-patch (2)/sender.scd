 /***** seender.scd *****/
(
k = 5;
~ndims = 1;
~kbuf = Buffer.alloc(s, k, ~ndims+1);

		
	SynthDef(\raw,{ |t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 29;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x30; // I2C address of Trill sensor
	var noiseThresh = 0.062; // float: 0-0.0625, with 0.0625 being the highest noise thresh
	var prescalerOpt = 4; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)

	var sig, ping,d1, gt, pc,ch ,step,t_trig_1;
	var ch1,pc1,gt1,step1,	t_trig_2 ;
	var ch2,pc2,gt2,step2,	t_trig_3 ;
	var ch3,pc3,gt3,step3,	t_trig_4 ;
	var freqT,hasFreq, sp1,sp2,sp3,sp4,sp5,sp6,mfcc,cent;   //color constitution
	var cch,cch1,cch2,cch3,  dig, dig1, dig2,dig3,trgt2;
	var t_trig_6,t_trig_7, t_trig_8,t_trig_9;
	var chain, chaintrig, features, kbuf, classif, centroid, resynth;
	var t_trig_dm, op, inr,indel,inraw,res;
	var resa,reso,resn,result; 
	var resamp, resampo,resampn;
	var champ,stepamp,tramp;
	var steppot1, chpot1,a;
	var stepc, stepc1, stepc2, stepc3;
	var stepi, stepi1, stepi2, stepi3;
	var flow, flowa, flowaa, fra, fraq,fraqq, timo,timoa, fre, freqchoice;
   var potlin1, potlin2;
// --------------------------------------------------------- define buttons port (pins on bela TrillCraft)
	var b1 = 0;
	var b2 = 1;
	var b3 = 2;
	var b4 = 3;
	
	var m1 = 29;    //  modes
	var m2 = 28;    // stop all
	var m3 = 27;   // write
	var m4 = 26;   // rewrite switch
	
	var a11 = 4;   //
	var a12 = 5;   //do lado do managment
	var a13 = 6;   //do lado do managment
	var a14 = 7;   //do lado do managment
	var a15 = 8;   //do lado do managment
	var a16 = 9;   //do lado do managment
	var a17 = 10;   //do lado do managment
	var a18 = 11;   //do lado do managment	
	
	var a21 = 24;   
	var a22 = 23;   //do lado do managment
	var a23 = 25;   //do lado do managment
	var a24 = 22;   //do lado do managment
	var a25 = 21;   //do lado do managment
	var a26 = 20;   //do lado do managment
	var a27 = 19;   //do lado do managment	

	
	// ~light1 = 1;  //sm  - blue
	// ~light2 = 5;  //pm  - green
	// ~light3 = 9;  //am  - yellow
	// ~light4 = 11;  //dm  - white
	// ~light5 = 3;  //stop  - red

	 //--------------------------------------------------------- basics - transforming signal into trigger
	var rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThresh, prescalerOpt, t_updateTrill);
	
		
	var bt1 = rawvals[b1]/rawvals[b1];      //the result is 1 or 0 
	var bt2 = rawvals[b2]/rawvals[b2]; 
	var bt3 = rawvals[b3]/rawvals[b3]; 
	var bt4 = rawvals[b4]/rawvals[b4]; 
	
	var bm1 = rawvals[m1]/rawvals[m1]; 
	var bm2 = rawvals[m2]/rawvals[m2]; 
	var bm3 = rawvals[m3]/rawvals[m3]; 
	var bm4 = rawvals[m4]/rawvals[m4]; 
	
	var an1but = rawvals[a11]/rawvals[a11];    
	var an12but = rawvals[a12]/rawvals[a12]; 
	var an13but = rawvals[a13]/rawvals[a13]; 
	var an14but = rawvals[a14]/rawvals[a14]; 
	var an15but = rawvals[a15]/rawvals[a15]; 
	var an16but = rawvals[a16]/rawvals[a16]; 
	var an17but = rawvals[a17]/rawvals[a17]; 
	var an18but = rawvals[a18]/rawvals[a18]; 
	
	var an2but = rawvals[a21]/rawvals[a21];
	var an22but = rawvals[a22]/rawvals[a22]; 
	var an23but = rawvals[a23]/rawvals[a23]; 
	var an24but = rawvals[a24]/rawvals[a24]; 
	var an25but = rawvals[a25]/rawvals[a25]; 
	var an26but = rawvals[a26]/rawvals[a26]; 
	var an27but = rawvals[a27]/rawvals[a27]; 

	
	var bi1 = Trig.kr(bt1);              // transform into a trigger
	var bi2 = Trig.kr(bt2);  
	var bi3 = Trig.kr(bt3);  
	var bi4 = Trig.kr(bt4);  
	
	var tm1 = Trig.kr(bm1,0.35);
	var tm2 = Trig.kr(bm2,0.35);
	var tm3 = Trig.kr(bm3,0.35);
	var tm4 = Trig.kr(bm4,0.35);
	
	var ta11 = Trig.kr(an1but);  
	var ta12 = Trig.kr(an12but);  
	var ta13 = Trig.kr(an13but);  
	var ta14 = Trig.kr(an14but);  
	var ta15 = Trig.kr(an15but);  
	var ta16 = Trig.kr(an16but);  
	var ta17 = Trig.kr(an17but);  
	var ta18 = Trig.kr(an18but);  
	
	var ta21 = Trig.kr(an2but);  
	var ta22 = Trig.kr(an22but);  
	var ta23 = Trig.kr(an23but);  
	var ta24 = Trig.kr(an24but);  
	var ta25 = Trig.kr(an25but);  
	var ta26 = Trig.kr(an26but);  
	var ta27 = Trig.kr(an27but);  

	
	//Gvar ta11= Impulse.kr(5)*an1but; //Gate.kr(Impulse.kr(5),Changed.kr(rawvals[a11]*an1but,0.5));  //
	//Gvar ta21= Trig.kr(an2but,0.2); //Trig.kr(Changed.kr(rawvals[a21]),0.15);
	

 	
	// ----------------------------------------------------- Mode switch button
	var mode = Stepper.kr(tm1, 0,0, 3,1);
	var trmode = Changed.kr(mode);

	//-----------------------------------------------------EMMERGENCY switch button
	var red = Trig.kr(Changed.kr(tm2),1);
	var trred = Changed.kr(red);
	
	//-----------------------------------------------------Write switch button
	var write = Stepper.kr(tm3, 0,0, 3,1);
	var trwrite = Changed.kr(write);
	
	//-----------------------------------------------------Rewrite switch button
	var rewrite = Stepper.kr(tm4, 0,0, 3,1);
	var trrewrite = Changed.kr(red);
	
    //--------------------------------------------------------- Trackers
	var in = SoundIn.ar(2,2); /// mul changes sensitivity
	var amp = Amplitude.kr(in);
	
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.2, median: 0.7); //tartini is very heavy for bela

	 // -----------------------------------------------------  Tranaposing potmeter to new analogue range
 	// var potlin1 = LinLin.kr(rawvals[a11],50,1800,1,10); 
 	// var potlin2 = LinLin.kr(rawvals[a21],50,2000,1,10);
	
	
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
	
	//-------------------------------------------------------- counter button 
		
	stepc = PulseCount.kr(bi1, Impulse.kr(0.17));
	stepc1 = PulseCount.kr(bi2, Impulse.kr(0.17));
	stepc2 = PulseCount.kr(bi3, Impulse.kr(0.17));
	stepc3 = PulseCount.kr(bi4, Impulse.kr(0.17));

	//triger is simply the binary button
	
	
	// ----------------------------------------------------- switch rate dm
	fra = Trig.kr(Changed.kr(rawvals[b1]),0.35);
	fraq = Stepper.kr(fra, 0,0, 4,1);

	// ----------------------------------------------------- switch freqcoice dm
	fre = Trig.kr(Changed.kr(rawvals[b2]),0.35);
	freqchoice = Stepper.kr(fre, 0, 100, 600,100);

	// ----------------------------------------------------- switch flowa
	flow = Trig.kr(Changed.kr(rawvals[b4]),0.35);
	flowa = Stepper.kr(flow, 5,1, 5,-1);


// ----------------------------------------------------- switch timo
	timo = Trig.kr(Changed.kr(rawvals[b2]),0.35);
	timoa = Stepper.kr(timo, 0,0, 4,1);

	
	//	-----------------------------------------------------Analogue button

	// t_trig_6 = Trig.kr(m3,0.1);
	// t_trig_7 = Trig.kr(m4,0.1);
	// t_trig_8 = Trig.kr(an1but,0.1);  //dur 1 filters the possible multiple trigger
	// t_trig_9 = Trig.kr(an2but,0.1);	//dur 1 filters the possible multiple trigger
	
	//	-----------------------------------------------------Color pot chooser
	// chpot1 = Trig.kr(an1but,0.4);
	// steppot1 = Stepper.kr(chpot1,0,0,6);
	
	// a = [an0,an1,an2,an3,an4,an5];
        
	 //an = Select.ar(steppot1, a);
	 //an = 1;
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


 

	// ----------------------------------------------------- OSCSEND
	SendReply.kr(trmode, "/manag", [mode],106); 
	SendReply.kr(trred, "/manag", [red],107);
	SendReply.kr(trwrite, "/manag", [write],108);

//SM
	SendReply.kr(tm3, "/trsm",[mode,write, rewrite,0,0,0],108);   
	SendReply.kr(tm4, "/trsm",[mode,write, rewrite,0,0,0],109);  
	
	SendReply.kr(bi1, "/trsm", [mode, write, rewrite, stepc, bi1, 0 ],101);
	SendReply.kr(bi2, "/trsm", [mode, write, rewrite, stepc1, bi2, 0 ],102);
	SendReply.kr(bi3, "/trsm", [mode, write, rewrite, stepc2, bi3, 0],103);
	SendReply.kr(bi4, "/trsm", [mode, write, rewrite, stepc3, bi4, 0],104);
	
//play and chose
	SendReply.kr(ta11, "/trsm", [mode,  write, rewrite, stepc, bi1, 1],108);
	SendReply.kr(ta12, "/trsm", [mode,  write, rewrite, stepc, bi1, 2],108);
	SendReply.kr(ta13, "/trsm", [mode,  write, rewrite, stepc, bi1, 3],108);
	SendReply.kr(ta14, "/trsm", [mode,  write, rewrite, stepc, bi1, 4],108);
	SendReply.kr(ta15, "/trsm", [mode,  write, rewrite, stepc, bi1, 5],108);
	SendReply.kr(ta16, "/trsm", [mode,  write, rewrite, stepc, bi1, 6],108);
	SendReply.kr(ta17, "/trsm", [mode,  write, rewrite, stepc, bi1, 7],108);
	SendReply.kr(ta18, "/tram", [mode,  write, rewrite, stepc, bi1, 8],108);
//var stop, connect hierarchy	
	SendReply.kr(ta21, "/trsm", [mode, write, rewrite, stepc, bi1, 1],109);
	SendReply.kr(ta22, "/trsm", [mode,  write, rewrite, stepc, bi1, 2],109);
	SendReply.kr(ta23, "/trsm", [mode,  write, rewrite, stepc, bi1, 3],109);
	SendReply.kr(ta24, "/trsm", [mode,  write, rewrite, stepc, bi1, 4],109);
	SendReply.kr(ta25, "/trsm", [mode,  write, rewrite, stepc, bi1, 5],109);
	SendReply.kr(ta26, "/trsm", [mode,  write, rewrite, stepc, bi1, 6],109);
	SendReply.kr(ta27, "/trsm", [mode,  write, rewrite, stepc, bi1, 7],109);
	
	
// 	SendReply.kr(ta11, "/trsm", [mode, write, rewrite, 1, 1, rawvals[a11],an1but],105);  //var & color
// 	SendReply.kr(ta21, "/trsm", [mode, write, rewrite, 1,1, rawvals[a21],an2but],112);   //fade & data type list
	
	
	SendReply.kr(Trig.kr(Impulse.kr(~flow)), "/trdm", [mode, freqT,fraq,flowa,freqchoice ,amp, timoa],110);  //new detection mode
	SendReply.kr(Trig.kr(Impulse.kr(4)), "/trvirus", [freqT,amp, timoa],120);  //sending constant messages to Timo
	
	
	// SendReply.kr(t_trig_1, "/trpm", [mode, stepi, an,cch],101);
	// SendReply.kr(t_trig_2, "/trpm", [mode, stepi1, an,cch1],102);
	// SendReply.kr(t_trig_3, "/trpm", [mode, stepi2, an,cch2],103);
	// SendReply.kr(t_trig_4, "/trpm", [mode, stepi3, an,cch3],104);
	// SendReply.kr(t_trig_8, "/trpm",[mode,0,rawvals[a11],0],108);   //  amplitude
	// SendReply.kr(t_trig_9, "/trpm",[mode,0,rawvals[a21],0],109);   //   attack
	
//play and chose
	SendReply.kr(ta11, "/tram", [mode, 1],108);
	SendReply.kr(ta12, "/tram", [mode, 2],108);
	SendReply.kr(ta13, "/tram", [mode, 3],108);
	SendReply.kr(ta14, "/tram", [mode, 4],108);
	SendReply.kr(ta15, "/tram", [mode, 5],108);
	SendReply.kr(ta16, "/tram", [mode, 6],108);
	SendReply.kr(ta17, "/tram", [mode, 7],108);
	SendReply.kr(ta18, "/tram", [mode, 8],108);
//var stop, connect hierarchy	
	SendReply.kr(ta21, "/tram", [mode,1],109);
	SendReply.kr(ta22, "/tram", [mode, 2],109);
	SendReply.kr(ta23, "/tram", [mode, 3],109);
	SendReply.kr(ta24, "/tram", [mode, 4],109);
	SendReply.kr(ta25, "/tram", [mode, 5],109);
	SendReply.kr(ta26, "/tram", [mode, 6],109);
	SendReply.kr(ta27, "/tram", [mode, 7],109);
	

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

