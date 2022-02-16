Folder contains :beetle: two scripts :beetle: to help test and run gcp cloud functions locally using functions-framework:
* run-func.sh - responsible for running function

Example usage:
```
run-func.sh -f auto.py -fn main -st pubsub -p 8000
```

* send-pubsub.sh - responsible for sending messages similar to the way PubSub does, needs extra file `base_payload.json`, which is the base during building the JSON to send

Example usage:
```
send-pubsub.sh -m '{"data": {"type":"active", "city":"Warsaw", "country_code":"PL"}}'
```
or using [jo](https://github.com/jpmens/jo) package (simple utility to create JSON objects)
```
jo -p data=$(jo type=active city=Warsaw country_code=PL) | xargs -0 -I {} send-pubsub.sh -m {}
```
