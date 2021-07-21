const https = require('https')
const fs = require('fs');
const googleIt = require('google-it-safesearch')
var moment = require('moment');

var a = moment('2020-08-01');
var b = moment('2020-12-31');

const options = {
  'limit': 1,
  'only-urls': true,
  'disableConsole': true,
};
const files=Array();

async function sleep(millis) {
  return new Promise(resolve => setTimeout(resolve, millis));
}

for (var m = moment(a); m.diff(b, 'days') <= 0; m.add(1, 'days')) {
  d = m.format('YYYY-MM-DD');
  console.log(d);
  // https://www.divi.de/joomlatools-files/docman-files/divi-intensivregister-tagesreports-csv/DIVI-Intensivregister_2020-11-21_12-15.csv
  dl='DIVI-Intensivregister_'+d+'_12-15.csv';
  files.push(dl);
}

files.forEach(f => {
  url='https://www.divi.de/joomlatools-files/docman-files/divi-intensivregister-tagesreports-csv/'+f;
  sleep(1000+4000*Math.random());
  try {
  https.get(url, resp => resp.pipe(fs.createWriteStream('./data/'+f)));
  } catch(e) {
    console.log(url);  
    console.log(e);
    // any possible errors that might have occurred (like no Internet connection)
  }
})
