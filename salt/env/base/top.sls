base:
 '*':
   - states.networkconf
 '*dbcfg*':
   - states.mongodb.mongocfgsvr
 '*dbrt*':
   - states.mongodb.mongossvr
 '*db[0-9]*':
   - states.mongodb.mongodbsvr 
 '*web*':
   - states.node
   - states.deploy
 '*api*':
   - states.node
   - states.deploy
 '*cache*':
   - states.couchdb
 '*lb*':
   - states.nginx
