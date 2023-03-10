FROM node:19.6
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i; \
  else echo "Lockfile not found." && yarn; \
  fi

COPY ./src ./src
COPY tsconfig.json ./

# Compile the TypeScript code to JavaScript
RUN \
  if [ -f yarn.lock ]; then yarn build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then pnpm build; \
  # Allow install without lockfile, so example works even without Node.js installed locally
  else yarn build; \
  fi

USER node

CMD [ "node", "--watch dist/index.js" ]
