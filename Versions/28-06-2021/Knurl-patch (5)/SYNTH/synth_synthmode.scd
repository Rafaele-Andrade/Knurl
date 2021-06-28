/***** synth_synthmode.scd *****/
/***** osc_synthmode.scd *****/
(


~mic1 = 0;
~mic2 = 1;



	SynthDef( \record_my_voice, {
		arg buf = 0;
		var input = SoundIn.ar(0,1);
		RecordBuf.ar( input, buf, loop: 0, doneAction: 2 );
	}).add;

	SynthDef(\recTrack, { arg out=0, bufnum=0, gate = 1, amp = 1;
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		in =  SoundIn.ar(0,1);
		#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.01,median: 7); 
		ampa = Amplitude.kr(in,mul:amp);
	trig = Impulse.kr( AnalogIn.ar(0).linlin(0,0.8,0.1,3)); //LinLin.kr(freqT,40,2000,0.5,20)); //MouseY.kr(0.5, 200, 1));
		env = EnvGen.kr(Env.adsr(2, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), trig, AnalogIn.ar(1).linlin(0.01,0.8,0,BufFrames.kr(c.bufnum)),10 , 1);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;
	
	SynthDef(\recPlay, { arg out=0, bufnum=0, gate = 1, amp = 1;  
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		env = EnvGen.kr(Env.adsr(0, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), loop: 1.0);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;
	
	
	SynthDef(\Talk, { | freq=0.2, amp=0.5, filter=0.2, lin=0.1,
	gateFrq=1, gateAmp=1, gateFlt=1, gateLin=1, gate = 1,
	res=0.15 |

	var freqT, hasFreq, env;
	var v1, v2, v3, v, r, base, interp, fmt1, fmt2, fmt3, f1, f2, f3, syn;

	// vowels:
	// 0 = oo, 1 = u, 2 = oh, 3 = uh,
	// 4 = er, 5 = a, 6 = ae, 7 = e,
	// 8 = i, 9 = ee, 10 = o, 11 = oe

	// Suggested parameter ranges for mapping from [0 - 1] float range with LinLin or LinExp
	// freq [87 - 240] exponantially
	// vowel [0 - 11] linear
	// range [0 - 11] linear
	// speed [0.2 - 50] exponantially

	// Scale to suggested ranges
	var scaledFreq = AnalogIn.ar(0).linexp(0, 0.7, 87, 240);
	var scaledAmp = AnalogIn.ar(1).linlin(0, 0.7, 0, 1);
	var vowel = AnalogIn.ar(0).linlin(0, 0.7, 0, 11);
	var speed = AnalogIn.ar(1).linexp(0, 0.7, 0.2, 50);

	// Apply Sample-And-Hold via gating to keep parameters
	var gFreq = Gate.kr(scaledFreq, gateFrq);
	var gAmp = Gate.kr(scaledAmp, gateAmp);
	var gVowel = Gate.kr(vowel, gateFlt);
	var gSpeed = Gate.kr(speed, gateLin);

	// for some synths SoundIn has to be programmed separetaly
	// At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0, 2);
	var sig2 = SoundIn.ar(1, 2);

	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1, ampThreshold: 0.001, median: 7);
	env = EnvGen.kr(Env.asr(4, gAmp, 1), gate, doneAction:2);

	// Synthesis
	v1 = LocalBuf.newFrom(
		[ 299, 438, 569, 518, 490, 739, 660, 528, 400, 270, 399, 360 ]);
	v2 = LocalBuf.newFrom(
		[ 850, 998, 856, 1189, 1358, 1102, 1702, 1855, 2002, 2296, 709, 1546 ]);
	v3 = LocalBuf.newFrom(
		[ 2250, 2250, 2410, 2390, 1690, 2440, 2410, 2480, 2250, 301, 2420, 2346 ]);

	// selected start vowel
	v = Wrap.kr(gVowel, 0, 11);
	// selected end vowel
	r = Wrap.kr(v + 2, 0, 11);

	base = Saw.ar(gFreq, 0.5) + Saw.ar(gFreq * 0.5, 0.3, 0.5);

	interp = LFTri.kr(gSpeed, 0, 0.5, 0.5);
	fmt1 = (Index.kr(v1, v) * (1.0 - interp)) + (Index.kr(v1, r) * interp);
	fmt2 = (Index.kr(v2, v) * (1.0 - interp)) + (Index.kr(v2, r) * interp);
	fmt3 = (Index.kr(v3, v) * (1.0 - interp)) + (Index.kr(v3, r) * interp);

	f1 = BPF.ar(base, fmt1, res);
	f2 = BPF.ar(base, fmt2, res, 0.75);
	f3 = BPF.ar(base, fmt3, res, 0.2);

	// syn = f1 + f2 + f3;
	syn = OnePole.ar(f1 + f2 + f3, 0.9) * env;
	// syn = FreeVerb.ar(syn, 0.8, 0.5, 0.5);

	Out.ar([0, 1], syn);
}).add;
SynthDef(\SinS,{ |amp= 1, out = 0 , gate = 1, filter =1, src = 1 , specint =1 , lin= 1 |
	 var in ,freqT, hasFreq,env, ampG, n,pit;
	
	var linspecint = LinLin.kr(  specint , 0.0,1, 0.01, 0.11); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.01, 1.38);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.5);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0, 3); //1040.1
	
n=LFNoise1;
in = SoundIn.ar([0,1],1);
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

SynthDef(\AudFeedback, {|src = 1, filter = 1, lin = 1, specint = 1, gate = 1, amp = 3|
	var in, pos, width, sig, sig2, sig2pan, out, chain, centroid;
	var freq, hasFreq, freq2, hasFreq2,env;
	var numOutChans = 2;
	var numInternalChannels = 2;

	var linspecint = LinLin.kr(  specint , 0.0,1, 0.01, 1); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.08, 0.8);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.1);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1,0, 1); //1040.1
	
	in = LPF.ar(LPF.ar(SoundIn.ar(0,2), 6000), 6000) * 10.0;//SoundIn.ar([~mic1,~mic2]);  // input
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
			freq.lag2(\laggin.kr(0.8), 0)
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
	) * linsrc)*env);  //tanh
}).add;

