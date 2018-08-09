# Download AdBlock Lists (EasyList, EasyPrivacy, Fanboy Annoyance / Social Blocking)
curl -s -L https://easylist.to/easylist/easylist.txt https://easylist.to/easylist/easyprivacy.txt https://easylist.to/easylist/fanboy-annoyance.txt https://easylist.to/easylist/fanboy-social.txt https://easylist.to/easylistgermany/easylistgermany.txt https://easylist-downloads.adblockplus.org/liste_fr.txt https://easylist-downloads.adblockplus.org/antiadblockfilters.txt https://easylist-downloads.adblockplus.org/easyprivacy.tpl https://fanboy.co.nz/r/fanboy-complete.txt https://fanboy.co.nz/fanboy-antifacebook.txt > adblock.unsorted

# Look for: ||domain.tld^
sort -u adblock.unsorted | grep ^\|\|.*\^$ | grep -v \/ > adblock.sorted

# Remove extra chars and put list under lighttpd web root
sed 's/[\|^]//g' < adblock.sorted > blocklist.txt


# Add 0.0.0.0 at the beginning of every line  https://stackoverflow.com/questions/2099471/add-a-prefix-string-to-beginning-of-each-line
sed -i -e 's/^/0.0.0.0 /' blocklist.txt

# Remove files we no longer need
rm adblock.unsorted adblock.sorted blocklist.txt-e
