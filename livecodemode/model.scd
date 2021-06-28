// Execute the following in order
(
// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

c = Buffer.alloc(s, 44100 * 2.0, 1); // a four second 1 channel Buffer
)

// record for four seconds
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)

// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)

// overdub
(
SynthDef(\help_RecordBuf_overdub, { arg out=0, bufnum=0, gate= 2 ;
    var formant,playbuf,env,sig;
	formant = SoundIn.ar(0,2);//Formant.ar(XLine.kr(50, 1000, 4), 2000, 800, 0.125);
    // mixes equally with existing data
	env = EnvGen.kr(Env.adsr(0, 1.29, 1, 3, 0.8, 2), gate, doneAction: 2);
    playbuf = RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, loop: 1);
	sig = env * playbuf;
}).play(s, [\out, 0, \bufnum, b]);
)

	SynthDef(\recPlay, { arg out=0, bufnum=0, gate = 1, amp = 1;
		var trig, env, sig, playbuf,in,freqT,hasFreq,ampa;
		env = EnvGen.kr(Env.adsr(0, 1.29, amp, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), loop: 1.0);
		sig = env * playbuf;
		Out.ar([0,1], sig)
	}).add;

Synth(\recPlay)

// play back the overdubbed version
Synth.new(\help_RecordBuf_playback, [\out, 0, \bufnum, b], s);

// write the contents of the buffer to a file (see Buffer for more options)
(
b.write(sampleFormat: 'int16');
thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff"; // generated path
)

b.close; b.free; // cleanup


// record another one
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
	formant = SoundIn.ar(0,1);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, c]);
)


// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, c]);
)