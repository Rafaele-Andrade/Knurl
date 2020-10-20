/***** settings.scd *****/

s = Server.default;

s.options.numAnalogInChannels = 2; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 2; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.maxLogins = 8;
s.options.pgaGainLeft = 40;     // sets the pregain for the left audio input (dB)
s.options.pgaGainRight = 40;    // sets the pregain for the right audio input (dB)
s.options.headphoneLevel = 50; // sets the headphone level (-dB)
s.options.speakerMuted = -1;    // set true to mute the speaker amp and draw a little less power

s.options.dacLevel = 0;       // sets the gain of the analog dac to (dB)  // don't change this , bela doesn't boot if you run 
s.options.adcLevel = 0;       // sets the gain of the analog adc to (dB)  // mini jack doens't work if it is not <=0

s.options.blockSize = 128;
// s.options.blockSize = 128;//512; //1
s.options.numInputBusChannels = 10;  // analog pins becomes audio
s.options.numOutputBusChannels = 2;  

s.options.sampleRate= 88200;
s.options.maxNodes = 1024 * 64; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numAudioBusChannels = 1024;
s.options.memSize = 8192 * 32; // the default is 8192 which is quite little
s.options.hardwareBufferSize = 128;
 
//  s.options.numAnalogInChannels = 8;
// s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

// s.options.blockSize = 16;

