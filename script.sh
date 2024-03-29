printf "Update blocklist.txt\n"

printf "Download from AdguardTeam\n"
curl -s -L  https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/spyware.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt > adblock.unsorted

printf "Download from someonewhocares\n"
curl -s -L  https://someonewhocares.org/hosts/ > adblock.unsorted

printf "Download lists.disconnected\n"
curl -s -L https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt > adblock.unsorted
curl -s -L https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt > adblock.unsorted
curl -s -L http://sysctl.org/cameleon/hosts > adblock.unsorted

printf "Look for: ||domain.tld^\n"
# Look for: ||domain.tld^
sort -u adblock.unsorted | grep ^\|\|.*\^$ | grep -v \/ > adblock.sorted

printf "Remove extra chars and save the blocklist\n"
# Remove extra chars and save the blocklist
sed 's/[\|^]//g' < adblock.sorted > blocklist.temp


printf "Add 0.0.0.0 at the beginning of every line\n"
# Add 0.0.0.0 at the beginning of every line  https://stackoverflow.com/questions/2099471/add-a-prefix-string-to-beginning-of-each-line
sed -i -e 's/^/0.0.0.0 /' blocklist.temp


# Integrate Steven Blacks list
printf "Integrate Steven Blacks list\n"
curl -s -L https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> blocklist.temp

printf "Block Facebook but not Instagram and WhatsApp\n"
# Block Facebook but not Instagram and WhatsApp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/tfbnw >> blocklist.temp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/other >> blocklist.temp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/main >> blocklist.temp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/fbcdn.net >> blocklist.temp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/facebook.com >> blocklist.temp
# curl -s -L https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/instagram >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/facebook.com >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/fb >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/fbcdn.net >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/instagram >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/main >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/other >> blocklist.temp
# curl -s -L https://github.com/jmdugan/blocklists/blob/master/corporations/facebook/tfbnw >> blocklist.temp

printf "Add my own file called Additional.txt\n"
cat Additional.txt >> blocklist.temp

printf "Sort the file and remove all duplicates\n"
# Sort the file and remove all duplicates
sort -u blocklist.temp > blocklist.txt


printf "Remove all trailing whitespace and all comments from the file\n"
# Remove all comments from the file
sed -i '' 's|^[[:blank:]]*||g' blocklist.txt # Removes all tabs and spaces
sed -i '' '/^\s*#/ d' blocklist.txt # Removes all lines starting with #
sed -i '' '/^\s*#/ d' blocklist.txt # Removes all lines starting with #
sed -i '' '/^\(0.0.0.0 \)/!d' blocklist.txt # Removes all lines not starting with 0.0.0.0
sed -i '' '/^$/d' blocklist.txt # Removes all empty lines

printf "Remove files we no longer need\n"
# Remove files we no longer need
rm adblock.unsorted adblock.sorted blocklist.temp-e blocklist.temp

printf "Success\n"
