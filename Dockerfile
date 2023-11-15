# Use an official Node.js runtime as the base image
FROM --platform=linux/amd64 node:19

# Set the working directory in the container to /app
WORKDIR /usr/src/app

COPY . .

RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Install the project dependencies
RUN npm install

# Make port 8080 available to the world outside the container
EXPOSE 8080

# Run the script when the container launches
CMD [ "node", "js/scripts/run_bot.js" ]