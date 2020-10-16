#!usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Long;

=head1 description

Usage: perl asmfilter01_scripts.pl

        -lst	"read list of one sample"
	-dgc	"DepthGC_filter.txt"

Contact: Min Tang mintang_bio@outlook.com
----------------------------------------------------------

=cut

my ($dgc, $lst);
GetOptions(
        "lst:s"=>\$lst,
	"dgc:s"=>\$dgc
);
die `pod2text $0` if (!defined $lst || !defined $dgc);
my $path = dirname($lst);
open LS, "$lst" or die "$lst $!\n";
open DGC, "$dgc" or die "$dgc $!\n";
my %depth;
while(<DGC>){
	chomp;
	my @a=split /\s+/;
	$depth{$a[0]}=$a[1];
}
close DGC;
open OUT1, ">$path/$lst\_asmfilter01.sh" or die "$!\n";
while(<LS>){
	chomp;
	my @a=split /\s+/;
	my $Sid=$a[0];
        my $q1=$a[1];
        my $q2=$a[2];
	print OUT1 "perl depthGC_of_wig.pl $Sid\.DepthGC.wig.gz
perl asm_filter01.pl -asm $Sid\.scafSeq -dgc $Sid\.DepthGC -minD $depth{$Sid}\n";
}
close LS;
close OUT1
