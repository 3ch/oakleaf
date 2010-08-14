use strict;

BEGIN { require 'wakautils.pl' }



#
# Interface strings
#

use constant S_NAVIGATION => 'Navigation:';
use constant S_RETURN => 'Zur&uuml;ck';
use constant S_ENTIRE => 'Ganzer Thread';
use constant S_LAST50 => 'Letzte 50 Beitr&auml;ge';
use constant S_FIRST100 => 'Erste 100 Beitr&auml;ge';
use constant S_PREV100 => 'Vorherige 100 Beitr&auml;ge';
use constant S_NEXT100 => 'N&auml;chste 100 Beitr&aumlge';
use constant S_TOP => 'Threadliste';
use constant S_BOARDLOOK => 'Boardstil:';
use constant S_MANAGE => 'Verwalten';
use constant S_REBUILD => 'Cache neu aufbauen';
use constant S_ALLTHREADS => 'Alle Threads';
use constant S_NEWTHREAD_TITLE => 'Neuer Thread';
use constant S_NAME => 'Name:';
use constant S_LINK => 'Link:';
use constant S_FORCEDANON => '(Nur anonyme Beitr&auml;ge m&ouml;glich)';
use constant S_CAPTCHA => 'Bitte eingeben:';
use constant S_TITLE => 'Titel:';
use constant S_NEWTHREAD => 'Neuen Thread erstellen';
use constant S_IMAGE => 'Bild/Datei:';
use constant S_IMAGEDIM => 'Bild/Datei: ';
use constant S_NOTHUMBNAIL => 'Kein<br />Thumbnail';
use constant S_REPLY => 'Antworten';
use constant S_LISTEXPL => 'Zur Threadliste';
use constant S_PREVEXPL => 'Ein Thread zur&uuml;ck';
use constant S_NEXTEXPL => 'Ein Thread vor';
use constant S_LISTBUTTON => '&#9632;';
use constant S_PREVBUTTON => '&#9650;';
use constant S_NEXTBUTTON => '&#9660;';
use constant S_TRUNC => 'Beitrag ist zu lang. Hier geht es zum <a href="%s" rel="nofollow">kompletten Beitrag</a> und hier zur <a href="%s">Threadseite</a>.';
use constant S_PERMASAGED => ', permasaged';
use constant S_POSTERNAME => 'Name:';
use constant S_DELETE => 'Del';
use constant S_USERDELETE => 'Beitrag vom Benutzer gel&ouml;scht.';
use constant S_MODDELETE => 'Beitrag vom Moderator gel&ouml;scht.';
use constant S_CLOSEDTHREAD => 'Dieser Thread ist geschlossen.';
use constant S_SPAMTRAP => 'Dieses Feld leer lassen! (Spamfalle): ';

use constant S_MOREOPTS => "Erweitert";
use constant S_FORMATTING => "Formatierung:";
use constant S_SAVE_FORMATTING => "Diese Formatierung immer benutzen";
use constant S_FORMATS => {none=>"None",waka=>"WakabaMark",html=>"HTML",raw=>"Rohes HTML",aa=>"TextArt"};
use constant S_DESCRIBE_FORMATS => {
	none=>'URLS und >>-Antworten werden verlinkt, sonst nichts..',
	waka=>'Einfache Textformatierung. Eine Anleitung gibt es <a href="http://wakaba.c3.cx/docs/docs.html#WakabaMark">HIER</a>.',
	html=>'Erlaubte Tags: <em>'.describe_allowed(ALLOWED_HTML).'</em>.',
	aa=>'Verlinkt nur URLS und >>-Antworten und stellt auf eine Schriftart f&uuml;r SJIS- und ASCII-Art um',
};

use constant S_COL_NUM => "Num";
use constant S_COL_TITLE => "Titel";
use constant S_COL_POSTS => "Beitr&auml;ge";
use constant S_COL_DATE => "Letzter Beitr&auml;g";
use constant S_COL_SIZE => "Deteigr&ouml;&szlig;e";
use constant S_LIST_PERMASAGED => 'permasaged';
use constant S_LIST_CLOSED => 'geschlossen';

