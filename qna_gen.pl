#!perl
use warnings;
use strict;
use 5.036;

use utf8;
use JSON::XS qw(encode_json decode_json);

use File::Slurp qw(read_file write_file);

use JSON::PP qw();


binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

my ($json_file, $TeX_file_Q, $TeX_file_A, $TeX_file_I) = @ARGV;

die "Usage: $0 qna.json TeX_file_questions.tex TeX_file_answers.tex TeX_file_answers_index.tex\n"
    unless $json_file && $TeX_file_Q && $TeX_file_A && $TeX_file_I;


my $json_text = read_file($json_file);

my $data = decode_json($json_text);

open(my $fh_Q, ">:encoding(UTF-8)", $TeX_file_Q) or die "Could not open TeX questions file '$TeX_file_Q' $!";
open(my $fh_A, ">:encoding(UTF-8)", $TeX_file_A) or die "Could not open TeX answers file '$TeX_file_A' $!";
open(my $fh_I, ">:encoding(UTF-8)", $TeX_file_I) or die "Could not open TeX answers file '$TeX_file_I' $!";

for my $q (@$data){
           
#print $fh_Q '\noindent\begin{minipage}{\linewidth}',"\n";


print $fh_Q <<"TeX";
\\begin{minipage}{\\linewidth}
\\vspace\{1em\}\\noindent\\textbf\{$q->{ref}. $q->{question}\}

TeX


if($q->{image} && $q->{alt}){
print $fh_Q <<"TeX";
\\vspace{1ex}
\\centering
\\includegraphics[width=0.8\\linewidth]{ $q->{image} }
\\captionof*{figure}{ $q->{alt} }

TeX
}

print $fh_Q '\begin{itemize}[nosep,leftmargin=2em]',"\n";


my $letter=ord("A");
for my $a ($q->{answers}->@*){
	print $fh_Q '\item ['. chr( $letter ).'.] ',$a->{text},"\n";

    if($a->{correct}) {
        print $fh_A '\begin{minipage}{\linewidth}',"\n",'\noindent\textbf{'
    , $q->{ref},'.} '
    , ' -- \textbf {('
    , chr( $letter ) , ').} ',
    , $q->{question},
    '  \textbf {'
    , $a->{text} ,'} ',
    ,'\par \textit {'
    , $q->{reasoning},  '} \\\\'
    ,"\n"
    ,'\end{minipage}'
    , "\n\n";

    print $fh_I '\noindent '
    , $q->{ref},'. '
    , ' -- ('
    , chr( $letter ) , ') \\\\'
    , "\n\n";
    }
    
    ++$letter;
}


print $fh_Q <<'TeX';

\end{itemize}
\end{minipage}


TeX

#print $fh_Q '\begin{minipage}{\linewidth}',"\n";
#print $fh_Q '\Question{'.$q->{question}.'}',"\n";


#print $fh_Q '\begin{answers}',"\n";
#for my $a ($q->{answers}->@*){
#    if($a->{correct}){
#    print $fh_Q "\t", '\correctchoise {' , $a->{text} , '}{' , $q->{reasoning} ,'}' ,"\n";
#    } else {
#    print $fh_Q "\t",'\choise {',$a->{text},'}',"\n";
#    }
#}
#print $fh_Q '\end{answers}',"\n";
#print $fh_Q '\end{minipage}',"\n";

#print $q->{ref},". ",$q->{question},"\n";
#if($q->{image} && $q->{alt}){
#print "IMAGE: $q->{image}; $q->{alt}\n"
#}
#print "Answers:\n";
#for my $a ($q->{answers}->@*){
#print ' • ',$a->{text},"\n";
#}
#print "\n";
}


close $fh_Q;
close $fh_A;





