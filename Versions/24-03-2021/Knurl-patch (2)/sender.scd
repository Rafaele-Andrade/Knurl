 /***** seender.scd *****/
(

	SynthDef(\raw,{ |t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 29;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x30; // I2C address of Trill sensor
	var noiseThresh = 0.062; // float: 0-0.0625, with 0.0625 being the highest noise thresh
	var prescalerOpt = 4; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)
	var freqT,hasFreq;   //color constitution


// --------------------------------------------------------- Definition of buttons (pins on bela TrillCraft)  Check the diagram here: https://learn.bela.io/pin-diagram/
	var b1 = 0;     //  Digital button
	var b2 = 1;
	var b3 = 2;
	var b4 = 3;

	var m1 = 29;    //  modes
	var m2 = 28;    //  function
	var m3 = 27;    //  input
	var m4 = 26;    //  output

	var a11 = 4;   // Analogue set 1
	var a12 = 5;
	var a13 = 6;
	var a14 = 7;
	var a15 = 8;
	var a16 = 9;
	var a17 = 10;
	var a18 = 11;

	var a21 = 24;   // Analogue set 2
	var a22 = 23;
	var a23 = 25;
	var a24 = 22;
	var a25 = 21;
	var a26 = 20;
	var a27 = 19;

	var motor1 = 6;  // Motor
	var motor2 = 7;  // Motor

	 ~light1 = 0;  // LEDS blue
	 ~light2 = 2;  // green
	 ~light3 = 4;  // yellow
	 ~light4 = 8; // red


//--------------------------------------------------------- Basics - transforming signal into binary data (1 or 0)

	var rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThresh, prescalerOpt, t_updateTrill);


	var bt1 = rawvals[b1]/rawvals[b1];
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


//---------------------------------------------------------  Transform data into a trigger
	var bi1 = Trig.kr(bt1);
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


//-------------------------------------------------------- Transforming into a counter button

	// ----------------------------------------------------- M1 - Mode switch button
	var mode = Stepper.kr(tm1, 0,0, 3,1);
	var trmode = Changed.kr(mode);

	//----------------------------------------------------- M2 - Function button
	var func = Stepper.kr(tm2, 0,0, 3,1);
	var trfunc = Changed.kr(func);

	//----------------------------------------------------- M3 - Input button
	var inputs = Stepper.kr(tm3, 0,0, 3,1);
	var trinputs = Changed.kr(inputs);

	//----------------------------------------------------- M4 - Output button
	var outputs = Stepper.kr(tm4, 0,0, 3,1);
	var troutputs = Changed.kr(outputs);


	//-------------------------------------------------------- Digital Button (The count is reseted after one sec)
	var stepc = PulseCount.kr(bi1, Impulse.kr(0.17));
	var stepc1 = PulseCount.kr(bi2, Impulse.kr(0.17));
	var stepc2 = PulseCount.kr(bi3, Impulse.kr(0.17));
	var stepc3 = PulseCount.kr(bi4, Impulse.kr(0.17));


	// ----------------------------------------------------- switch rate dm
	var fra = Trig.kr(Changed.kr(rawvals[b1]),0.35);
	var fraq = Stepper.kr(fra, 0,0, 4,1);

	// ----------------------------------------------------- switch freqcoice dm
	var fre = Trig.kr(Changed.kr(rawvals[b2]),0.35);
	var freqchoice = Stepper.kr(fre, 0, 100, 600,100);

	// ----------------------------------------------------- switch flowa
	var flow = Trig.kr(Changed.kr(rawvals[b4]),0.35);
	var flowa = Stepper.kr(flow, 5,1, 5,-1);


	// ----------------------------------------------------- switch timo
	var timo = Trig.kr(Changed.kr(rawvals[b2]),0.35);
	var timoa = Stepper.kr(timo, 0,0, 4,1);


    //--------------------------------------------------------- Sound Trackers
	var in = SoundIn.ar(2,2); // Attention: mul changes sensitivity
	var amp = Amplitude.kr(in);

	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.2, median: 0.7); //tartini is very heavy for bela


// ----------------------------------------------------- Send these data to OSCSEND Messages

	SendReply.kr(trmode, "/manag", [mode], 100);
	SendReply.kr(trfunc, "/manag", [func], 101);
	SendReply.kr(trinputs, "/manag", [inputs], 102);
	SendReply.kr(troutputs, "/manag", [outputs], 103);

//SM
//DIG
	SendReply.kr(tm3, "/trsm",[mode, write, rewrite,0,0,0], 108);
	SendReply.kr(tm4, "/trsm",[mode, write, rewrite,0,0,0], 109);

	SendReply.kr(bi1, "/trsm", [mode, write, rewrite, stepc, bi1, 0 ],101);
	SendReply.kr(bi2, "/trsm", [mode, write, rewrite, stepc1, bi2, 0],102);
	SendReply.kr(bi3, "/trsm", [mode, write, rewrite, stepc2, bi3, 0],103);
	SendReply.kr(bi4, "/trsm", [mode, write, rewrite, stepc3, bi4, 0],104);

//AN1
	SendReply.kr(ta11, "/trsm", [mode,  write, rewrite, stepc, bi1, 1],108);
	SendReply.kr(ta12, "/trsm", [mode,  write, rewrite, stepc, bi1, 2],108);
	SendReply.kr(ta13, "/trsm", [mode,  write, rewrite, stepc, bi1, 3],108);
	SendReply.kr(ta14, "/trsm", [mode,  write, rewrite, stepc, bi1, 4],108);
	SendReply.kr(ta15, "/trsm", [mode,  write, rewrite, stepc, bi1, 5],108);
	SendReply.kr(ta16, "/trsm", [mode,  write, rewrite, stepc, bi1, 6],108);
	SendReply.kr(ta17, "/trsm", [mode,  write, rewrite, stepc, bi1, 7],108);
	SendReply.kr(ta18, "/tram", [mode,  write, rewrite, stepc, bi1, 8],108);

//AN2
	SendReply.kr(ta21, "/trsm", [mode,  write, rewrite, stepc, bi1, 1],109);
	SendReply.kr(ta22, "/trsm", [mode,  write, rewrite, stepc, bi1, 2],109);
	SendReply.kr(ta23, "/trsm", [mode,  write, rewrite, stepc, bi1, 3],109);
	SendReply.kr(ta24, "/trsm", [mode,  write, rewrite, stepc, bi1, 4],109);
	SendReply.kr(ta25, "/trsm", [mode,  write, rewrite, stepc, bi1, 5],109);
	SendReply.kr(ta26, "/trsm", [mode,  write, rewrite, stepc, bi1, 6],109);
	SendReply.kr(ta27, "/trsm", [mode,  write, rewrite, stepc, bi1, 7],109);



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
	SendReply.kr(ta21, "/tram", [mode, 1],109);
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


	}).play;


);

