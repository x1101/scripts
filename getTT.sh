#!/bin/bash

######
#	Apparently Nathan Lowells books are coming off podiobooks
#	Since that sucks, I want them saved somewhere
######

## List of the podcasts RSS Feeds
podcastlist=(
http://podiobooks.com/rss/feeds/episodes/trader-tales-1-quarter-share/
http://podiobooks.com/rss/feeds/episodes/trader-tales-2-half-share/
http://podiobooks.com/rss/feeds/episodes/trader-tales-3-full-share/
http://podiobooks.com/rss/feeds/episodes/trader-tales-4-double-share/
http://podiobooks.com/rss/feeds/episodes/trader-tales-5-captains-share/
http://podiobooks.com/rss/feeds/episodes/trader-tales-6-owners-share/
)

for podcast in ${podcastlist[@]}; do
	## Make a dir to hold the podcasts
	dir=`echo ${podcast}|awk -F- '{print "0"$3" - "$4,$5}'|sed 's/\///g'|sed -r 's/\b(.)/\U\1/g'`
	mkdir "${dir}"
	echo "Doing ${dir}"
	cd "${dir}"
	## And get all the episodes
	episodes=(`wget -q -O - ${podcast} | sed 's/<\//\n<\//g'|grep enclosure|egrep -v '(itunes|donate|Outro)'|awk '{print $2}'|awk -F= '{print $2}'|sed 's/"//g'`)
	for ep in ${episodes[@]}; do
		echo "Getting ${ep}"
		wget -q ${ep}
	done
	cd ..
done
