/***** seender.scd *****/
(

	SynthDef(\raw,{ |t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 29;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x30; // I2C address of Trill sensor
	var noiseThresh = 0.02; // float: 0-0.0625, with 0.0625 being the highest noise thresh
	var prescalerOpt = 3; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)
	var freqT, hasFreq;   //color constitution


// --------------------------------------------------------- Definition of buttons (pins on bela TrillCraft)  Check the diagram here: https://learn.bela.io/pin-diagram/
	var b1 = 0;     //  Digital button
	var b2 = 1;
	var b3 = 2;
	var b4 = 3;

	var m1 = 4;    //  modes
	var m2 = 5;    //  function
	var m3 = 6;    //  input
	var m4 = 7;    //  output

	var motor1 = 6;  // Motor
	var motor2 = 7;  // Motor
	
	var a1 = 0;
	var a2 = 1;
	
	 //Light red - 0
	 //Light yellow - 2
	 //Light blue - 4
	 //Light green - 8

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

//---------------------------------------------------------  Transform data into a trigger
	var bi1 = Trig.kr(bt1);
	var bi2 = Trig.kr(bt2);
	var bi3 = Trig.kr(bt3);
	var bi4 = Trig.kr(bt4);

	var tm1 = Trig.kr(bm1,0.35);
	var tm2 = Trig.kr(bm2,0.35);
	var tm3 = Trig.kr(bm3,0.35);
	var tm4 = Trig.kr(bm4,0.35);

	var an1 = AnalogIn.ar(a1).exprange(100,2000);  //freq
	var an2 = AnalogIn.ar(a2);    //amp
	var an3 = AnalogIn.ar(a1).exprange(0.05,2);    //filter
	var an4 = AnalogIn.ar(a2).exprange(0.05,2);    //lin
	
//-------------------------------------------------------- Transforming into a counter button
	var linan2 = LinLin.kr(an2, 0.015, 0.8, 0.00001,1.5);
	
	// ----------------------------------------------------- M1 - Mode switch button
	var mode = Stepper.kr(tm1, 0,0, 4,1);
	var trmode = Changed.kr(mode);

	//----------------------------------------------------- M2 - Function button
	var func = Stepper.kr(tm2, 0,0, 5,1);
	var trfunc = Changed.kr(func);

	//----------------------------------------------------- M3 - Input button
	var inputs = Stepper.kr(tm3, 0,0, 4,1);
	var trinputs = Changed.kr(inputs);

	//----------------------------------------------------- M4 - rewrite button
	var outputs = Stepper.kr(tm4, 0,0, 2,1);
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
	var in = SoundIn.ar([0,1],2); // Attention: mul changes sensitivity
	var amp = Amplitude.kr(in);
    //var zc = ZeroCrossing.ar(in);
	
	//Onset
	var chain = FFT(c, in);  //FFT
	var onsets = Onsets.kr(chain, 0.5, \complex);
	//var trigger = SendTrig.kr(onsets);
	
	//ZeroCrossing
	//var amp = SinOsc.ar(zc, 0, AmpComp.ar(zc, 20).poll);
	
	
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.2, median: 0.7); //tartini is very heavy for bela

	
// ----------------------------------------------------- Send these data to OSCSEND Messages

//MANAG
	SendReply.kr(trmode, "/manag", [mode], 100);
	SendReply.kr(trfunc, "/manag", [func], 101);
	SendReply.kr(trinputs, "/manag", [inputs], 102);
	SendReply.kr(troutputs, "/manag", [outputs], 103);

//SM
	//SendReply.kr(tm1, "/trsm",[mode], 108);
	//SendReply.kr(tm2, "/trsm",[func], 109);

	SendReply.kr(bi1, "/trsm", [mode, func, inputs, outputs, stepc,  bi1, an1,an2],101);
	SendReply.kr(bi2, "/trsm", [mode, func, inputs, outputs, stepc1, bi2, an1,an2],102);
	SendReply.kr(bi3, "/trsm", [mode, func, inputs, outputs, stepc2, bi3, an1,an2],103);
	SendReply.kr(bi4, "/trsm", [mode, func, inputs, outputs, stepc3, bi4, an1,an2],104);
	
	SendReply.kr(troutputs, "/trsm", [mode, func, inputs, outputs, stepc3, bi4, an1,an2],105); //variables can be preparedand update
	
//DM
	SendReply.kr(Trig.kr(Impulse.kr(~flow)), "/trdm", [mode, freqT,fraq,flowa,freqchoice ,amp, timoa],110);  //new detection mode
	SendReply.kr(Trig.kr(Impulse.kr(4)), "/trvirus", [freqT,amp, timoa],120);  //sending constant messages to Timo

//AM 
//id = msg[2], mode = msg[3], function = msg[4], rewrite = msg[5],  but= msg[6], an1 = msg[7], an2 = msg[8] ;  //changer

	SendReply.kr(bi1, "/tram", [mode, func, outputs, bi1, an1,an2],101);
	SendReply.kr(bi2, "/tram", [mode, func, outputs, bi2, an1,an2],102);
	SendReply.kr(bi3, "/tram", [mode, func, outputs, bi3, an1,an2],103);
	SendReply.kr(bi4, "/tram", [mode, func, outputs, bi4, an1,an2],104);


//PM 
//id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];

	SendReply.kr(bi1, "/trpm", [mode, func, outputs, stepc  , bi1 ],101);
	SendReply.kr(bi2, "/trpm", [mode, func, outputs, stepc1 , bi2 ],102);
	SendReply.kr(bi3, "/trpm", [mode, func, outputs, stepc2 , bi3 ],103);
	SendReply.kr(bi4, "/trpm", [mode, func, outputs, stepc3 , bi4 ],104);



//SEND VIRUS 

	SendReply.kr(Impulse.kr(0.25), "/sendingvirus", [freqT, amp, stepc, an1, an2],101);
	
	
	}).play;


);


