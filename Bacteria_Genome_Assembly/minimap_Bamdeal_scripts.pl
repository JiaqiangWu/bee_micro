#!usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Long;

=head1 description

Usage: perl minimap_Bamdeal_scripts.pl

        -lst	"read list of one sample"


Contact: Min Tang mintang_bio@outlook.com
----------------------------------------------------------

format of each line in config.txt:

SampleID        read1   read2

SampleID : usually gut-ID like B0021
read1 : data with absolute path, can be compressed
read2 : data with absolute path, can be compressed

=cut

my $lst;
GetOptions(
        "lst:s"=>\$lst,
);
die `pod2text $0` if (!defined $lst);
my $path = dirname($lst);
open LS, "$lst" or die "$lst $!\n";
open OUT1, ">$path/$lst\_minimap_Bamdeal.sh" or die "$!\n";
while(<LS>){
	chomp;
	my @a=split /\s+/;
	my $Sid=$a[0];
        my $q1=$a[1];
        my $q2=$a[2];
	print OUT1 "/home/tm/software/minimap2-2.9/minimap2 -ax sr -t 24 $Sid\.scafSeq $q1 $q2|samtools view -q 1 -b > $Sid\.bam
echo \"$Sid\.bam\" > $Sid\.bam.lst
/home/tm/software/BamDeal-0.19/BamDeal visualize DepthGC -Windows 100 -InList $Sid\.bam.lst -Ref $Sid\.scafSeq -OutPut $Sid\n";
}
close LS;
close OUT1
