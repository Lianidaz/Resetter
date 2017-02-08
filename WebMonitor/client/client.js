var os = require('os');
var mqtt = require('mqtt');

var client = mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","client");

var topic = os.hostname();
var post = os.userInfo().username + "|" + os.platform();

client.on('connect', function(){
  client.publish(topic, post);
  process.exit();
)};
