#!/usr/bin/perl
print "Content-type: text/html\n";
print "\n\n";
print "test";
open FILE, ">testfile.txt" or die $!;
print FILE "test stuff";
close FILE;