use constant S_FRONT => 'Frontpage';								# Title of the front page in page list


#
# Error strings
#

use constant S_BADCAPTCHA => 'Falscher CAPTCHA.';			# Error message when the captcha is wrong
use constant S_UNJUST => 'Nur POST-Methode ist zugelassen.';	# Error message on an unjust POST - prevents floodbots or ways not using POST method?
use constant S_NOTEXT => 'Kein Text eingegeben.';								# Error message for no text entered in to title/comment
use constant S_NOTITLE => 'No Titel eingegeben.';								# Error message for no title entered
use constant S_NOTALLOWED => 'Posten ist nicht erlaubt.';						# Error message when the posting type is forbidden for non-admins
use constant S_TOOLONG => 'Das %s-Feld ist um %d Zeichen zu lang.';	# Error message for too many characters in a given field
use constant S_UNUSUAL => 'Abnormale Antwort.';								# Error message for abnormal reply? (this is a mystery!)
use constant S_SPAM => 'Spammer raus!!!';					# Error message when detecting spam
use constant S_THREADCOLL => 'Jemand anders hat gleichzeitig einen Thread erstellt. Bitte erneut versuchen.';		# If two people create threads during the same second
use constant S_NOTHREADERR => 'Der Thread existiert nicht.';			# Error message when a non-existant thread is accessed
use constant S_BADDELPASS => 'Passwort falsch.';							# Error message for wrong password (when user tries to delete file)
use constant S_NOTWRITE => 'Verzeichnis nicht beschreibbar.';					# Error message when the script cannot write to the directory, the chmod (777) is wrong
use constant S_NOTASK => 'Script wurde falsch aufgerufen.';			# Error message when calling the script incorrectly
use constant S_NOLOG => 'Log.txt nicht beschreibbar.';						# Error message when log.txt is not writeable or similar
use constant S_TOOBIG => 'Die Datei ist zu gro&szlig;.';		# Error message when the image file is larger than MAX_KB
use constant S_EMPTY => 'Die Datei ist leer.';			# Error message when the image file is 0 bytes
use constant S_BADFORMAT => 'Dateiformat ist nicht erlaubt.';						# Error message when the file is not in a supported format.
use constant S_DUPE => 'Die Datei wurde <a href="%s">hier</a> schon gepostet.';	# Error message when an md5 checksum already exists.
use constant S_DUPENAME => 'Eine Datei mit dem selben Namen gibt es schon.';		# Error message when an filename already exists.
use constant S_THREADCLOSED => 'Thread ist geschlossen.';					# Error message when posting in a legen^H^H^H^H^H closed thread



#
# Templates
#

use constant GLOBAL_HEAD_INCLUDE => q{

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de">
<head>
<title><if $title><var $title> - </if><const TITLE></title>
<meta http-equiv="Content-Type" content="text/html;charset=<const CHARSET>" />
<link rel="shortcut icon" href="<const expand_filename(FAVICON)>" />

<if RSS_FILE>
<link rel="alternate" title="RSS feed" href="<const expand_filename(RSS_FILE)>" type="application/rss+xml" />
</if>

<loop $stylesheets>
<link rel="<if !$default>alternate </if>stylesheet" type="text/css" href="<var expand_filename($filename)>" title="<var $title>" />
</loop>

<script type="text/javascript">
var self="<var $self>";
var style_cookie="<const STYLE_COOKIE>";
var markup_descriptions={
<loop $markup_formats><var $id>:<var js_string(S_DESCRIBE_FORMATS-\>{$id})>,</loop>dummy:''
};
</script>
<script type="text/javascript" src="<const expand_filename(JS_FILE)>"></script>
<script type="text/javascript">require_script_version("3.a");</script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
};



use constant GLOBAL_FOOT_INCLUDE => include(INCLUDE_DIR."footer.html").q{
</body></html>
};