SynthDef(\Reus, { arg gate = 1, atk=0.02, amp=1, rel=2, src= 1, filter = 1, lin =1, specint = 4, gatef = 1, gateamp = 1, gatefi = 1 , gatelin= 1, freq = 1;
	var mix, t_trig, alert;
	
	var sig1 = SoundIn.ar(0,0.81); //0
	var sig2 = SoundIn.ar(1,0.81);  //1
	var pos1 = AnalogIn.ar(3);  // weird way to preamp
	var pos2 = AnalogIn.ar(5); // weird way to preamp

	var linfreq = LinLin.kr(freq, 0,1, 300, 3000);
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 3);
	var linfi = LinLin.kr(filter, 0.0,1, 100, 620);
	var linlin = LinLin.kr(lin, 0.0,1, 100, 1000);

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfi, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	
	
	var env = EnvGen.kr(Env.asr(4, gateampl, 1.3), gate, doneAction:2);
			
	
	t_trig = sig1 > 0.01;
	mix = EnvGen.ar(Env.perc, gate: t_trig) * Saw.ar(WhiteNoise.ar.range(gatefilter,1000), mul: 0.2);
	sig1 = LeakDC.ar(sig1);
	pos1 = HPF.ar(pos1, gatelinlin) * 10;
	//pos1 = pos1.lag(0.1);
	
	mix = [sig1,sig2];
	mix = LPF.ar(LPF.ar(mix, gatefreq), gatefreq) ;
	mix = mix;
	mix = mix * SinOsc.ar(gatefilter*(pos1+1.0), mul: 1);
	// pos1.poll(1);
	Out.ar([0,1],Limiter.ar(mix*env,gateampl)); 	
}).add;



