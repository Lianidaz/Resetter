var os = require('os');
var mqtt = require('mqtt');

var client = mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","os-mon");

var post = os.userInfo().username;

client.on('connect', function() {
  client.publish(os.hostname(), post);
  client.subscribe('#');
})
