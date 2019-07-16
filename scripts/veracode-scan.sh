echo "starting veracode scan" && \
java -jar vosp-api-wrappers-java-$VERACODE_WRAPPER_VERSION.jar -vid $VERACODE_API_ID -vkey $VERACODE_API_KEY \
-action uploadandscan -appname "eosio-swift-ios-example-app" -createprofile false \
-filepath "/Users/travis/build/EOSIO/eosio-swift-ios-example-app/$APPNAME.app" -version "$TRAVIS_JOB_ID - $TRAVIS_JOB_NUMBER $DATE" -scantimeout 3600 
