function y = mod(x, N)
%y = MOD(n, N)
%   Compute (x modulo N) for any x.
%
%   See also REM
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Mod.m 3     7/07/01 1:27 Fabienpe $
%   $Id: Mod.m,v 1.1 1998-06-17 12:37:26+01 fapp2 Exp $

y = rem(rem(x, N) + N, N);

