print "<h3>Please review the following Github Pull requests.</h3>
<div class=\"highlight-box\">
<ul>
    <li>Reject any pull request which looks like it could harm the project in question</li>
    <li>For example if it changes the name of a variable but not in all of the referenced places, reject the pull request</li>
    <li>If a pull request looks to change the functionality in a substantail way reject the pull request</li>
    <li>These pull requests are intended to fix bugs/remove deprecated function calls and improve spelling, they should not alter the functionality of the software.</li>
</ul>
</div>";
my $k = 0;
while ($k < 11) {
    $k++;
    print "<p>".$k.". Should we approve <a href=\"\${diff_url".$k."}\">\${diff_url".$k."}</a> with a msg of \${msg".$k."} to github \${user".$k."}</p>
<table cellspacing=\"4\" cellpadding=\"0\" border=\"0\">
    <tbody>
        <tr>
            <td valign=\"center\"><input type=\"radio\" name=\"Q".$k."\" value=\"y\" /></td>
            <td><span class=\"answertext\">Yes</span></td>
        </tr>
        <tr>
            <td valign=\"center\"><input type=\"radio\" name=\"Q".$k."\" value=\"n\" /></td>
            <td><span class=\"answertext\">No</span></td>
        </tr>
    </tbody>
</table>";
}
$k++;
print "
<p>$k. Enter a name (or non-offensive pseudnym) to be associated with the review (this may be published as part of the commit)</p>
<p><input type=\"text\" name=\"name\" id=\"name\" size=\"20\" /></p>
<p>Provide feedback on our work.</p>
<p><textarea name=\"comment\" cols=\"80\" rows=\"3\"></textarea></p>
<p><style type=\"text/css\">
<!--
.highlight-box { border:solid 0px #98BE10; background:#FCF9CE; color:#222222; padding:4px; text-align:left; font-size: smaller;}
-->
</style></p>";