SynthDef(\FreqShift,{| in=0, out=0, feedback=0.4, lin=1, src=1, specint=1, gate = 1, amp = 1,filter =1,  gatef = 1, gateamp = 1, gatefi = 1 , gatelin= 1|
	var effect,env;

	var sig1 = SoundIn.ar(0,1); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 3.0;
	var sig2 = SoundIn.ar(1,1); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;//In.ar([2,4], 2);
	
	var linfreq = LinLin.kr(  specint , 0.0,1, 0.01, 0.14); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.3, 5);  //2.2
	var linfi = LinLin.kr(  filter , 0.0,1, 0, 1); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 200, 2000); //1040.1

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfi, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	
	
	env = EnvGen.kr(Env.adsr(3, 0.01, gateampl, 3, 0.6, 2), gate, doneAction: 2);
	// effect = Mix.ar([sig1,sig2] ;//+ LocalIn.ar(1);
	effect = FreqShift.ar([sig1,sig2], LFNoise2.ar(gatefreq, linsrc));
	effect = DelayC.ar(effect, gatelinlin, GbmanN.ar(gatefilter).range(0.1,0.2));
	// LocalOut.ar(effect * feedback*env);
	Out.ar(1, Limiter.ar(effect*env, 0.4)); 
	Out.ar(0,effect*gateampl)
	}).add;



	
SynthDef(\Contra,{|out=0, sus=3.95, surface=0.0, freq=100, atk=0.02, amp=1, rel=2, lin=1,gate=1,curve=2,  specint = 1, filter=1, src=1, ampModFreq=15, ampModAmt=0.01|
	var linspecint = LinLin.kr(  specint , 0.0,1, 800, 8000); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.9, 5.2);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 70); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 0.01, 0.2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 8000, 18500); //1040.1

	var ampa=0.5, ampb=1.0, ampc=0.4, ampd=0.8;
	var afreq = XLine.kr(0.3,3.4,630);//MouseX.kr(1, 3.5);
	var adur =  XLine.kr(0.001,lin,8);//MouseX.kr(pan, 0.001);
	var aamp = 2.9;// MouseX.kr(amp, 0.5);
 	var sig, osca, oscb, oscc, oscd, distorted, in,env,freqT, hasFreq,frequencies,amplitudes,ampIn , freqMod;
 	var downsamp, samplerate=8000, bitsize=15;
	in = SoundIn.ar([0,1],0.51); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;
	// SoundIn.ar([2,3],2);
	//# freqT, hasFreq = Tartini.kr(in,0.9,16,8,overlap: 256);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
	ampIn = Amplitude.ar(in);
	freqMod = LinLin.ar(ampIn,0.001,0.05,0.2,0.6);
	env = EnvGen.ar(Env.new([0,  0.2, 2.2, 0],[atk, sus, rel], curve, 2), gate, doneAction:2);
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
	Out.ar([0,1], sig);
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
	in =  SoundIn.ar(0,1); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 3.0;
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
	Out.ar([0,1], sig);
}).add;

SynthDef(\Hildur, { |gate =1, lin = 1, amp = 1, filter = 1, src =1 , specint =1 |
var in,env,ampa;
var a=GrayNoise.ar;
var b=(1..2);
	var linspecint = LinLin.kr(  specint , 0.0,1, 9, 99); //3
	var linamp = LinLin.kr(  amp , 0.0,1, 0.0001, 0.03);  //2.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 9,99); //0.8
	var linlin = LinLin.kr(  lin , 0.0,1, 8, 2);  //0.5
	var linsrc = LinLin.kr(  src , 0.0,1, 0.1, 0.5); //1040.1
in = SoundIn.ar([2,4],1);
env = EnvGen.kr(Env.asr(7, linamp, 1), gate, doneAction:2);
Out.ar([0,1],Limiter.ar(
CombL.ar(a,1,b/Duty.ar(XLine.kr(linlin,linlin*10,42),0,Dseq([linsrc,1,2,3]*XLine.kr(99,XLine.kr(50,90,60),33),99)).lag3(1)).mean/2+Ringz.ar(a/linfilter,b*99).mean*env,linamp))}).add;

