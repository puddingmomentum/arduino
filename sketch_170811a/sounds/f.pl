#!/usr/bin/perl
use strict;
use warnings;
use File::Copy qw(move);

my $dirname = "./";
opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
my @files = readdir $dh;
closedir $dh;

foreach my $ifile (@files) {
	my $ofile = $ifile;
	$ofile =~ s/_/ /g;
	$ofile =~ s/\s{2,}/ /g;
	$ofile =~ s/\s/_/g;
#	print $ofile . "\n";
	move $ifile, $ofile;
}	
