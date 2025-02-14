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
     
sub run_model {

	$curr_context = $_[0];
	$curr_line    = $_[1];
	$max_tokens   = $_[2];
	
	open(TMPHANDLE, "> tmpprompt.txt") or die "Cannot write prompt file!\n";
	
	printf TMPHANDLE "Erstelle ein Protokoll basierend auf dem folgenden Transkript:\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE $curr_context . "\n";
	printf TMPHANDLE "\"\n";
	printf TMPHANDLE "Die Worte in eckigen Klammern benennen den jeweiligen Sprecher. Fasse die Wortmeldung in indirekter Rede mit Nennung jedes Sprechers zusammen. Achte dabei besonders auf Zahlen und Fakten, fasse Dich ansonsten kurz.\n";
	
	close TMPHANDLE;
	
# 	system("cat tmpprompt.txt");

	system("echo Varianten für Zeile $curr_line: >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo \'$curr_context\' >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");

	for ($i = 1; $i < 3; $i++)
	{
		system("echo Variante $i max $max_tokens token: >> $outfile");
		system("echo ----------- >> $outfile");
 		system("./llama-cli --no-display-prompt --n-predict $max_tokens -m ../ollama-dl/library-mistral-7b-instruct/model-ff82381e2bea.gguf --file tmpprompt.txt >> $outfile");
		system("echo >> $outfile");
	}
	
	system("echo >> $outfile");
	system("echo ========================= >> $outfile");
	system("echo >> $outfile");
	
}

sub count_words {

	$curr_line = $_[0];
	
	$curr_line =~ s/\n/ /g;
	$curr_line =~ s/\[//g;
	$curr_line =~ s/\]//g;
	
	$words_curr_line = `echo \'$curr_line\' | wc -w`;
	
	printf("Count words: %s\n#####################%d##############################\n", $curr_line, $words_curr_line);
	
	return $words_curr_line;
}

open (INHANDLE, "$infile") or die ("Cannot open infile!");
system("rm -f $outfile");

my $line_counter = 0;

my $accumulated_context = "";

## tuning parameters
#
# max tokens (words * 4)?
# number words for individual processing of line (e.g. 50)
# number words for accumulated line to be processed (e.g. 100) 

while (<INHANDLE>)
{
	$tmp = $_;
	chomp($tmp);

	$line_counter++;

	$words_currline = count_words($tmp);
	
	if ($words_currline > 50)
	{
		# process this line by itself, possibly processing previously accumulated lines
		if (length($accumulated_context) > 0)
		{
			$words_accumulated = count_words($accumulated_context);

			run_model($accumulated_context, ($line_counter - 1), ($words_accumulated * 4));
			
			$accumulated_context = "";
		}
		
		run_model($tmp, $line_counter, ($words_currline * 4));
	}
	else
	{
		# accumulate short line
		$accumulated_context = $ accumulated_context . "\n" . $tmp; 
	
		$words_accumulated = count_words($accumulated_context);

		# and process if a certain length reached
		if ($words_accumulated > 100)
		{
			run_model($accumulated_context, $line_counter, ($words_accumulated * 4));		
			$accumulated_context = "";
		}
	}
}

# process leftover accumulated context
if (length($accumulated_context) > 0)
{
	$words_accumulated = count_words($accumulated_context);

	run_model($accumulated_context, ($line_counter - 1), ($words_accumulated * 4));
	
	$accumulated_context = "";
}

close INHANDLE;