use constant POSTING_FORM_TEMPLATE => compile_template(q{
<if !$thread><tr>
	<td><const S_TITLE></td>
	<td>
		<input type="text" name="title" size="46" maxlength="<const MAX_FIELD_LENGTH>" />
		<input type="submit" value="<const S_NEWTHREAD>" />
	</td>
</tr></if>

<tr>
	<td>
		<if !FORCED_ANON><const S_NAME></if>
		<if FORCED_ANON><const S_LINK></if>
	</td><td>
		<if !FORCED_ANON><input type="text" name="field_a" size="19" maxlength="<const MAX_FIELD_LENGTH>" /> <const S_LINK> </if>
		<if FORCED_ANON><input type="hidden" name="field_a" /></if>
 		<input type="text" name="field_b" size="19" maxlength="<const MAX_FIELD_LENGTH>" />
		<if $thread><input type="submit" value="<const S_REPLY>" /></if>
		<if SPAM_TRAP><div style="display:none"><const S_SPAMTRAP><input type="text" name="name" size="19" autocomplete="off" /><input type="text" name="link" size="19" autocomplete="off" /></div></if>
		<small><a href="javascript:show('options<var $thread>')"><const S_MOREOPTS></a></small>
	</td>
</tr>

<if ENABLE_CAPTCHA><tr>
	<td><const S_CAPTCHA></td>
	<td>
		<input type="text" name="captcha" size="19" />
		<img class="<var $captchaclass>" src="<const expand_filename('captcha.pl')>?selector=.<var $captchaclass>" />
	</td>
</tr></if>

<tr style="display:none;vertical-align:top" id="options<var $thread>">
	<td><const S_FORMATTING></td>
	<td>
		<select name="markup" onchange="select_markup(this)"><loop $markup_formats>
		<option value="<var $id>" <if DEFAULT_MARKUP eq $id>selected="selected"</if>><var S_FORMATS-\>{$id}></option>
		</loop></select>
		<label><input type="checkbox" name="savemarkup" /> <const S_SAVE_FORMATTING></label>
		&nbsp;&nbsp; <input type="button" value="Vorschau" onclick="preview_post('<var $formid>','<var $thread>')" />
		<br /><small></small>
		<div id="preview<var $thread>" class="replytext" style="display:none"></div>
	</td>
</tr>

<tr>
	<td></td>
	<td><textarea name="comment" cols="64" rows="5" onfocus="size_field('<var $formid>',15)" onblur="size_field('<var $formid>',5)"></textarea></td>
</tr>

<if $allowimages><tr>
	<td><const S_IMAGE></td>
	<td><input name="file" size="49" type="file" /></td>
</tr></if>
});



