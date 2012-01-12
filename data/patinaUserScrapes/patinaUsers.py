#!/usr/bin/env python
import pprint 
import json

from wikitools import wiki, api
#username, password=False, remember=False, force=False, verify=True, domain=None
params1 = {'username':'USERNAME',
    'password':'PASSWORD',
    'remember':'False',
    'force':'False',
    'verify':'True',
    'domain':'None'
}

#wiki object
site = wiki.Wiki("http://wiki.patina.ecs.soton.ac.uk/api.php")

#login
log=site.login("USERNAME","PASSWORD")
#params = {'action':'query',
 #   'list':'allpages',
  #  'aplimit':'500'
#}

#declare an array of user strings
a = [ 'AngelikiC', 'AnneB' , 'DanieleS', 'DannyW', 'EmmaT', 'EnricoC', 'GraemeE', 'LucM', 'MadelineB', 'MartynD', 'MattJ', 'MikeF', 'MikeJ', 'PeterB', 'RosamundD', 'TomF','TomS' ]

for x in a:
	print x
	params = {'action':'query',
	    'list':'usercontribs',
	    'ucuser':x,
 	   'uclimit':'500',
	    'ucdir':'newer'    
	}

	f = open('apiResult_'+x+'.txt', 'w')

	req = api.APIRequest(site, params)

	res = req.query(querycontinue=False)
	
	f.write(json.dumps(res))
	f.close()
	
