#!/usr/bin/perl -w
use strict;
#no strict refs;
use HTML::TreeBuilder;

my %wc;

while (<@ARGV>) {
    my $tree = HTML::TreeBuilder->new;
    $tree->parse_file($_);

    my ($entry, $word, $phrase, $sentence);
    my ($pw, $ppw, $pppw, $ppppw);
    my  $i = 0;

    while ($entry = $tree->address("0.1.3.0.0.0.0.1.0.0.$i.0.0") or $entry = $tree->address("0.1.4.0.0.0.0.1.0.0.$i.0.0")) {
#	print $entry->as_text, "\n\n";
	$phrase = $entry->as_text;
	$phrase =~ s/.*Example:\s*//;
#	$sentence = $phrase;
	foreach $sentence ($phrase =~ /[^\.\?\!]+[\?\!\.\n]/g) {
	    $sentence =~ s/^\s(.*)/\1/;
#	    print "$sentence\n";
	    $pw = $ppw = $pppw = $ppppw = '';
	    foreach $word ($sentence =~ /[\w']+/g) {
		$word = lc($word);
		defined($wc{$word}{'count'}) ? $wc{$word}{'count'}++ : ($wc{$word}{'count'} = 1);
		defined($wc{$pw}{'nw'}{$word}{'count'}) ? $wc{$pw}{'nw'}{$word}{'count'}++ : ($wc{$pw}{'nw'}{$word}{'count'} = 1) if $pw;
		defined($wc{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}) ? $wc{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}++ : ($wc{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'} = 1) if $ppw;
		defined($wc{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}) ? $wc{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}++ : ($wc{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'} = 1) if $pppw;
		defined($wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}) ? $wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}++ : ($wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'} = 1) if $ppppw;

		print "$word: ", $wc{$word}{'count'}, "\n";
		print "$pw: ", $wc{$pw}{'count'}, " $word: ", $wc{$pw}{'nw'}{$word}{'count'}, "\n" if $pw;
		print "$ppw: ", $wc{$ppw}{'count'}, " $pw: ", $wc{$ppw}{'nw'}{$pw}{'count'}, " $word: ", $wc{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}, "\n" if $ppw;
		print "$pppw: ", $wc{$pppw}{'count'}, " $ppw: ", $wc{$pppw}{'nw'}{$ppw}{'count'}, " $pw: ", $wc{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'count'}, " $word: ", $wc{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}, "\n" if $pppw;
		print "$ppppw: ", $wc{$ppppw}{'count'}, " $pppw: ", $wc{$ppppw}{'nw'}{$pppw}{'count'}, " $ppw: ", $wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'count'}, " $pw: ", $wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'count'}, " $word: ", $wc{$ppppw}{'nw'}{$pppw}{'nw'}{$ppw}{'nw'}{$pw}{'nw'}{$word}{'count'}, "\n" if $ppppw;

#		print $word, " " if $word;
		$ppppw = $pppw;
		$pppw = $ppw;
		$ppw = $pw;
		$pw = $word;
	    }
#	    print "...\n";
	}
#	print "\n";
	$i++;
    }

#    print "$_: ", $tree->dump, "\n";

    $tree = $tree->delete;
}
