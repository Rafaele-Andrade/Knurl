# Tril Craft

* Trill info
* Trill and Supercollider
* Troubleshooting with general patches


#  #  Trill info

You are able to find more info about how to instal and use this sensor here:
[learn.bela.io] (https://learn.bela.io/products/trill/working-with-trill-craft/)


#  #  Trill and Supercollider

In order to use the trill on bela we’ll have to download 2 files inside bela.

You can follow Jon's tutorial or mine (below):
* https://github.com/jreus/Trill_SC


//1. Copy the folder on the github or google drive with the name ‘TrillBela’. It contains 3 files. We will copy these files to the extension folder in SC on bela

//2. Open your terminal and go inside this file (I placed on my desktop) by running :
cd   /Users/rafaelemariaandrade/Desktop/TrillBela

//3. Now we’ll copy and paste to .so files that will enable us to use the trill craft with supercollider language, the template of this code  is:
scp   [the file]  [the address]

//so, we’ll run:
scp TrillRaw.so  root@bela.local:/usr/local/share/SuperCollider/Extensions
scp TrillCentroids.so  root@bela.local:/usr/local/share/SuperCollider/Extensions

That’s it! Now you’re able to test the trill’s files.


## Troubleshooting

If you havign troubles to run the general patches, perhaps your trill has an i2c adress that is not the same as the conventional ones. On the trillcraft , for example, bela expects the adress will be between 0x20 and 0x30. I had on mine 0x19, so I hato change this line to make it run: 

touchSensor.setup(1, 0x30, Trill::DIFF);






[Access Knurl Lab for more info](www.knurl-lab.in)
Contact: rafaeleandrade@tutanota.com

