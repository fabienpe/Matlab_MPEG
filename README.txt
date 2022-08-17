MPEG psychoacoustic model I for MATLAB - Version 1.2.8
------------------------------------------------------

Fabien A. P. Petitcolas
fabien22@petitcolas.net
http://petitcolas.net/fabien/software/mpeg/


This is an implementation of the MPEG psychoacoustic model 1,
layer I, for MATLAB. It has been tested on MATLAB 5.2 running on
Windows NT. All you have to do is to copy the “.m” files into a
directory and call the “Test_MPEG” routine from MATLAB. Feel free
to modify this routine in order to use your own sample signal.

The “Common.m” file contains some global variables used by other
functions. In particular you can set or reset the “DRAW” variable
which tells whether graphs should be displayed at each steps of
the process; this is very useful if you want to _see_ how MPEG
works.

This implementation is based on

    Information technology -- Coding of moving pictures and
    associated audio for digital storage media at up to about
    1,5 Mbit/s -- Part 3: audio. British Standard, BSI, London.
    First edition 1993-08-01. October 1993. Implementation of
    ISO/IEC 11172-3:1993. ISBN 0-580-22594-1

This implementation is available from:

    http://petitcolas.net/fabien/software/mpeg/


---


Acknowledgements:

- When this software was first written, the author was a Ph.D
  student supported by the Intel Corporation under the grant
  “robustness of information hiding”.

- Michael Arnold (arnold@igd.fhg.de), Fraunhofer Institute
  for Computer Graphics (IGD), for reviewing the code and pointing
  out several errors.

- Kiryung Lee (kiryung@etri.re.kr), Electronics and
  Telecommunications Research Institute, Korea.

- Jonas Ekman (jonas@cutting-room.se)

- Ashok Raj Kumaran Mariappan (kumaran@ipsi.fhg.de)

---


Copyright (c) 1998--2003, Fabien A. P. Petitcolas, University of
Cambridge, England.

Redistribution and use in source and binary forms, with or without
modification, are permitted for non commercial research and
academic use only, provided that the following conditions are met:

- Redistributions of source code must retain the above
  copyright notice, this list of conditions and the following
  disclaimer. Each individual file must retain its own copyright
  notice.

- Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions, the following
  disclaimer and the list of contributors in the documentation
  and/or other materials provided with the distribution.

- Modification of the program or portion of it is allowed
  provided that the modified files carry prominent notices stating
  where and when they have been changed. If you do modify this
  program you should send to the contributors a general description
  of the changes and send them a copy of your changes at their
  request. By sending any changes to this program to the
  contributors, you are granting a license on such changes under the
  same terms and conditions as provided in this license agreement.
  However, the contributors are under no obligation to accept your
  changes.

- If you use this software for your research, please cite:

  Fabien A. P. Petitcolas, MPEG psychoacoustic model I for MATLAB,
  http://petitcolas.net/fabien/software/mpeg/


THIS SOFTWARE IS NOT INTENDED FOR ANY COMMERCIAL APPLICATION AND
IS PROVIDED ‘AS IS’, WITH ALL FAULTS AND ANY EXPRESS OR IMPLIED
REPRESENTATIONS OR WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED REPRESENTATIONS OR WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE, TITLE OR NONINFRINGEMENT OF
INTELLECTUAL PROPERTY ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

This computer program is based on ISO/IEC 11172-3:1993,
Information technology -- Coding of moving pictures and associated
audio for digital storage media at up to about 1,5 Mbit/s -- Part
3: Audio, with the permission of ISO. Copies of this standards can
be purchased from the British Standards Institution, 389 Chiswick
High Road, GB-London W4 4AL, Telephone:+ 44 181 996 90 00,
Telefax:+ 44 181 996 74 00 or from ISO, postal box 56, CH-1211
Geneva 20, Telephone +41 22 749 0111, Telefax +4122 734 1079.
Copyright remains with ISO.
