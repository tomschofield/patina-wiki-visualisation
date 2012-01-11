#!/usr/bin/env python
import pprint 
import json

from wikitools import wiki, api
#username, password=False, remember=False, force=False, verify=True, domain=None
params1 = {'username':'TomS',
    'password':'sxnu27',
    'remember':'False',
    'force':'False',
    'verify':'True',
    'domain':'None'
}

#wiki object
site = wiki.Wiki("http://wiki.patina.ecs.soton.ac.uk/api.php")

#login
log=site.login("TomS","sxnu27")
#params = {'action':'query',
 #   'list':'allpages',
  #  'aplimit':'550'
#}



#http://wiki.patina.ecs.soton.ac.uk/api.php?action=query&generator=allpages&gapnamespace=0&gaplimit=500&prop=revisions&rvprop=comment|user|timestamp

#http://wiki.patina.ecs.soton.ac.uk/api.php?action=query&prop=revisions&pageids=1&rvprop=timestamp|user|comment&%20rvlimit=500
#params = {'action':'query','generator':'allpages','gapnamespace':'0','gaplimit':'500','prop':'revisions','rvprop':'comment|user|timestamp'}
for i in range(873):
	print i
	#params = {'action':'query','prop':'revisions','revisions':'0','pageids':i,'rvprop':'timestamp|user|comment','rvlimit':'550'}
	params = {'action':'query','prop':'info','prop':'revisions','revisions':'0','pageids':i,'rvprop':'timestamp|user|comment','rvlimit':'550'}

	f = open('pages/'+str(i)+'pages.txt', 'w')

	req = api.APIRequest(site, params)

	res = req.query(querycontinue=False)
	
	f.write(json.dumps(res))
	f.close()
