/***** osc_synthmode.scd *****/
(


~mic1 = 2;
~mic2 = 4;

	SynthDef( \record_my_voice, {
		arg buf = 0;
		var input = LPF.ar(LPF.ar(SoundIn.ar(2), 6000), 6000) * 3.0; //In.ar(2);
		RecordBuf.ar( input, buf, loop: 0, doneAction: 2 );
	}).add;

	SynthDef(\recTrack, { arg out=0, bufnum=0, gate = 1, amp = 3;
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		in = LPF.ar(LPF.ar(SoundIn.ar(2), 6000), 6000) * 3.0;//In.ar(2);
		#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.02,median: 7); 
		ampa = Amplitude.kr(in,mul:amp);
	trig = Impulse.kr(LinLin.kr(freqT,40,2000,0.5,20)); //MouseY.kr(0.5, 200, 1));
		env = EnvGen.kr(Env.adsr(2, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), trig, LinLin.kr(amp,0.001,0.3,0.01,BufFrames.kr(c.bufnum)),10 , 1);
		sig = env * playbuf;
		Out.ar([0,1], sig*2)
	}).add;
	
	SynthDef(\recPlay, { arg out=0, bufnum=0, gate = 1, amp = 6;  
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		env = EnvGen.kr(Env.adsr(2, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), loop: 1.0);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;
	
SynthDef(\SinS,{ |amp= 1, out = 0 , gate = 1, filter =1, src = 1 , specint =1 , lin= 1 |
	 var in ,freqT, hasFreq,env, ampG, n,pit;
	
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.01, 0.11); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.18, 1.38);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0, 3); //1040.1
	
n=LFNoise1;
in = SoundIn.ar([2,4],2);
ampG = AnalogIn.kr(1).exprange(0.2,5);
env = EnvGen.kr(Env.asr(0.1, 1.43, 0.7), gate, doneAction:2);
// #freqT, hasFreq = Tartini.kr(in,2.9,128,overlap: 128);
#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.001,median: 7);   //, ampThreshold: 0.02,median: 7
/*freqT = freqT * hasFreq;
pit = Latch.kr(freqT,Impulse.kr(filter));
pit.poll;*/
a=SinOsc.ar(freqT,in*LFNoise2.ar(specint,3),LFNoise1.ar(src,2));
a = AllpassL.ar(a,0.03,{lin.rand+0.1},1,0.2);
Out.ar([0,1], a*env*amp)}).add;

SynthDef(\AudFeedback, {|src = 1, filter = 1, lin = 1, specint = 1, gate = 1, amp = 1|
	var in, pos, width, sig, sig2, sig2pan, out, chain, centroid;
	var freq, hasFreq, freq2, hasFreq2,env;
	var numOutChans = 2;
	var numInternalChannels = 2;

	var linspecint = LinLin.kr(  specint , 0.0,1, 0.01, 1); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.08, 0.8);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.1);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0, 1); //1040.1
	
	in = LPF.ar(LPF.ar(SoundIn.ar(2,12), 6000), 6000) * 10.0;//SoundIn.ar([~mic1,~mic2]);  // input
	env = EnvGen.kr(Env.adsr(3, 0.01, amp, 3, 0.6, 5), gate, doneAction: 2);
	width = \width.kr(4);

	// calculate spectral centroid (center of mass)
	// do some magic to scale it properly
	centroid = ((
		SpecCentroid.kr(
			FFT(LocalBuf(128, 1), in)  //2048
		) * 0.0005
	) - 0.3 ) * 10;

	// new position determined by centroid, linearly lagged
	pos = VarLag.ar(K2A.ar(centroid), linlin, 0) * linfilter;

	sig = PanAz.ar(
	     numInternalChannels,
	     in,
	     pos,
	     0.5,
	     width
	);

	// Freezr
	#freq, hasFreq = Pitch.kr(
		in,
		ampThreshold: 0.02,
		median: 7
	);
	freq = freq * hasFreq * 0.01;


	chain = FFT({LocalBuf(128, 1)}, sig);   //dup(8)
	chain = PV_MagFreeze(
		chain,
		SinOsc.ar(
			(freq*AnalogIn.kr(0).exprand(100,400)).lag2(\laggin.kr(0.8), 0)
		)
	);

	sig2 = IFFT(chain);
	sig2pan = SplayAz.ar(
		numInternalChannels,
		sig2,
		center: LFSaw.ar(0.125)
	);

	sig = PitchShift.ar(sig, 0.05, linspecint, 2);

	Out.ar(0,(SplayAz.ar(
		numOutChans,
		Mix([sig, sig2pan]).scramble
	) * linsrc)*env*30);  //tanh
}).add;

