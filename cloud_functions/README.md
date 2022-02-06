Folder contains :beetle: two scripts :beetle: to help test and run gcp cloud functions locally using functions-framework:
* run-func.sh - responsible for running function
* send-pubsub.sh - responsible for sending messages similar to the way PubSub does, needs extra file `base_payload.json`, which is the base during building the JSON to send