use constant MAIN_PAGE_TEMPLATE => compile_template( GLOBAL_HEAD_INCLUDE.q{
<body class="mainpage">

}.include(INCLUDE_DIR."header.html").q{

<div id="titlebox" class="outerbox"><div class="innerbox">

<h1>
<if SHOWTITLEIMG==1><img src="<var expand_filename(TITLEIMG)>" alt="<const TITLE>" /></if>
<if SHOWTITLEIMG==2><img src="<var expand_filename(TITLEIMG)>" onclick="this.src=this.src;" alt="<const TITLE>" /></if>
<if SHOWTITLEIMG and SHOWTITLETXT><br /></if>
<if SHOWTITLETXT><const TITLE></if>
</h1>

<div class="threadnavigation">
<a href="#menu" title="<const S_LISTEXPL>"><const S_LISTBUTTON></a>
<a href="#1" title="<const S_NEXTEXPL>"><const S_NEXTBUTTON></a>
</div>

<div id="rules">
}.include(INCLUDE_DIR."rules.html").q{
</div>

</div></div>

<div id="stylebox" class="outerbox"><div class="innerbox">

<strong><const S_BOARDLOOK></strong>
<loop $stylesheets>
	<a href="javascript:set_stylesheet('<var $title>')"><var $title></a>
</loop>

</div></div>

<a name="menu"></a>

}.include(INCLUDE_DIR."mid.html").q{

<div id="threadbox" class="outerbox"><div class="innerbox">

<div id="threadlist">
<loop $allthreads><if $num<=THREADS_LISTED>
	<span class="threadlink">
	<a href="<var $self>/<var $thread>/l50" rel="nofollow"><var $num>: 
	<if $num<=THREADS_DISPLAYED></a><a href="#<var $num>"></if>
	<var $title> (<var $postcount>)</a>
	</span>
</if></loop>
</div>

<div id="threadlinks">
<a href="#newthread"><const S_NEWTHREAD_TITLE></a>
<a href="<const expand_filename(HTML_BACKLOG)>"><const S_ALLTHREADS></a>
</div>

</div></div>

<div id="posts">

<loop $threads>
	<a name="<var $num>"></a>
	<if $permasage><div class="sagethread"></if>
	<if !$permasage><div class="thread"></if>
	<h2><a href="<var $self>/<var $thread>/l50" rel="nofollow"><var $title>
	<small>(<var $postcount><if $permasage>, permasaged</if>)</small></a></h2>

	<div class="threadnavigation">
	<a href="#menu" title="<const S_LISTEXPL>"><const S_LISTBUTTON></a>
	<a href="#<var $prevnum>" title="<const S_PREVEXPL>"><const S_PREVBUTTON></a>
	<a href="#<var $nextnum>" title="<const S_NEXTEXPL>"><const S_NEXTBUTTON></a>
	</div>

	<div class="replies">

	<if $omit><div class="firstreply"></if>
	<if !$omit><div class="allreplies"></if>

	<loop $posts>
		<var $abbreviation>
		<if $abbreviated>
			<div class="replyabbrev">
			<var sprintf(S_TRUNC,"$self/$thread/$num","$self/$thread/l50")>
			</div>
		</if>

		<if $omit and $num==1>
		</div><div class="repliesomitted"></div><div class="finalreplies">
		</if>
	</loop>

	</div>
	</div>

	<form id="postform<var $thread>" action="<var $self>" method="post" enctype="multipart/form-data">
	<input type="hidden" name="task" value="post" />
	<input type="hidden" name="thread" value="<var $thread>" />
	<input type="hidden" name="password" value="" />
	<table><tbody>
	<if !$closed><var POSTING_FORM_TEMPLATE-\>(thread=\>$thread,captchaclass=\>"postcaptcha",formid=\>"postform$thread",allowimages=\>ALLOW_IMAGE_REPLIES)></if>
	<if $closed><tr><td></td><td><big><const S_CLOSEDTHREAD></big></td></tr></if>
	<tr>
		<td></td>
		<td><div class="threadlinks">
		<a href="<var $self>/<var $thread>/"><const S_ENTIRE></a>
		<a href="<var $self>/<var $thread>/l50" rel="nofollow"><const S_LAST50></a>
		<a href="<var $self>/<var $thread>/-100" rel="nofollow"><const S_FIRST100></a>
		<a href="#menu"><const S_TOP></a>
		</div></td>
	</tr>
	</tbody></table>
	</form>
	<script type="text/javascript">set_new_inputs("postform<var $thread>");</script>

	</div>
</loop>

</div>

<a name="newthread"></a>

<div id="createbox" class="outerbox"><div class="innerbox">
<h2><const S_NEWTHREAD_TITLE></h2>

<form id="threadform" action="<var $self>" method="post" enctype="multipart/form-data">

<input type="hidden" name="task" value="post" />
<input type="hidden" name="password" value="" />
<table><tbody>
<var POSTING_FORM_TEMPLATE-\>(captchaclass=\>"threadcaptcha",formid=\>"threadform",allowimages=\>ALLOW_IMAGE_THREADS)>
</tbody></table>
</form>

</div></div>

<script type="text/javascript">set_new_inputs("threadform");</script>

}.GLOBAL_FOOT_INCLUDE,KEEP_MAINPAGE_NEWLINES);




