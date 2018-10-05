FROM node:alpine
WORKDIR /src
COPY package.json /src
RUN yarn install
EXPOSE 3000
CMD [ "yarn", "start" ]
# CMD ["tail", "-f", "/dev/null"]
