Marioneter performance  (Knurl Speaks!)


1-creating a buffer
2-making a task of events


1-------------------------------------------------------------------------

(
 SynthDef(\playBuffer,{arg out = 0, buf;
         var sig;
         sig = PlayBuf.ar(2, buf, doneAction: Done.freeSelf);
         Out.ar(out, sig);
         }).add

 ~routine = Routine({
            ~buffers.do({
                arg item;
                var synth;
                synth = Synth(\playBuffer, [\buf, item]);
                item.duration.wait;
                synth.free;
             });
           });
~routine.play;
)



b = Buffer.read(s, "translator.mp4"); // remember to free the buffer later.

SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: Done.freeSelf)
    )
}).play(s, [\out, 0, \bufnum, b]);



2 ------------------------------------------------------------------------------