SynthDef(\SawChoir, {
	|out=0, sus=0.95, specint = 3, freq=100, atk=4, amp=4, rel=0.2, mod=0.8, lin=0.5, gate = 1, curve=1,
	scr=1040.1, modDur=0.9, modFrom=0.02, filter=0.8, rateFrom=4, rateTo=8, grEnvAtk=0.1, grEnvRel=0.5, gatef = 1, gatefi = 1, gatelin = 1,gateamp = 1|
	var sig, env, osca, oscb, oscc, oscd, in , ampIn, afreq,adur,aamp,modfreqsc, freqT, hasFreq,pit;

	var linfreq = LinLin.kr(freq,0.0,1, 0.3,3); //Her fnd a place for it
 	var linamp = LinLin.kr(amp, 0.0,1, 0.02, 0.52);
	var linfilter = LinLin.kr(filter, 0.0,1, 4, 20);
	var linlin = LinLin.kr(lin,0.0,1, 0.1, 0.9);

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfilter, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	
	
	in = SoundIn.ar(0,2);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
	
	//freqT = freqT * hasFreq;
	pit = Latch.kr(freqT,Impulse.kr(1));
	freqT = Median.kr(specint,freqT);
	ampIn = Amplitude.ar(in, mul: amp);
	modfreqsc = LinLin.ar(ampIn,0.001,0.1,1.5,2);
	
	//adur = AnalogIn.kr(0).exprange(rateTo, 3);
	//afreq = AnalogIn.kr(1).exprange(modDur, 1.6);
	//aamp = AnalogIn.kr(2).exprange(amp, 1.6);
	env = EnvGen.ar(Env([0, 3.63, 0.24, 0], [atk, amp, rel], [4,2,-2], curve), gate, 1.6, doneAction:2);
	osca = PMOsc.ar(freqT, scr * modfreqsc, Line.kr(modFrom, filter, modDur),mul:0.1) * 0.3 ;
	oscb = PMOsc.ar(freqT * 0.5, scr * 0.25, Line.kr(modFrom, filter, modDur*2)) * 0.1 ;
	oscc = PMOsc.ar(freqT* 1.5, scr, Line.kr(modFrom, filter, modDur)) * 0.05 ;
	oscd = PMOsc.ar(freqT * 0.25, scr* 0.15, Line.kr(modFrom, filter, modDur*2)) * 0.2 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, 3, 1.6)));
	// sig = Pan2.ar(sig, SinOsc.ar(XLine.kr(lin,0.1,5)));
  	Out.ar([0,1], sig*env);
}).add;

