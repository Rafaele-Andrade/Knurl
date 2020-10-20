/***** synth_detectionmode.scd *****/
(

SynthDef(\Gap,
{ |src = 1, filter = 1, specint = 1 , gate =1,amp= 1, phase = 1|
    var sig, chain,env;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.6, 6.3);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 1, 8); //0.8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.02, 0.24);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0.009, 0.097); //1040.1

    sig = LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar([2,4],12),8000),linspecint));
	env = EnvGen.kr(Env.asr(2, linamp, 1.6,4),gate, doneAction:1);
    chain = FFT(LocalBuf(128), sig);
    chain = PV_RectComb(chain, linfilter, LFTri.kr(linsrc, 0, 0.4, 0.5),
    LFTri.kr(linphase, 0, -0.5, 0.5));
		Out.ar([0,1], IFFT(chain)*linamp)
}).add;


SynthDef(\Res, { |src = 0 , filter =1, gate = 1, phase = 1 , specint =1 , amp =1|
	var  in, freq, hasFreq,gt,sig, env;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.6, 2.3);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 1, 8); //0.8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.02, 0.24);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0.001, 0.01); //1040.1

	in =  LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar(2,10),8000),linspecint));
	#freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 0.7);
	env = EnvGen.kr(Env.asr(3, amp, 3,4), gate, doneAction:1);
	gt = Gate.kr(freq,Impulse.kr(linfilter));
	sig = Resonz.ar(in, gt, linsrc) ;
	Out.ar([0,1],	Limiter.ar(sig*env,linamp));
}).add;


// SynthDef(\Formlet, { | out=0, mix=0.5, filter = 1, src =1, phase = 1 , specint = 1, attack=0.01, decay=0.1, gate = 1, amp = 1|
// 				var sig, in, formlet,freqT, hasFreq,env;

// 	var linspecint = LinLin.kr(  specint , 0.0,1, 0.05, 0.5); //3
// 	var linamp = LinLin.kr(  amp , 0.0,1, 0.05, 0.5);  //2.2
// 	var linfilter = LinLin.kr(  filter , 0.0,1, 1.8, 18); //0.8
// 	var linphase = LinLin.kr(  phase , 0.0,1, 0.02, 0.25);  //0.5
// 	var linsrc = LinLin.kr(  src , 0.0,1,100, 1000); //1040.1

// 	in = SoundIn.ar(2,1);
// 	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 0.7);
// 			env = EnvGen.kr(Env.asr(3, linamp, 3,4), gate, doneAction:1);
// 				sig = WhiteNoise.ar(linfilter);
// 				formlet = Formlet.ar(sig, freqT*linsrc, attack, decay)*env;
// 				Out.ar([0,1], (sig * (1 - mix)) + (formlet * mix));
// 			}).add;



SynthDef(\Converb, { arg gate = 1, amp =1, src = 0 , filter = 1, phase = 1 , specint =1;
							var input, output, delrd, sig, deltimes, env;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 1.3);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 1, 8); //0.8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.05, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0.001, 0.01); //1040.1

							// Choose which sort of input you want by (un)commenting these lines:
							// input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
							input =  SoundIn.ar([2,3]); //LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar([2,4],2),8000),linspecint));
							// input = SoundIn.ar(0,0.1); // TAKE CARE of feedback - use headphones
							// input = Dust2.ar([0.1, 0.01]); // Occasional clicks

							// Read our 4-channel delayed signals back from the feedback loop
							delrd = LocalIn.ar(4);

							// This will be our eventual output, which will also be recirculated
							output = input + delrd[[0,1]];

							env = EnvGen.kr(Env.asr(0.1, linamp, 1.3), gate, doneAction:2);
							// Cross-fertilise the four delay lines with each other:
							sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
							sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
							// Attenutate the delayed signals so they decay:
							sig = sig * [0.4, 0.37, 0.333, 0.3] *linfilter;

							// Here we give delay times in milliseconds, convert to seconds,
							// then compensate with ControlDur for the one-block delay
							// which is always introduced when using the LocalIn/Out fdbk loop
							deltimes = [101, 143, 165, 177] * linsrc - ControlDur.ir;

							// Apply the delays and send the signals into the feedback loop
	Out.ar([0,1],Limiter.ar( Pan2.ar(DelayC.ar(sig, deltimes, deltimes), FSinOsc.kr(linphase)),linamp));

							// Now let's hear it:
							output

						}).add;

 SynthDef(\Friction, { |gate=1,amp=1, src = 1, filter = 1, phase = 1, specint =1|
											var in,env;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.6, 13.3);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.8, 8); //8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.02, 0.8);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,5.41322e-6, 5.41322e-5); //1040.1

											in = SoundIn.ar(2,2); //LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar([2,3],2),8000),specint));
											env = EnvGen.kr(Env.asr(3, linamp, 0.3,4), gate, doneAction:1);
											Out.ar([0,1],Limiter.ar(
											Friction.ar(SoundIn.ar(2,2,linspecint), friction: linsrc, spring: XLine.kr(0.5,linphase,4),mass: XLine.kr(30,linfilter,4))*env,linamp
											))
										}).add;


SynthDef(\Delay, {|in1 = 2, in2 = 3, out1 = 0, out2 = 1, mix=0.5, gate =1, amp = 1, src = 1, filter = 1, phase = 1,specint= 1 |
			var source, delay,env;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 1.2);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 1); //0.8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.05, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0.09, 0.7); //1040.1

			source = LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar([2,4],2),8000),linspecint));
			env = EnvGen.kr(Env.asr(1, linamp, 1,4), gate, doneAction:2);
			delay = DelayL.ar(source, linphase, XLine.kr(0.03, linsrc,60))*env;
			ReplaceOut.ar([out1,out2], (source * (1 - mix)) + (delay * mix));
								}).add;

 SynthDef(\Reverb, { |gate = 1,amp =1, src = 1, filter = 1, phase = 1, specint= 1 |
										var in, enva, sound;

	var linspecint = LinLin.kr(  specint , 0.0,1, 20, 200); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 1, 3.3);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 50, 500); //0.8
	var linphase = LinLin.kr(  phase , 0.0,1, 0.02, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0.1, 1.19); //1040.1

										in = SoundIn.ar([2,4],10); //LeakDC.ar(BPF.ar(LPF.ar(SoundIn.ar([2,4],2),8000),linspecint));
											enva = EnvGen.kr(Env.asr(1, linamp, 1,4), gate, doneAction:2);
											sound = LPF.ar(FreeVerb.ar(in,0.6,linsrc) ,linfilter);
											Out.ar([0,1],sound*enva);
										}).add;


)