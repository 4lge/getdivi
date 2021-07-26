const PDFMerger = require('pdf-merger-js');
const fs = require('fs');

var merger = new PDFMerger();


(async () => {
  fs.readdir("pdf", (err, files) => {
    for (const file of files) {
      console.log(file);
      merger.add('pdf/'+file);
    }
    merger.save('merged.pdf'); //save under given name and reset the internal document
  });
})();
