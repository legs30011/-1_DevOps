FROM node:18-slim

WORKDIR /code

RUN npm install -g nodemon

COPY package.json /code/package.json
RUN npm install && npm ls

COPY . /code

CMD ["npm", "start"]