SynthDef(\SinChoir, {
	|in = 0, out=0, sus=0.49, freq=30, atk=8, amp=1, filter = 40, specint = 1, src = 1, rel=0.2, mod=0.8, lin=1, gate=1, curve=1,modFreq=80.1, modDur=0.24, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=12, grEnvAtk=0.1, grEnvRel=0.5, gatef = 1, gateamp =1, gatefi = 1, gatelin = 1|
	var sig, env, osca, oscb, oscc, oscd, osce, inp ,pita,pitc,pitb,pitd, pit, pity, pite,hasFreq,ampOut;

	var linfreq = LinLin.kr(freq,0.0,1, 5,9); //Her fnd a place for it
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 0.52);
	var linfilter = LinLin.kr(filter, 0.0,1, 4, 20);
	var linlin = LinLin.kr(lin,0.0,1, 0.1, 0.9);

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfilter, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	
	
	inp = SoundIn.ar([0,1],19).mean;

	
	#pit, hasFreq = Pitch.kr(inp, ampThreshold: 0.01,median: 7);
	//The frequency of a highe mul is holded through this hold gate; 
	pity = Latch.kr(pit,pit * hasFreq);
	
//	hasFreq.poll(1);
	//Here I create a 'choir' of counterpoint by giving different impulses on each voice. Each voice also takes one different register (Soprano, COntralto , Tenor, BASS)
	pita = Gate.kr(pity, Impulse.kr(0.9));
	pitb = Gate.kr(pity*gatefreq, Impulse.kr(0.7));
	pitc = Gate.kr(pity*gatefreq*0.2, Impulse.kr(0.1));
	pitd = Gate.kr(pity*gatefreq*1.2, Impulse.kr(0.3));
	pite = Gate.kr(pit/2, Impulse.kr(0.05));


	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

	osca = PMOsc.ar([pity,pita], 1 * 2, Line.kr(modFrom, modTo*0.1, modDur)) * 0.8 ;
	oscb = PMOsc.ar([pity,pitb] * 1/2, pitb * 0.25, Line.kr(modFrom, modTo*0.5, modDur*2)) * 0.3 ;
	oscc = PMOsc.ar([pity,pitc] * 1/6, pitc, Line.kr(modFrom, modTo, modDur*0.3)) * 0.20 ;
	oscd = PMOsc.ar([pity,pitd]* 0.25, pitd * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	osce = PMOsc.ar([pity,pite]* 0.25, pite * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	
	sig = HPF.ar(osca + oscb + oscc + oscd, gatefilter, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));
	
	// sig = Pan2.ar(sig * env, StandardL.ar(70,1,lin,2));
  	Out.ar([0,1], sig *env* gateampl!2);
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





SynthDef(\lorenzSynth, {|freq= 1, amp = 1, filter = 1 , lin = 1 ,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, modDepth=5, panSpeed=3, drive=3, gate =1|

	//The audience will be allow to change freq amo filter and lin

	var car, mod, idx, pan, fm, verb, verbMod, drv, freqT, hasFreq,env;


	// for some synths SoundIn has to be programmed separetaly, At this moment Knurl is stereo (0,1), a small preamp
	var sig1 = SoundIn.ar(0,2).linlin(0,0.2,0.5,2);
	var sig2 = SoundIn.ar(1,2).linlin(0,0.2,0.5,2);

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq =   LinLin.kr(freq, 0.0,1, 40,263);
 	var linamp =    LinLin.kr(amp, 0.0,1, 0.01, 3);
	var linfilter = LinLin.kr(filter, 0,1, 1, 20);
	var linlin =    LinLin.kr(lin,0,1, 1, 10);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	// Trackers
	#freqT, hasFreq = Pitch.kr(sig1,ampThreshold: 0.001,median: 7);


	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);

	//And finally some music!
	car = gatefreq + SinOsc.ar(gatefreq, mul: 1);
	mod = car * 0.5;

	idx = mod * LorenzL.ar(gatefilter) * gatelinlin;
	pan = SinOsc.ar(panSpeed);

	fm = Pan2.ar(
		SinOsc.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1),
		// Formant.ar( car + SinOsc.ar(mod, 0, idx), mul: 0.1, formfreq: 250, bwfreq: 100)			pos: pan
		);

	// var verb = FreeVerb.ar(fm, mix: 1, room: 2, damp: 0.5);
	verb = FreeVerb.ar(fm, room: 2, damp: 0.6);
	verbMod = SinOsc.kr(freq: 3.32) + 0.5 + 0.5;

	// var mix = verb + fm;
	// Out.ar(0, fm);
	// Mix.ar([fm, verb]);

	drv = tanh(fm * drive) / sqrt(drive);
	drv = drv *env;

	Out.ar([0, 1], (verb * verbMod + drv)* gateampl );
}).add;


SynthDef(\BeatTrack,{ |gate = 1, amp =1,  filter = 1, lin = 1,  freq = 1, specint = 1, gatef = 1, gateamp= 1, gatefi =1 , gatelin =1|

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq =LinLin.kr(freq, 0.0,1,3, 1000);
	var linamp = LinLin.kr(amp, 0.0,1, 0.1, 0.06); 
	var linfilter = LinLin.kr(filter, 0.0,1,  5, 10000); 
	var linlin = LinLin.kr(lin,0.0,1,0.025, 0.7); 

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var in = SoundIn.ar(0,2);

	var env = EnvGen.kr(Env.circle([0.001, 0.013, 0.83],[0.3,1,0.3]), gate, doneAction:2);  //~master

	var tr = Trig.kr(in,0.1);
	var ch = Changed.kr(tr,0.001);
	var bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), gatefreq,0.3), 0.0);
	var hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 3000, 0.66,0.3), -0.5);
	var qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), gatefreq*5), 0.5);

	Out.ar([0,1], Ringz.ar([bsound + hsound + qsound],gatefilter,gatelinlin,0.05)*gateampl);
}).add;

