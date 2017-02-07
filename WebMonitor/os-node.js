var os = require('os');
var mqtt = require('mqtt');

var client = mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","os-mon");

var topic = os.hostname();
var post = os.userInfo().username + "|" + os.platform();

var d = Date.now();

client.on('connect', function(){
  client.subscribe('#');
  client.publish(topic, post);
  // console.log("connected! " + post);
  // while (true) {
    d = Date.now();
    if ((d % 60000) == 0) {
      client.publish(os.hostname(), post);
      // console.log(post);
    }
  // }
});
