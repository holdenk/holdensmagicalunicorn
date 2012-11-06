#!/usr/bin/perl
# The purpose of this is to turn the entire pipeline, possibly on multiple machines
# First step is to get the list of projects to consider which runs on a single host
# but we don't have to block on it
open (BINGTARGETS , "perl targets.pl| tee bingtargets |");
open (GHTARGETS, "perl targets2.pl| tee ghtargets |");
open (BQTARGETS, "perl bigquerytargets.pl| tee bqtargets|");