SynthDef(\Reus, { arg gate = 1, atk=0.02, amp=1, rel=2;
	var pos1, pos2, sig1, sig2;
	var mix, t_trig, alert, env;
	sig1 = AnalogIn.ar(2); //0
	sig2 = AnalogIn.ar(4);  //1
	pos1 = AnalogIn.ar(3);  //4
	pos2 = AnalogIn.ar(5);

	t_trig = sig1 > 0.01;
	mix = EnvGen.ar(Env.perc, gate: t_trig) * Saw.ar(WhiteNoise.ar.range(100,1000), mul: 0.2);
	sig1 = LeakDC.ar(sig1);
	pos1 = HPF.ar(pos1, 1000) * 100;
	//pos1 = pos1.lag(0.1);
	
	
	env = EnvGen.kr(Env.adsr(3, 0.01, amp, 3, 0.6, 2), gate, doneAction: 2);
	mix = [sig1,sig2] ;
	mix = LPF.ar(LPF.ar(mix, 3000), 3000) * 13;
	mix = mix;// + PitchShift.ar(mix, pitchRatio: 4);
	mix = mix * SinOsc.ar(620*(pos1+1.0), mul: 1);
	// pos1.poll(1);
	Out.ar([0,1],Limiter.ar(mix*env)); 	
}).add;

SynthDef(\FreqShift,{| in=0, out=0, feedback=0.4, lin=1, src=1, specint=1, gate=1, amp =0,filter =1|
	var sig1,sig2, effect,env;
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.01, 0.14); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.3, 0.6);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 200, 2000); //1040.1
	sig1 = SoundIn.ar(2,2); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 3.0;
	sig2 = SoundIn.ar(4,2); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;//In.ar([2,4], 2);
	env = EnvGen.kr(Env.adsr(3, 0.01, linamp, 3, 0.6, 2), gate, doneAction: 2);
	// effect = Mix.ar([sig1,sig2] ;//+ LocalIn.ar(1);
	effect = FreqShift.ar([sig1,sig2], LFNoise2.ar(specint, linsrc));
	effect = DelayC.ar(effect, linlin, GbmanN.ar(linfilter).range(0.1,0.2));
	// LocalOut.ar(effect * feedback*env);
	Out.ar([0,1],Limiter.ar(effect,0.1))
	}).add;
	
SynthDef(\Contra,{|out=0, sus=0.45, surface=0.0, freq=100, atk=0.02, amp=1, rel=2, lin=1,gate=1.0,curve=2,  specint = 1, filter=1, src=1, ampModFreq=15, ampModAmt=0.01|
	var linspecint = LinLin.kr(  specint , 0.0,1, 800, 8000); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.9, 3.2);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 40); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 8000, 18500); //1040.1

	var ampa=0.5, ampb=1.0, ampc=0.4, ampd=0.8;
	var afreq = XLine.kr(0.3,3.4,630);//MouseX.kr(1, 3.5);
	var adur =  XLine.kr(0.001,lin,8);//MouseX.kr(pan, 0.001);
	var aamp = 0.5;// MouseX.kr(amp, 0.5);
 	var sig, osca, oscb, oscc, oscd, distorted, in,env,freqT, hasFreq,frequencies,amplitudes,ampIn , freqMod;
 	var downsamp, samplerate=8000, bitsize=15;
	in = SoundIn.ar([2,4],12); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;
	// SoundIn.ar([2,3],2);
	//# freqT, hasFreq = Tartini.kr(in,0.9,16,8,overlap: 256);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
	ampIn = Amplitude.ar(in);
	freqMod = LinLin.ar(ampIn,0.001,0.05,0.2,0.6);
	env = EnvGen.ar(Env.new([0, 0.2, 0.2, 0],[atk, sus, rel], curve, 2), gate, doneAction:2);
	frequencies=[ freq-freqMod,  freqT,  freqT + freqMod,  freqT +  (freqMod * 2)] * afreq ;
	amplitudes=[ampa,ampb,ampc,ampd];
	osca = LFTri.ar(frequencies[0], mul:ampa) * env;
	oscb = LFTri.ar(frequencies[1], mul:ampb) * env;
	oscc = LFTri.ar(frequencies[2], mul:ampc) * env;
	oscd = LFTri.ar(frequencies[3], mul:ampd) * env;
	sig = (osca + oscb + oscc + oscd) * linamp;
	downsamp = Latch.ar(sig, LFTri.ar(samplerate*0.5));
	distorted = downsamp.round(0.5 ** bitsize);
	sig = (sig * (1 - surface)) + (distorted * surface);
	sig = sig * SinOsc.ar(ampModFreq).range(1-ampModAmt, 1);
	sig = BPF.ar(LPF.ar(sig, linsrc), linfilter);
		sig = Ringz.ar(sig * aamp, XLine.kr(4000,linspecint,100), 0.08) ;
		// sig = Pan2.ar(sig,SinOsc.ar(adur));
	Out.ar(out, sig);
}).add;

