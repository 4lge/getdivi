const https = require('https')
const fs = require('fs');
const googleIt = require('google-it-safesearch')
var moment = require('moment');

var a = moment('2020-09-01');
var b = moment('2020-11-30');

const options = {
  'limit': 1,
  'only-urls': true,
  'disableConsole': true,
};
const urls=Array();

async function sleep(millis) {
  return new Promise(resolve => setTimeout(resolve, millis));
}

for (var m = moment(a); m.diff(b, 'days') <= 0; m.add(1, 'days')) {
  d = m.format('YYYY-MM-DD');
  console.log(d);
  dl='divi-intensivregister-'+d+'-12-15.csv';
  urls.push(dl);
}

urls.forEach(element => {
  sleep(1000+4000*Math.random());
  googleIt({ options, 'query': element }).then(results => {
    // access to results object here
    url = results[0].link;
    console.log(url);
    sleep(1000);
    https.get(url, resp => resp.pipe(fs.createWriteStream('./data/'+element)));
    //  print(results[0]);
  }).catch(e => {
    console.log(element);  
    console.log(e);
    // any possible errors that might have occurred (like no Internet connection)
  })
});

