FROM node:16.14.0-alpine3.15
RUN apk add --no-cache bash ca-certificates file iptables libc6-compat libgcc libstdc++ wget && \
    update-ca-certificates && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
RUN apk add --update tzdata
ENV TZ=Asia/Ho_Chi_Minh
# Creating Relevant directories
WORKDIR /smart-contracts

# Install relevant
COPY src/package.json /smart-contracts/package.json
COPY src/package-lock.json /smart-contracts/package-lock.json
RUN npm install

# Add smart-contract relevant code to directory
COPY src/ /smart-contracts/

# convert shell scripts as executable
RUN chmod +x ./scripts/*.sh

# Default test command run
ENTRYPOINT ["npm", "run"]
CMD ["deploy"]