SynthDef(\Brass, {
	|out=0, src=1, lin=0.4, filter =1, specint = 1, atk=3.1, dec=0.5, sus=1.4, rel=2.5, gate=1, curve=1, amp =1,
	ampModAmt=0.25, ampModFreq=10, feedbacka=0.7, feedbackb=0.8, brFreq=200, brBw=2|
	var env, sig, ampMod,in,freqT,hasFreq,ampa;
	var linspecint = LinLin.kr(  specint , 0.0,1, 800, 8000); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 1);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 50, 500); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 44, 440); //1040.1
	in =  SoundIn.ar(2,12); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;
	//In.ar(2);
	ampa = LinLin.kr(Amplitude.kr(in,mul: linamp),0.001,0.03,XLine.kr(0.2,0.8,30),XLine.kr(0.8,0.4,40));
	#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.001,median: 7);
	freqT = Gate.kr(freqT,Impulse.kr(2,0.04,40));
	env = EnvGen.kr(Env.adsr(atk, dec, [1+linamp], rel, ampa, curve), gate, doneAction:2);
	ampMod = LFNoise2.kr(ampModFreq, ampModAmt, linamp);
	sig = SinOscFB.ar(freqT/4, feedbacka) + SinOscFB.ar(linsrc, feedbackb);
	sig = HPF.ar(SoftClipAmp8.ar(sig, pregain:8) * 0.2, (linsrc * 12).min(linspecint)) +
	LPF.ar(SoftClipAmp8.ar(sig, pregain:4) * 0.2, linsrc / 2);
	sig = LPF.ar(sig,linfilter, 4);
	sig = BBandStop.ar(sig, brFreq, brBw);
	sig = sig * env * ampMod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, linlin);
	Out.ar(out, sig);
}).add;

SynthDef(\Hildur, { |gate =1, lin = 1, amp = 1, filter = 1, src =1 , specint =1 |
var in,env,ampa;
var a=GrayNoise.ar;
var b=(1..2);
	var linspecint = LinLin.kr(  specint , 0.0,1, 9, 99); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 1);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 0.5); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 9, 90);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 2, 22); //1040.1
in = SoundIn.ar([2,4],3);
ampa = LinLin.kr(Amplitude.kr(in),0.01,0.5,1,linamp);
env = EnvGen.kr(Env.asr(7, linamp, 1), gate, doneAction:2);
Out.ar([0,1],Limiter.ar(
CombL.ar(a,1,b/Duty.ar(XLine.kr(8,linsrc,42),0,Dseq([linfilter,1,2,3]*XLine.kr(99,XLine.kr(50,linlin,60),30),99)).lag3(1)).mean/2+Ringz.ar(a/linspecint,b*99).mean*env,0.3))}).add;

