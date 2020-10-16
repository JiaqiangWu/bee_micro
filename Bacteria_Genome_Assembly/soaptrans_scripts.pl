#!usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Long;

=head1 description

Usage: perl assembly_scripts.pl

        -lst	"read list of one sample"
	-maxrl	"max read length (default 150)"
	-ins	"insert size (default 350)"


Contact: Min Tang mintang_bio@outlook.com
----------------------------------------------------------

format of each line in config.txt:

SampleID        read1   read2

SampleID : usually gut-ID like B0021
read1 : data with absolute path, can be compressed
read2 : data with absolute path, can be compressed

=cut

my ($lst, $maxrl, $ins);
GetOptions(
        "lst:s"=>\$lst,
        "maxrl:i"=>\$maxrl,
        "ins:i"=>\$ins
);
die `pod2text $0` if (!defined $lst);
$maxrl ||= 150;
$ins ||= 350;
my $path = dirname($lst);
open LS, "$lst" or die "$lst $!\n";
open OUT1, ">$path/$lst\_soaptrans.sh" or die "$!\n";
while(<LS>){
	chomp;
	my @a=split /\s+/;
	my $Sid=$a[0];
        my $q1=$a[1];
        my $q2=$a[2];
        open OUT, ">$path/$Sid\_config.txt" or die "$!\n";
	print OUT "max_rd_len=$maxrl
[LIB]
avg_ins=$ins
reverse_seq=0
asm_flags=3
q1=$q1
q2=$q2\n";
	close OUT;
	if($maxrl >=150){
		print OUT1 "/home/tm/software/SOAPdenovo-Trans1.02/SOAPdenovo-Trans-127mer all -s $Sid\_config.txt -K 81 -p 16 -d 5 -t 1 -e 5 -o $Sid\n";
	}else{
		print OUT1 "/home/tm/software/SOAPdenovo-Trans1.02/SOAPdenovo-Trans-127mer all -s $Sid\_config.txt -K 61 -p 16 -d 5 -t 1 -e 5 -o $Sid\n";
	}
	print OUT1 "perl /home/tm/scripts/N50 $Sid\.scafSeq $Sid\_n50.txt $maxrl\n";
}
close LS;
