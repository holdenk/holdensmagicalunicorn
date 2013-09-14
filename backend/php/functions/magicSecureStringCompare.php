<?
/**
 * Compare two strings while attempting to limmit leaking information
 * about either string to reduce the chance of side-channel timming
 * attacks.
 * See http://en.wikipedia.org/wiki/Timing_attack
 * 
 * @param string $a
 * @param string $b
 * @return bool
 */
function magicSecureStringCompare($a, $b) {
 $different = 0;
 for ($i = 0; $i < strlen($a) or $i < strlen($b); $i++) {
   if ($i < strlen($a) and $i < strlen($b)) {
      $c1 = ord($a[$i]);
      $c2 = ord($b[$i]);
   } else {
      $different |= 1;
   }
   $different |= $c1 ^ $c2;
 }
 return $different == 0;
}
?>