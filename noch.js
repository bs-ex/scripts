/*
 * Title: NoCH (No Cyberhound)
 * Description: Remove CyberHound link tracking from DayMap links.
 */
var page_links = document.links
for(var counter = 0; counter < page_links.length; counter++){
    if(!page_links[counter].href.includes("localnetwork"))
        continue
    page_links[counter].href = page_links[counter].href.match("http.*(?=\", "h")")
}
