/***** seender.scd *****/
(

	SynthDef(\raw,{ |t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 29;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x30; // I2C address of Trill sensor
	var noiseThresh = 0.023; // float: 0-0.0625, with 0.0625 being the highest noise thresh
	var prescalerOpt = 4; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)


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

	//---------------------------------------------------------  Transform data into a Digitaltrigger
	var bi1 = Trig.kr(bt1);
	var bi2 = Trig.kr(bt2);
	var bi3 = Trig.kr(bt3);
	var bi4 = Trig.kr(bt4);

	var tm1 = Trig.kr(bm1,0.35);
	var tm2 = Trig.kr(bm2,0.35);
	var tm3 = Trig.kr(bm3,0.35);
	var tm4 = Trig.kr(bm4,0.35);


	// ----------------------------------------------------- ANALOGUE BUTTON
	var an1 = AnalogIn.ar(DC.ar(0)).linlin(0,0.7,0,1);
	var an2 = AnalogIn.ar(DC.ar(1)).linlin(0,0.7,0,1);	
	
	var tra = Impulse.kr(2.5);

	// ----------------------------------------------------- M1 - Mode switch button
	var mode = Stepper.kr(tm1, 0,0, 3,1);
	var trmode = Changed.kr(mode);

	//----------------------------------------------------- M2 - Function button
	var func = Stepper.kr(tm2, 0,0, 4,1);
	var trfunc = Changed.kr(func);

	//----------------------------------------------------- M3 - subfunction button
	var subfunc = Stepper.kr(tm3, 0,0, 2,1);
	var trsubfunc = Changed.kr(subfunc);

	//----------------------------------------------------- M4 - rewrite button
	var rewrite = Stepper.kr(tm4, 0,0, 2,1);
	var trrewrite = Changed.kr(rewrite);


	//-------------------------------------------------------- Digital Button (The count is reseted after one sec)
	var stepc = PulseCount.kr(bi1, Impulse.kr(0.17));
	var stepc1 = PulseCount.kr(bi2, Impulse.kr(0.17));
	var stepc2 = PulseCount.kr(bi3, Impulse.kr(0.17));
	var stepc3 = PulseCount.kr(bi4, Impulse.kr(0.17));

	//-------------------------------------------------------- SEND data 
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

	
	

	
// ----------------------------------------------------- Send these data to OSCSEND Messages
//MANAG
	SendReply.kr(trmode, "/manag", [mode], 100);
	SendReply.kr(trfunc, "/manag", [func], 101);
	SendReply.kr(trsubfunc, "/manag", [subfunc], 102);
	SendReply.kr(trrewrite, "/manag", [rewrite], 103);
	
	SendReply.kr(tra, "/runner", [an1,an2], 110); //variables potmeter
//	SendReply.kr(tra, "/runner", [an1,an2], 111); //freq, amp
	
//SM


	SendReply.kr(bi1, "/trsm", [mode, func, subfunc, rewrite, stepc,  bi1],101);
	SendReply.kr(bi2, "/trsm", [mode, func, subfunc, rewrite, stepc1, bi2],102);
	SendReply.kr(bi3, "/trsm", [mode, func, subfunc, rewrite, stepc2, bi3],103);
	SendReply.kr(bi4, "/trsm", [mode, func, subfunc, rewrite, stepc3, bi4],104);

	SendReply.kr(trrewrite, "/trsm", [mode, func, subfunc, rewrite, stepc3, bi4],105); //variables can be preparedand update

//DM

//AM
//id = msg[2], mode = msg[3], function = msg[4], rewrite = msg[5],  but= msg[6], an1 = msg[7], an2 = msg[8] ;  //changer

	SendReply.kr(bi1, "/tram", [mode, func, rewrite, bi1],101);
	SendReply.kr(bi2, "/tram", [mode, func, rewrite, bi2],102);
	SendReply.kr(bi3, "/tram", [mode, func, rewrite, bi3],103);
	SendReply.kr(bi4, "/tram", [mode, func, rewrite, bi4],104);


//PM
//id = msg[2], mode = msg[3], func = msg[4], rewrite = msg [5], count = msg[6],  dig = msg[7];

	SendReply.kr(bi1, "/trpm", [mode, func, rewrite, stepc  , bi1 ],101);
	SendReply.kr(bi2, "/trpm", [mode, func, rewrite, stepc1 , bi2 ],102);
	SendReply.kr(bi3, "/trpm", [mode, func, rewrite, stepc2 , bi3 ],103);
	SendReply.kr(bi4, "/trpm", [mode, func, rewrite, stepc3 , bi4 ],104);

	}).play;


);


