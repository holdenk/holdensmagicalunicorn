<?php

require_once 'PHP/Token/Stream/Autoload.php';
require_once 'PHP/Token/Stream.php';
$ts = new PHP_Token_Stream($argv[1]);
foreach ($ts as $token) {
	$type = get_class($token);
	$line = $token->getLine();
	$token_txt = chop($token);
	print "$line:$type:$token_txt\n";
}
?>