Description: Force SOLR_HOST to be defined, and default to localhost
Author: Didier Raboud <odyx@liip.ch>
Last-Update: 2016-08-15

--- a/bin/solr.in.sh
+++ b/bin/solr.in.sh
@@ -55,7 +55,7 @@
 
 # By default the start script uses "localhost"; override the hostname here
 # for production SolrCloud environments to control the hostname exposed to cluster state
-#SOLR_HOST="192.168.1.1"
+SOLR_HOST="127.0.0.1"
 
 # By default the start script uses UTC; override the timezone if needed
 #SOLR_TIMEZONE="UTC"
@@ -71,6 +71,9 @@
 # Set the thread stack size
 SOLR_OPTS="-Xss256k"
 
+# Force jetty host to be SOLR_HOST
+SOLR_OPTS="$SOLR_OPTS -Djetty.host=$SOLR_HOST"
+
 # Anything you add to the SOLR_OPTS variable will be included in the java
 # start command line as-is, in ADDITION to other options. If you specify the
 # -a option on start script, those options will be appended as well. Examples:
