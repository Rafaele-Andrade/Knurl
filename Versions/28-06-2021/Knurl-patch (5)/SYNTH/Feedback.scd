01, amp, 3, 0.6, 5), gate, doneAction: 2);
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