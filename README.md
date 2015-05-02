# Humanizer (Matlab)

## Introdution: What is the Humanizer?
The Humanizer reads a MIDI or text file, modifies the delays of the beats, and writes a humanized midi file to disk. The beats are modified such that the timing reflects the generic play of humans. The Humanizer only reproduces the generic timing of humans and does not cover delays or other features that are introduced by musicians by intention e.g. to interpret a musical piece. The purpose of the research behind the Humanizer is to help understanding how human synchonization, timing and perception of time works.

Optional input parameters (fractal exponent, standard deviation etc.) can be adjusted. This Humanizer Matlab code works on the following platforms:

  * MAC OS X (code tested)
  * other UNIX systems (code not tested)

##Further reading:

  * H. Hennig, Synchronization in human musical rhythms and mutually interacting complex systems, PNAS 111, 12974-122979 (2014) [free download link]
  * H. Hennig, R. Fleischmann, T. Geisel. Musical rhythms: The science of being slightly off. Physics Today 65, 64-65 (2012) [free download link]
  * H. Hennig, R. Fleischmann, A. Fredebohm, Y. Hagmayer, A. Witt, J. Nagler, F. Theis and T. Geisel, The nature and perception of fluctuations in human musical rhythms, PloS ONE, 6, e26457 (2011) [free download link]

## Getting started

  * Download `t2mf`, `mf2t` from http://code.google.com/p/midi2text/ (UNIX executables; License: GNU GPL v3)
  * Place UNIX executables t2mf and mf2t in your bin folder, e.g. /Users/myusername/bin
  * Run the demo file humanizer_script_demo.m in the demo folder

## Run your own project
To run your own project: the only input file you'll need to adjust is humanizer_script.m.

  1) first, convert your MIDI file to a text file mysong.txt (just run humanizer_script.m with your `*.mid` file)
  2) divide the input text file mysong.txt into three files
    - header.txt (all lines in mysong.txt before the first "note on")
    - core.txt
    - footer.txt (footer text is usually the last two lines of mysong.txt)
  3) run humanizer.m with input file core.txt

See demo files for an example. The core file is manipulated by the Humanizer and then sandwiched in between the header and footer. You may need to adjust the time stamp in the footer (that's the total duration of the song) to the maximum value in the humanized core.txt

## Credits & License
Written by Dr. Holger Hennig
Contact/feedback: holger.hen (at) gmail.com | www.nld.ds.mpg.de/~holgerh.
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

## Package content

```
humanizer_script.m
humanizer.m
humanizer_midiread.m
noise.m
arfima.m
mics_model.m
dlmcell.m
```

### Dependencies:

You'll need the UNIX executables t2mf, mf2t; see http://code.google.com/p/midi2text/ (License: GNU GPL v3)
