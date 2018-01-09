Description: Force SOLR_HOST to be defined, and default to localhost
Author: Didier Raboud <odyx@liip.ch>
Last-Update: 2016-08-15

--- a/bin/solr.in.sh
+++ b/bin/solr.in.sh
@@ -58,7 +58,9 @@
 
 # By default the start script uses "localhost"; override the hostname here
 # for production SolrCloud environments to control the hostname exposed to cluster state
-#SOLR_HOST="192.168.1.1"
+SOLR_HOST="127.0.0.1"
+# Force jetty host to be SOLR_HOST
+SOLR_OPTS="-Djetty.host=$SOLR_HOST"
 
 # By default Solr will try to connect to Zookeeper with 30 seconds in timeout; override the timeout if needed
 #SOLR_WAIT_FOR_ZK="30"