SynthDef(\LFPulse,{ |gate = 1,amp =1,  filter = 1, lin = 1,  src = 1, specint = 1|
var in1, in2 ,freqT, hasFreq, a, b,signal,env, an,anm,linampa,ampa;
	var linspecint = LinLin.kr(  specint , 0.0,1, 1, 23); //23
	var linamp = LinLin.kr(  amp , 0.0,1, 0.1, 9.2);  //1.2
	var linfilter = LinLin.kr(  filter , 0.0,1, 5, 50); //50
	var linlin = LinLin.kr(  lin , 0.0,1, 0.025, 0.3);  //0.3
	var linsrc = LinLin.kr(  src , 0.0,1, 3, 20); //20

in1 = SoundIn.ar(0,1); //LPF.ar(LPF.ar(In.ar(2), 6000), 6000) * 13.0;
in2 = SoundIn.ar(1,1); //LPF.ar(LPF.ar(In.ar(4), 6000), 6000) * 13.0; //not in use

#freqT, hasFreq = Pitch.kr(in1, ampThreshold: 0.02,median: 7);
freqT = freqT * hasFreq;
ampa = Amplitude.kr(in1);
linampa = LinLin.kr(ampa, 0.02,0.3, 0.01,0.7);
env = EnvGen.kr(Env.asr(2, linamp, 0.3), gate, doneAction:2);
a = SinOsc.ar([freqT, [freqT + linspecint ]*linampa]);
	b = SinOsc.ar(XLine.kr(4, linsrc,120));  //AnalogIn.ar(0)  b = SinOsc.ar(anm)
	rrand(a, b) * 1.81 ;
	signal = LPF.ar([b,in1],linfilter);
	OffsetOut.ar([0,1], signal*env!2);
}).add;

SynthDef(\Sequencer,{ arg out=0, lin = 0.2, amp = 0.01 , freq =1, filter = 4,  gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate =1 ;

    var a,cycle;

	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = AnalogIn.ar(DC.ar(0)).linlin( 0.0,0.7,1, 5);
	var linamp = AnalogIn.ar(DC.ar(1)).linlin( 0.0,0.7, 0.01, 0.5);
	var linfilter = AnalogIn.ar(DC.ar(0)).linlin( 0.0,0.7,  2, 8);
	var linlin = AnalogIn.ar(DC.ar(1)).linlin(0.0,0.7,0.2, 1.5);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);

	var env = EnvGen.kr(Env.asr(8, gateampl, 1), gate, doneAction:2);

    a = [
		SinOsc.ar(20*gatefreq),
		SinOsc.ar(20*gatefreq),
		SinOsc.ar(10*gatefreq),
		RLPF.ar(Pulse.ar([10*gatefreq, 25*gatefreq], 0.5, 0.1), LFSaw.kr(gatefilter,0, 400, 80), 0.05)
        ];

	cycle = a.size  * 0.5;
	Out.ar([0,1],
		 Select.ar(LFSaw.kr(gatelinlin,0,cycle,cycle),a)  * env
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
}).add;




SynthDef(\Ambience, { |out, gate = 1, amp = 0.1, specint = 1, filter = 1 ,freq = 0.51, lin = 1, gatef = 1, gateamp = 1, gatefi = 1, gatelin = 1,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var in, freqs, hasFreq,env,ampa,sig,mult,ringa;
	     
 	var linfreq = LinLin.kr(freq,0.0,1, 0.14, 5.4);
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 0.08);
	var linfilter = LinLin.kr(filter, 0.0,1, 0.3, 1);
	var linlin = LinLin.kr(lin,0.0,1, 0.02, 0.66);

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfilter, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	
	
	
	freqs = (#[146.83, 293.66,415.30])*gatefreq;
	ringa = rings;
	env = EnvGen.kr(Env.asr(4, 0.21, 1.3), gate, doneAction:2);
	sig = SinOsc.ar([146.83, 293.66,415.30]*gatefreq, WhiteNoise.ar(gatefilter)*0.006, add: gatelinlin);
	
	Out.ar(0, (sig*env)*gateampl!2);
	Out.ar(1, Limiter.ar(sig*env, gateampl/3)); 
	
}).add;