SynthDef(\Ambience, { |out, gate = 1, amp = 0.1, specint = 1, filter = 1 ,src = 0.51, lin = 0,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var in, freqs, hasFreq,env,ampa,sig,mult,ringa;
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.02, 10.66); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.02, 0.1);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.3, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 0.14, 1.4); //1040.1
	in = LPF.ar(LPF.ar(SoundIn.ar(2), 6000), 6000) * 10.0;//SoundIn.ar(2);
	freqs = (#[146.83, 293.66,415.30])*linsrc;
	ringa = rings*linspecint;
	env = EnvGen.kr(Env.asr(4, linamp, 1.3), gate, doneAction:2);
	sig = DynKlank.ar(`[freqs, amps, ringa], WhiteNoise.ar(linfilter)*0.006,linspecint);
	Out.ar([0,1], sig*env)
}).add;



SynthDef(\SawChoir, {
	|out=0, sus=0.95, specint = 3, freq=100, atk=4, amp=2.2, rel=0.2, mod=0.8, lin=0.5, gate=1.0, curve=1,
	scr=1040.1, modDur=0.9, modFrom=0.02, filter=0.8, rateFrom=4, rateTo=8, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd, in , ampIn, afreq,adur,aamp,modfreqsc, freqT, hasFreq,pit;
	in = SoundIn.ar(2,12);
	//# freqT, hasFreq = Tartini.kr(in,0.9,128,overlap: 128);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
	//freqT = freqT * hasFreq;
	pit = Latch.kr(freqT,Impulse.kr(1));
	freqT = Median.kr(specint,freqT);
	ampIn = Amplitude.ar(in, mul: amp);
	modfreqsc = LinLin.ar(ampIn,0.001,0.1,1.5,2);
	adur = AnalogIn.kr(0).exprange(rateTo, 3);
	afreq = AnalogIn.kr(1).exprange(modDur, 1.6);
	aamp = AnalogIn.kr(2).exprange(amp, 1.6);
	env = EnvGen.ar(Env([0, 0.63, 0.24, 0], [atk, amp, rel], [4,2,-2], curve), gate, aamp, doneAction:2);
	osca = PMOsc.ar(freqT, scr * modfreqsc, Line.kr(modFrom, filter, modDur),mul:0.1) * 0.3 ;
	oscb = PMOsc.ar(freqT * 0.5, scr * 0.25, Line.kr(modFrom, filter, modDur*2)) * 0.1 ;
	oscc = PMOsc.ar(freqT* 1.5, scr, Line.kr(modFrom, filter, modDur)) * 0.05 ;
	oscd = PMOsc.ar(freqT * 0.25, scr* 0.15, Line.kr(modFrom, filter, modDur*2)) * 0.2 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, adur, afreq)));
	// sig = Pan2.ar(sig, SinOsc.ar(XLine.kr(lin,0.1,5)));
  	OffsetOut.ar(out, sig*env);
}).add;

// SynthDef(\SawChoir, {
// 	|out=0, sus=0.95, specint = 1, freq=100, atk=4, amp=1, rel=0.2, mod=0.8, lin=1, gate=1.0, curve=1,
// 	src=1, modDur=0.9, modFrom=0.02, filter=1, rateFrom=4, rateTo=8, grEnvAtk=0.1, grEnvRel=0.5|
// 	var sig, env, osca, oscb, oscc, oscd, in , ampIn, afreq,adur,aamp,modfreqsc, freqT, hasFreq,pit;
// 	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 3); //3
// 	var linamp = LinLin.kr(  amp , 0.0,1, 0.2, 2.23);  //2.2
// 	var linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 0.8); //0.8
// 	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.5);  //0.5
// 	var linsrc = LinLin.kr(  src , 0.0,1, 104, 1040.1); //1040.1
// 	in = SoundIn.ar([2,3],2);
// 	//# freqT, hasFreq = Tartini.kr(in,0.9,128,overlap: 128);
// 	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
// 	pit = Latch.kr(freqT,Impulse.kr(1));
// 	freqT = Median.kr(linspecint,freqT);
// 	ampIn = Amplitude.ar(in, mul: linamp);
// 	modfreqsc = LinLin.ar(ampIn,0.001,0.1,1.5,2);
// 	//adur = AnalogIn.kr(0).exprange(rateTo, 3);
// 	// afreq = AnalogIn.kr(1).exprange(modDur, 1.6);
// 	// aamp = AnalogIn.kr(2).exprange(linamp, 1.6);
// 	env = EnvGen.ar(Env([0, 0.63, 0.24, 0], [atk, amp, rel], [4,2,-2], curve), gate, aamp, doneAction:2);
// 	osca = PMOsc.ar(freqT, linsrc, Line.kr(modFrom,linfilter, modDur),mul:0.1) * 0.3 ;
// 	oscb = PMOsc.ar(freqT * 0.5, linsrc * 0.25, Line.kr(modFrom, linfilter, modDur*2)) * 0.1 ;
// 	oscc = PMOsc.ar(freqT* 1.5, linsrc, Line.kr(modFrom, linfilter, modDur)) * 0.05 ;
// 	oscd = PMOsc.ar(freqT * 0.25, linsrc* 0.15, Line.kr(modFrom, linfilter, modDur*2)) * 0.2 ;
// 	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
// 	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, adur, afreq)));
// 	// sig = Pan2.ar(sig, SinOsc.ar(XLine.kr(lin,0.1,5)));
//   	OffsetOut.ar(out, sig*env);
// }).add;

SynthDef(\SinChoir, {
	|out=0, sus=0.49, freq=30, atk=8, amp=1, filter = 40, specint = 1, src = 1, rel=0.2, mod=0.8, lin=1, gate=1, curve=1,modFreq=80.1, modDur=0.24, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=12, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd, in, amc,pita,pitc,pitb,pitd, pit, pity, pite,hasFreq,ampOut;
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.3, 3); //70
	var linamp = LinLin.kr(  amp , 0.0,1, 0.02, 0.23);  //0.5
	var linfilter = LinLin.kr(  filter , 0.0,1, 4, 40); //1.2
	var linlin = LinLin.kr(  lin , 0.0,1, 0.22, 2.3);  //0.21
	var linsrc = LinLin.kr(  src , 0.0,1, 0.1, 0.9); //3100

	in = SoundIn.ar(2,12); //In.ar(2); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0; //SoundIn.ar([2,3],2);
	amc = Amplitude.kr(in,mul:linamp);
	ampOut = LinLin.kr(amc,0.002,0.4,0.1,0.9);
	//#pit, hasFreq =  Tartini.kr(in,0.9,128,overlap:128);
	#pit, hasFreq = Pitch.kr(in, ampThreshold: 0.09,median: 7);
	pity = Latch.kr(pit,pit * hasFreq);
// pit.poll;
	pita = Gate.kr(pity, Impulse.kr(linsrc));
	pitb = Gate.kr(pity*linspecint, Impulse.kr(0.7));
	pitc = Gate.kr(pity*linspecint*0.2, Impulse.kr(0.1));
	pitd = Gate.kr(pity*linspecint*0.7, Impulse.kr(0.3));
	pite = Gate.kr(pit, Impulse.kr(0.19));

	env = EnvGen.ar(Env([0, 0.23, 1, 0], [atk, ampOut, rel], [4,2,-2], curve), gate, 1, doneAction:2);
	osca = PMOsc.ar([pita +45,pita+95], 1 * 2, Line.kr(modFrom, modTo*0.1, modDur)) * 0.8 ;
	oscb = PMOsc.ar([pit,pitb+65] * 1/2, pitb * 0.25, Line.kr(modFrom, modTo*0.5, modDur*2)) * 0.3 ;
	oscc = PMOsc.ar([pit,pitc+67] * 1/6, pitc, Line.kr(modFrom, modTo, modDur*0.3)) * 0.20 ;
	oscd = PMOsc.ar([pit,pitd+98]* 0.25, pitd * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, linfilter, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));
	// sig = Pan2.ar(sig * env, StandardL.ar(70,1,lin,2));
  	OffsetOut.ar([0,1], sig*XLine.kr(0.001,ampOut,1)!2);
}).add;

SynthDef(\loca,{ arg gate =1,out=0, amp=0.5, src=3100, lin = 0.21, specint = 2000, filter = 1.2;
		var env = EnvGen.kr(Env.circle([0.001, 0.5, 1.3],[0.03,amp*8,0.3]), gate);
	var linspecint = LinLin.kr(  specint , 0.0,1, 200, 2000); //2000
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 0.5);  //0.5
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.5, 1.2); //1.2
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.21);  //0.21
	var linsrc = LinLin.kr(  src , 0.0,1, 310, 3100); //3100
		Out.ar([0,1], Resonz.ar(FreeVerb.ar( StandardL.ar(linsrc,linfilter,0.6,0,0.2), 0.73,1.2),linspecint,XLine.kr(0.001, linlin, 14))*env)
	}).add;
	
SynthDef(\BeatTrack,{ |gate = 1, amp =1,  filter = 1, lin = 1,  src = 1, specint = 1|
	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 5000); //5000
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 0.06);  //0.06
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 10000); //10000
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.7);  //0.7
	var linsrc = LinLin.kr(  src , 0.0,1, 3, 1000); //1000

	var in = LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
	var env = EnvGen.kr(Env.circle([0.001, 0.013, 0.83],[0.3,1,0.3]), gate, doneAction:2);  //~master
	var tr = Trig.kr(in,0.1);
	var ch = Changed.kr(tr,0.001);
	var bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), linsrc,0.3), 0.0);
	var hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 3000, 0.66,0.3), -0.5);
	var qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05),linspecint), 0.5);
	Out.ar([0,1], Ringz.ar([bsound + hsound + qsound],linfilter,linlin,0.05)*linamp);
}).add;

SynthDef(\LFPulse,{ |gate = 1,amp =1,  filter = 1, lin = 1,  src = 1, specint = 1|
var in1, in2 ,freqT, hasFreq, a, b,signal,env, an,anm,linampa,ampa;
	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 23); //23
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 6.2);  //1.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50); //50
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.3);  //0.3
	var linsrc = LinLin.kr(  src , 0.0,1, 3, 20); //20

in1 = SoundIn.ar(2,3); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
in2 = SoundIn.ar(4,3); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 13.0; //not in use

#freqT, hasFreq = Pitch.kr(in1, ampThreshold: 0.02,median: 7);
freqT = freqT * hasFreq;
ampa = Amplitude.kr(in1);
linampa = LinLin.kr(ampa, 0.02,0.3, 0.01,0.7);
env = EnvGen.kr(Env.asr(2, amp, 0.3), gate, doneAction:2);
a = SinOsc.ar([freqT, [freqT + linspecint ]*linampa]);
	b = SinOsc.ar(XLine.kr(4, linsrc,120));  //AnalogIn.ar(0)  b = SinOsc.ar(anm)
	rrand(a, b) * 1.81 ;
	signal = LPF.ar([b,in1],linfilter);
	OffsetOut.ar([0,1], signal*env!2);
}).add;

SynthDef(\Sequencer,{ arg out=0, filter = 0, amp = 0, lin = 0,  src = 0, specint = 0, pulse3 = 3, gate = 1;
    var a,cycle,env,in1,in2;
	var linspecint, linamp, linfilter, linlin , linsrc;
	linspecint = LinLin.kr(  specint , 0.0,1, 50, 90); //50
	linamp = LinLin.kr(  amp , 0.0,1, 3, 13.8);  //13.8
	linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 0.8);
	linlin = LinLin.kr(  lin , 0.0,1, 0, 0.4);  //0.3
	linsrc = LinLin.kr(  src , 0.0,1, 40, 90); //90
	in1 =SoundIn.ar(2,10);// LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
	in2 =SoundIn.ar(4,10);
    a = [
		SinOsc.ar(linsrc)*in1,
		Saw.ar(linspecint)*in2,
		Pulse.ar(pulse3)*in1;
        ];
    cycle = a.size  * linlin;
	env = EnvGen.kr(Env.adsr(1.6, linamp, linamp, 1),gate,doneAction:2);
    Out.ar([0,1],
        Select.ar(LFSaw.kr(linfilter,0.0,cycle,cycle),a) * env
    )
}).add;

SynthDef(\Moog,{|freq = 50, attackTime = 5, releaseTime = 4, gate = 1, src = 1,	filter = 1,	lin = 1, specint = 1,amp=1|

	var in = LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 3.0;//SoundIn.ar(2,1); //SENSITITVY
	var freqT= Pitch.kr(in, ampThreshold: 0.002,median: 7);
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.1, 2); //2
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 0.5);  //0.5
	var linfilter = LinLin.kr(  filter , 0.0,1, 0.1, 8); //8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.5);  //0.025
	var linsrc = LinLin.kr(  src , 0.0,1, 0.3, 1.36); //1.26
    var ctls = [
        // freq, phase, amp
		[ freq*linsrc, 0,    1   ],
		[ freqT*0.2, pi/2, 1],
		[ freqT*linsrc, pi/4, 1 ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ]
    ];
	var mods = [
		[SinOsc.kr(0.001,0, 1.3), SinOsc.kr(linspecint,0,1), 0, SinOsc.kr(linlin,0,1), 0, 0],
		[SinOsc.kr(0.0012,0, 0.3), SinOsc.kr(linspecint*0.5,0,0.5), 0, SinOsc.kr(linlin,0,1), 0, 0],
		[SinOsc.kr(0.0012,0, 0.3), SinOsc.kr(linspecint*0.8,0,0.5), 0,SinOsc.kr(linlin,0,1), 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0]
    ];

	var env = EnvGen.kr(Env.adsr(attackTime, 1, linamp, releaseTime),gate,doneAction:2);
	var fm = FM7.ar(ctls, mods)*LFPulse.ar(linfilter)*env;
	Out.ar([0,1],fm);
}).add

)