use constant THREAD_HEAD_TEMPLATE => compile_template( GLOBAL_HEAD_INCLUDE.q{
<body class="threadpage">

}.include(INCLUDE_DIR."header.html").q{

<div id="navigation">
<strong><const S_NAVIGATION></strong>
<a href="<const expand_filename(HTML_SELF)>"><const S_RETURN></a>
<a href="<var $self>/<var $thread>/"><const S_ENTIRE></a>
<a href="<var $self>/<var $thread>/-100" rel="nofollow"><const S_FIRST100></a>
<loop [map {+{'start'=\>$_*100+1}} (1..($postcount-1)/100)]>
	<a href="<var $self>/<var $thread>/<var $start>-<var $start+99<$postcount?$start+99:$postcount>" rel="nofollow"><var $start>-</a>
</loop>
<a href="<var $self>/<var $thread>/l50" rel="nofollow"><const S_LAST50></a>
</div>

<div id="posts">

<if $permasage><div class="sagethread"></if>
<if !$permasage><div class="thread"></if>
<h2><var $title> <small>(<var $postcount><if $permasage><const S_PERMASAGED></if>)</small></h2>

<div class="replies">
<div class="allreplies">
});



use constant THREAD_FOOT_TEMPLATE => compile_template( q{

</div>
</div>

<if AUTOCLOSE_SIZE>
<h4><var int($size/1024)> kb</h4>
</if>

<form id="postform<var $thread>" action="<var $self>" method="post"  enctype="multipart/form-data">

<input type="hidden" name="task" value="post" />
<input type="hidden" name="thread" value="<var $thread>" />
<input type="hidden" name="password" value="" />
<table><tbody>
<tr>
	<td></td>
	<td><div class="threadlinks">
	<a href="<const expand_filename(HTML_SELF)>"><const S_RETURN></a>
	<a href="<var $self>/<var $thread>/"><const S_ENTIRE></a>
	<if $prevpost><a href="<var $self>/<var $thread>/<var $prevpost\>99?$prevpost-99:1>-<var $prevpost>" rel="nofollow"><const S_PREV100></a></if>
	<if $nextpost><a href="<var $self>/<var $thread>/<var $nextpost>-<var $nextpost<$postcount-99?$nextpost+99:$postcount>" rel="nofollow"><const S_NEXT100></a></if>
	<a href="<var $self>/<var $thread>/l50" rel="nofollow"><const S_LAST50></a>
	</div></td>
</tr>
<if !$closed><var POSTING_FORM_TEMPLATE-\>(thread=\>$thread,captchaclass=\>"postcaptcha",formid=\>"postform$thread",allowimages=\>ALLOW_IMAGE_REPLIES)></if>
<if $closed><tr><td></td><td><big><const S_CLOSEDTHREAD></big></td></tr></if>
</tbody></table>

</form>

<script type="text/javascript">set_new_inputs("postform<var $thread>");</script>

</div>
</div>

}.GLOBAL_FOOT_INCLUDE);



use constant REPLY_TEMPLATE => compile_template( q{

<div class="reply">

<h3>
<span class="replynum"><a title="Quote post number in reply" href="javascript:insert('&gt;&gt;<var $num>',<var $thread>)"><var $num></a></span>
<const S_POSTERNAME>
<if $link><span class="postername"><a href="<var $link>" rel="nofollow"><var $name></a></span><span class="postertrip"><a href="<var $link>" rel="nofollow"><if !$capped><var $trip></if><if $capped><var $capped></if></a></span></if>
<if !$link><span class="postername"><var $name></span><span class="postertrip"><if !$capped><var $trip></if><if $capped><var $capped></if></span></if>
: <var $date>
<if $image><span class="filesize">(<const S_IMAGEDIM><em><var $width>x<var $height> <var $ext>, <var int($size/1024)> kb</em>)</span></if>
<span class="deletebutton">
<if ENABLE_DELETION>[<a href="javascript:delete_post(<var $thread>,<var $num><if $image>,true</if>)"><const S_DELETE></a>]</if>
<if !ENABLE_DELETION><span class="manage" style="display:none;">[<a href="javascript:delete_post(<var $thread>,<var $num><if $image>,true</if>)"><const S_DELETE></a>]</span></if>
</span>
</h3>

<if $image>
	<if $thumbnail>
		<a href="<var expand_filename(clean_path($image))>">
		<img src="<var expand_filename($thumbnail)>" width="<var $tn_width>" height="<var $tn_height>" 
		alt="<var clean_string($image)>: <var $width>x<var $height>, <var int($size/1024)> kb"
		title="<var clean_string($image)>: <var $width>x<var $height>, <var int($size/1024)> kb"
		class="thumb" /></a>
	</if><if !$thumbnail>
		<div class="nothumbnail">
		<a href="<var expand_filename(clean_path($image))>"><const S_NOTHUMBNAIL></a>
		</div>
	</if>
</if>

<div class="replytext"><var $comment></div>

</div>
});



