/**
DC Motor controlled by SYNTHdef

Diagram aavailable : https://blog.bela.io/2018/12/10/bela-controlling-dc-motors/


Connect the pulse modulation in the Pin 0
 */
s = Server.default;

s.options.numAnalogInChannels = 2;
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 16;
s.options.maxLogins = 16;  	   // set max number of clients

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.waitForBoot{
	SynthDef('blinker', {arg outPin, rate=1;
		DigitalOut.ar(outPin, Phasor.ar(SinOsc.ar(3000),0,1))
	}).add;

	s.sync;

	a = Synth('blinker', ['outPin', 6]);
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed