#!/usr/bin/perl

#
#	Kareha mobile reader - v20071108 by Squeeks
#

#	Configuration option: 
	use constant SHOWN_LINES => 4; # Truncates individual posts in a thread


use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use lib '.';
BEGIN { require 'config.pl'; }
BEGIN { require 'config_defaults.pl'; }
BEGIN { require 'wakautils.pl'; }
BEGIN { require 'kareha.pl'; }

use constant MOBILE_HEAD_INCLUDE => q{
<?xml version="1.0" encoding="<const CHARSET>"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=<const CHARSET>" />
<title><const TITLE></title><style type="text/css">h1, h2, .replythread, .reply{margin-bottom:0;display:inline;}</style>
</head>
<body>
};

use constant FRONT_TEMPLATE => compile_template(MOBILE_HEAD_INCLUDE.q{
<p><b><const TITLE></b></p>
<hr />
<loop $threads>
<var $num>: <a href="<var $self>/<var $thread>/l10"><var $title or "Thread $thread"> (<var $postcount>)<if $closed or $permasage> <small>(<if $closed>closed</if><if !$closed and $permasage>permasaged</if>)</small></if></a><br>
</loop>
<br>
<a href="<var $self>/list"><const S_TOP></a>
<hr />
</body></html>
});


use constant LIST_TEMPLATE => compile_template(MOBILE_HEAD_INCLUDE.q{
<p><b><const TITLE></b></p>
<a href="<var $self>"><const S_RETURN></a>
<hr />
<loop $threads>
<var $num>: <a href="<var $self>/<var $thread>"><var $title or "Thread $thread"> (<var $postcount>)<if $closed or $permasage> <small>(<if $closed>closed</if><if !$closed and $permasage>permasaged</if>)</small></if></a><br>

</loop>

</body></html>
});


use constant THREAD_TEMPLATE => compile_template(MOBILE_HEAD_INCLUDE.q{
<loop $shownthreads>
	<a href="<var $self>"><const S_RETURN></a> - <a href="<var $self>/<var $thread>/"><const S_ENTIRE></a> - <a href="<var $self>/<var $thread>/l10"><const S_LAST10></a><br>
	<hr />
	<h1><var $title or "Thread $thread"> (<var $postcount>)</h1><br>
	<loop $posts>
		<var $abbreviation>
		<if $abbreviated>
			<var sprintf(S_MO_TRUNC,"$self/$thread/$num","$num")>
		</if>
	</loop>
</loop>

</body></html>

});

eval "use constant S_MO_TRUNC => '<a href=\"%s\">Ganzen Beitrag anzeigen...</a>'" unless(defined &S_MO_TRUNC);
eval "use constant S_LAST10 => 'Die letzten 10 BeitrŠge anzeigen...'" unless(defined &S_LAST10);

my @threads=get_threads(1);

my @shownthreads;
my $showlist;
my ($threadnum,$ranges,$list,$info,$page)=$ENV{PATH_INFO}=~
	m!/(?:([0-9]+)(?:/(.*)|)|(list)|(info)|p([0-9]+))!i;

if($threadnum)
{
	if ($ranges =~/^\d/) { show_threads( filter_post_ranges($threadnum,$ranges,50) ); }
	else {show_threads( filter_post_ranges($threadnum,$ranges,SHOWN_LINES) ); }
}
elsif($list)
{
	show_list();
}
else
{
	show_front();
}

sub show_threads(@)
{
	my @shownthreads=@_;

	print_http_header();

	print THREAD_TEMPLATE->(
		threads=>\@threads,
		shownthreads=>\@shownthreads,
		currpage=>$page,
	);
}

sub show_front()
{
	print_http_header();

	my @thread_list;
	
	for(1..THREADS_DISPLAYED)
	{ 
		last unless @threads;
		push(@thread_list,shift(@threads));
	}

	print FRONT_TEMPLATE->( threads=>\@thread_list );
	
}

sub show_list()
{
	print_http_header();

	print LIST_TEMPLATE->( threads=>\@threads );
}

sub print_http_header()
{
	print "Content-Type: ".get_xhtml_content_type(CHARSET,0)."\n\n";
}