use constant DELETED_TEMPLATE => compile_template( q{
<div class="deletedreply">
<h3>
<span class="replynum"><var $num></span>
<if $reason eq 'user'><const S_USERDELETE></if>
<if $reason eq 'mod'><const S_MODDELETE></if>
</h3>
</div>
});



use constant BACKLOG_PAGE_TEMPLATE => compile_template( GLOBAL_HEAD_INCLUDE.q{
<body class="backlogpage">

}.include(INCLUDE_DIR."header.html").q{

<div id="navigation">
<strong><const S_NAVIGATION></strong>
<a href="<const expand_filename(HTML_SELF)>"><const S_RETURN></a>
</div>

<div id="threads">

<h1><const TITLE></h1>

<table id="oldthreadlist">

<thead>
<tr class="head">
<th><const S_COL_NUM></th>
<th><const S_COL_TITLE></th>
<th><const S_COL_POSTS></th>
<th><const S_COL_DATE></th>
<th><const S_COL_SIZE></th>
</tr>
</thead>

<tbody>
<loop $threads>
<tr class="line<var $num&1>">

<td align="right"><var $num>:</td>
<td><a href="<var $self>/<var $thread>/l50" rel="nofollow"><var $title><if $closed or $permasage> <small>(<if $closed><const S_LIST_CLOSED></if><if !$closed and $permasage><const S_LIST_PERMASAGED></if>)</small></if></a></td>
<td align="right"><a href="<var $self>/<var $thread>/"><var $postcount></a></td>
<td><var make_date($lastmod,DATE_STYLE)></td>
<td align="right"><var int($size/1024)> kb</td>

</tr>
</loop>
</tbody></table>

</div>

}.GLOBAL_FOOT_INCLUDE);



use constant RSS_TEMPLATE => compile_template( q{
<?xml version="1.0" encoding="<const CHARSET>"?>
<rss version="2.0">

<channel>
<title><const TITLE></title>
<link><var $absolute_path><const HTML_SELF></link>
<description>Posts on <const TITLE> at <var $ENV{SERVER_NAME}>.</description>

<loop $threads><if $num<=THREADS_DISPLAYED>
	<item>
	<title><var $title> (<var $postcount>)</title>
	<link><var $absolute_self>/<var $thread>/</link>
	<guid><var $absolute_self>/<var $thread>/</guid>
	<comments><var $absolute_self>/<var $thread>/</comments>
	<author><var $author></author>
	<description><![CDATA[
		<var $$posts[0]{abbreviation}=~m!<div class="replytext".(.*?)</div!; $1 >
		<if $abbreviated><p><small>Beitrag zu lang, komplette Version ist <a href="<var $absolute_self>/<var $thread>/">hier</a>.</small></p>
		</if>
	]]></description>
	</item>
</if></loop>

</channel>
</rss>
});



use constant ERROR_TEMPLATE => compile_template( GLOBAL_HEAD_INCLUDE.q{
<body class="errorpage">

}.include(INCLUDE_DIR."header.html").q{

<div id="navigation">
<strong><const S_NAVIGATION></strong>
<a href="<var escamp($ENV{HTTP_REFERER})>"><const S_RETURN></a>
</div>

<h1><var $error></h1>

<h2><a href="<var escamp($ENV{HTTP_REFERER})>"><const S_RETURN></a></h2>

}.GLOBAL_FOOT_INCLUDE);


1;
