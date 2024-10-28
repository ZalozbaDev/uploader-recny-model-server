#!/usr/bin/perl -w

my $NUM_ARGS = $#ARGV + 1;
if ($NUM_ARGS < 2)
{
	print("Must supply input and output file name!\n");
	print("Example: ./summarize_per_line.pl tema_1_merged_noprompt.txt tema_1_protokoll_per_line.txt\n");
	exit;
}

my $infile  = $ARGV[0] or die "Need to get input file on the command line\n";
my $outfile = $ARGV[1] or die "Need to get output file on the command line\n";
     
open (INHANDLE, "$infile") or die ("Cannot open infile!");
system("rm -f $outfile");

my $line_counter = 0;

while (<INHANDLE>)
{
	$tmp = $_;
	chomp($tmp);

	$line_counter++;
	
	open(TMPHANDLE, "> tmpprompt.txt") or die "Cannot write prompt file!\n";
	
	printf TMPHANDLE "Erstelle ein detailliertes Protokoll basierend auf dem folgenden Transkript:\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE $tmp . "\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE "Die Worte in eckigen Klammern benennen den Sprecher. Fasse die Wortmeldung in indirekter Rede mit Nennung des Sprechers zusammen.\n";
	
	close TMPHANDLE;
	
# 	system("cat tmpprompt.txt");

	system("echo Varianten für Zeile $line_counter: >> $outfile");
	system("echo $tmp >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");

	for ($i = 1; $i < 3; $i++)
	{
		system("echo Variante $i: >> $outfile");
		system("echo ----------- >> $outfile");
		system("./llama-cli --no-display-prompt -m ../ollama-dl/library-mistral-7b-instruct/model-ff82381e2bea.gguf --file tmpprompt.txt >> $outfile");
		system("echo >> $outfile");
	}
	
	system("echo >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");
	
}

close INHANDLE;