SynthDef(\Sparky, {| freq=1, amp = 1, lin=0.05, filter=0.98, drive=2, dens=1, room=0.9,gatef = 1, gateamp= 1, gatefi =1 , gatelin =1, gate = 1|
	var trig, f, tone, drv, verb, dly, env;


	//Due safety reasons, these variables may have to be Scaled between 0 and 1
	var linfreq = LinLin.kr(freq,0.0,1, 60,420);
 	var linamp = LinLin.kr(amp, 0.0,1,0.05, 6);
	var linfilter = LinLin.kr(filter, 0.0,1, 0.9, 1.1);
	var linlin = LinLin.kr(lin,0.0,1, 0.01 ,0.1);

	var gatefreq = Gate.kr(linfreq, gatef);
	var gateampl = Gate.kr(linamp, gateamp);
	var gatefilter = Gate.kr(linfilter, gatefi);
	var gatelinlin = Gate.kr(linlin, gatelin);


	trig = Dust.ar(gateampl, 1);
	f = abs(Latch.ar(WhiteNoise.ar(), trig) * (gatefilter * gatefreq) + gatefreq);
	tone = SVF.ar(trig, f, gatelinlin, 1);

	drv = tanh(tone * 2) * 2;


	dly = PingPong.ar(~tap.bufnum, [drv, drv], 0.6, 0.6);
	verb = FreeVerb.ar(dly, 0.5, room, 0.7);

	env = EnvGen.kr(Env.asr(4, gateampl, 1), gate, doneAction:2);
	Out.ar(0, verb*env);
	
}).add;


SynthDef(\ocarina, {|freq=220, filter=0.5042, lin = 1, amp = 1, res=0.005, detune =1.1, mul = 1, strength=1, gate =1, gatef = 1, gateamp =1, gatefi=1, gatelin=1 |
	var n, f1, f2, f3, f4, sum, resonz,env;
	//f = SVF.ar(WhiteNoise.ar(0.5), freq, 0.99, 0, 1);
	
	var linfreq = LinLin.kr(freq,0.0,1, 50,3000);
 	var linamp = LinLin.kr(amp, 0.0,1, 0.002, 1);
	var linfilter = LinLin.kr(filter, 0.0,1, 0.4, 2);
	var linlin = LinLin.kr(lin,0.0,1, 0.1, 0.9);

	var gatefreq = Gate.kr(linfreq, gatef);	
	var gateampl = Gate.kr(linamp, gateamp);	
	var gatefilter = Gate.kr(linfilter, gatefi);	
	var gatelinlin = Gate.kr(linlin, gatelin);	


	n = WhiteNoise.ar(1);

	resonz = Splay.arFill(4, { |i|
		Resonz.ar(n,gatefreq*pow(i+1,gatefilter), res) * pow(1 / (i+1), strength);
	}, 0, 50, 0, false);

		env = EnvGen.kr(Env.adsr(0, 4.29, gateampl,3, 0.8, 2), gate, doneAction: 2);

	Out.ar([0, 1], resonz*env*gateampl);

	//Out.ar([0, 1], [resonz, resonz]);
}).add;


SynthDef(\Converb, { arg gate =1;
 var input, output, delrd, sig, deltimes,env;
// Choose which sort of input you want by,env (un)commenting these lines:
//  input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
input = SoundIn.ar([0,1],0.1); // TAKE CARE of feedback - use headphones
//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
// Read our 4-channel delayed signals back from the feedback loop
 delrd = LocalIn.ar(4);
// This will be our eventual output, which will also be recirculated
 output = input + delrd[[0,1]];
 sig = output ++ delrd[[2,3]];
// Cross-fertilise the four delay lines with each other:
 sig = ([ [1, 1, 1, 1],
 [1, -1, 1, -1],
 [1, 1, -1, -1],
 [1, -1, -1, 1]] * sig).sum;
// Attenutate the delayed signals so they decay:
 sig = sig * [0.4, 0.37, 0.333, 0.3];
// Here we give delay times in milliseconds, convert to seconds,
// then compensate with ControlDur for the one-block delay
// which is always introduced when using the LocalIn/Out fdbk loop
 deltimes = [101, 143, 165, 177] * 0.01 - ControlDur.ir;  //I switched to 0.01 instead of 0.001 because it doesnt make sense to small feedback in this instrument
// Apply the delays and send the signals into the feedback loop
 LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
// Now let's hear it:
	env = EnvGen.kr(Env.adsr(0, 4.29, 2,3, 0.8, 2), gate, doneAction: 2);

 Out.ar(0, output*env*4.5!2);
 Out.ar(1, output*env!2);
}).add;

)
