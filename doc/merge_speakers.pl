#!/usr/bin/perl -w

my $NUM_ARGS = $#ARGV + 1;
if ($NUM_ARGS < 2)
{
	print("Must supply input and output file name!\n");
	print("Example: ./merge_speakers.pl whisper_transcript.txt protokoll.txt\n");
	exit;
}

my $infile  = $ARGV[0] or die "Need to get input file on the command line\n";
my $outfile = $ARGV[1] or die "Need to get output file on the command line\n";
     
open (INHANDLE, "$infile") or die ("Cannot open infile!");
open (OUTHANDLE, "> $outfile") or die ("Cannot open outfile!");

$oneline = "";
$currspeaker = "";

while (<INHANDLE>)
{
	$tmp = $_;
	chomp($tmp);
	
	($newspeaker) = $tmp =~ m/\[(.*)\].*/;
	($content) = $tmp =~ m/\[.*\]\:*(.*)/;
	
	if (length($newspeaker) < 1)
	{
		printf "line w/o apeaker found!\n";
		$newspeaker = "unbekannt";
		$content = $tmp;
	}
	
	if ($newspeaker eq $currspeaker)
	{
		$oneline = $oneline . $content;
	}
	else
	{
		if (length($oneline) > 0)
		{
			$oneline =~ s/^\s+//;
			print OUTHANDLE "[" . $currspeaker . "]: " . $oneline . "\n";
		}
		$currspeaker = $newspeaker;
		$oneline = $content;
	}
}

print OUTHANDLE "[" . $currspeaker . "]:" . $oneline . "\n";


close INHANDLE;
close OUTHANDLE;
