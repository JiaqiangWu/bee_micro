#! usr/bin/perl -w
use strict;

die "Usage: perl $0 <wig.gz file>\n" unless(@ARGV==1);
my $out=$ARGV[0];
$out =~ s/\.wig.*//;
if ($ARGV[0] =~ /gz$/){
	open IN, "gzip -dc $ARGV[0] |" || die "$!\n";
} else {
	open IN, "<$ARGV[0]" || die "$!\n";
}
open OUT, ">$out" or die "$!\n";
print OUT "Scaftig\tavg_depth\tavg_GC\n";
$/="#>";
<IN>;
while(<IN>){
	chomp;
	my @a=split /\n/;next if(@a==1);
	my $id=(split /\s+/, $a[0])[0];
	my $depth=0; my $gc=0;
	for my $i(1..$#a){
		my @b=split /\s+/, $a[$i];
		next if($a[$i]=~ /NA/);
		$depth+=$b[1];
		$gc+=$b[2];
	}
	my $avgD=sprintf '%.1f', $depth/$#a;
	my $avggc=sprintf '%.1f', $gc/$#a;
	print OUT "$id\t$avgD\t$avggc\n";
}
close IN;
close OUT;
