#! usr/bin/perl -w
use strict;
use Getopt::Long;

=head1 description
Usage: perl asm_filter01.pl
	
	-asm	"assembled fasta file"
	-dgc	"DepthGC file"
	-maxD	"maxmum depth to be keeped [int] default 10000"
	-minD	"minmum depth to be keeped [int] required"
	-maxGC	"maxmum GC% to be keeped [num] default 80"
	-minGC	"minmum GC% to be keeped [num] default 10"
------------------------------------------------------
Contact: Min Tang mintang_bio@outlook.com
=cut

my ($asm, $dgc, $maxD, $minD, $maxGC, $minGC);
GetOptions(
        "asm:s"=>\$asm,
        "dgc:s"=>\$dgc,
        "maxD:i"=>\$maxD,
	"minD:i"=>\$minD,
	"maxGC:i"=>\$maxGC,
	"minGC:i"=>\$minGC
);
die `pod2text $0` if (!defined $asm || !defined $dgc || !defined$minD);
$maxD ||= 10000;
$minGC ||= 10;
$maxGC ||=80;
open IN, "$dgc" or die "$!\n";
my (%seq);
while(<IN>){
	next unless(/\d+/);
	chomp;
	my @a=split /\s+/;
	$seq{$a[0]}=1 if($a[1]>=$minD && $a[1]<=$maxD && $a[2]<=$maxGC && $a[2]>=$minGC);
}
close IN;
open FA, "$asm" or die "$!\n";
open OUT, ">$asm.filter01" or die "$!\n";
$/=">";
<FA>;
while(<FA>){
	chomp;
	my @b=split /\n/;
	my $id=shift @b;
	my $id0=(split /\s+/, $id,2)[0];
	my $fa=join "", @b;
	print OUT ">$id\n$fa\n" if(exists $seq{$id0});
}
close FA;
close OUT;
