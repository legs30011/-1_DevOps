const http = require('http');
const fs = require('fs');
const path = require('path');

const LINES = [
  'To be, or not to be—that is the question.',
  'All the world’s a stage, and all the men and women merely players.',
  'The course of true love never did run smooth.'
];

let lineIndex = 0;

const server = http.createServer((req, res) => {
  let message = LINES[lineIndex];
  lineIndex += 1;
  if (lineIndex >= LINES.length) {
    lineIndex = 0;
  }
  fs.readFile(path.join(__dirname, 'index.html'), 'utf8', (err, html) => {
    if (err) return res.end('Error loading template');
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(html.replace('%%QUOTE%%', message));
  });
});

server.listen(8000, () => {
  console.log('HTTP server listening on port 80');
});
