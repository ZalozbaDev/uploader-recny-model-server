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

# my $accumulated_context = "";

while (<INHANDLE>)
{
	$tmp = $_;
	chomp($tmp);

	$line_counter++;
	
	$words_in_line = `echo $tmp | wc -w`;
	# printf("Words detected: %d.\n", $words_in_line);
	
	$num_output_tokens = $words_in_line * 4;
	if ($num_output_tokens < 100)
	{
		$num_output_tokens = 100;
	}
	printf("Words detected in context=%d, thus limiting output to %d tokens.\n", $words_in_line, $num_output_tokens);
	
	open(TMPHANDLE, "> tmpprompt.txt") or die "Cannot write prompt file!\n";
	
	printf TMPHANDLE "Erstelle ein Protokoll basierend auf dem folgenden Transkript:\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE $tmp . "\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE "Die Worte in eckigen Klammern benennen den jeweiligen Sprecher. Fasse die Wortmeldung in indirekter Rede mit Nennung jedes Sprechers zusammen. Achte dabei besonders auf Zahlen und Fakten, fasse Dich ansonsten kurz.\n";
	
	close TMPHANDLE;
	
# 	system("cat tmpprompt.txt");

	system("echo Varianten für Zeile $line_counter: >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo $tmp >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");

	for ($i = 1; $i < 3; $i++)
	{
		system("echo Variante $i max $num_output_tokens token: >> $outfile");
		system("echo ----------- >> $outfile");
		system("./llama-cli --no-display-prompt --n-predict $num_output_tokens -m ../ollama-dl/library-mistral-7b-instruct/model-ff82381e2bea.gguf --file tmpprompt.txt >> $outfile");
		system("echo >> $outfile");
	}
	
	system("echo >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");
	
}

close INHANDLE;
