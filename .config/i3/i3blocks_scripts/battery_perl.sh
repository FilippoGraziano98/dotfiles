#!/usr/bin/perl
#
# Copyright 2014 Pierre Mavro <deimos@deimos.fr>
# Copyright 2014 Vivien Didelot <vivien@didelot.org>
#
# Licensed under the terms of the GNU GPL v3, or any later version.
#
# This script is meant to use with i3blocks. It parses the output of the "acpi"
# command (often provided by a package of the same name) to read the status of
# the battery, and eventually its remaining time (to full charge or discharge).
#
# The color will gradually change for a percentage below 85%, and the urgency
# (exit code 33) is set if there is less that 5% remaining.

use strict;
use warnings;
use utf8;

my $acpi;
my $status;
my $percent;
my $full_text;
my $bat_number = $ENV{BLOCK_INSTANCE} || 0;
#my $bat_number = 1

# read the first line of the "acpi" command output
open(ACPI, "acpi -b | grep 'Battery $bat_number' |");
$acpi = <ACPI>;
close(ACPI);

# fail on unexpected output
if ($acpi !~ /: (\w+(?: \w+)?), (\d+)%/) {
print "die\n";
	die "$acpi\n";
}

$status = $1;
$percent = $2;
$full_text = "";

$full_text .= "$percent%";

if ($status eq 'Discharging') {
	$full_text .= ' DIS';
} elsif ($status eq 'Charging') {
	$full_text .= ' CHR';
} elsif ($status eq 'Not charging') {
	$full_text .= ' NOT CHR';
}

if ($acpi =~ /(\d\d):(\d\d):/) {
	$full_text .= " [$1h$2m]";
}

# print text
print "$full_text\n";

# consider color and urgent flag only on discharge
if ($status eq 'Discharging') {

	print "\n";
	if ($percent < 20) {
		print "#dc143c\n";
	} elsif ($percent < 40) {
		print "#ff6347\n";
	} elsif ($percent < 60) {
		print "#98971a\n";
	}

	if ($percent < 10) {
		exit(33);
	}
}
exit(0);
