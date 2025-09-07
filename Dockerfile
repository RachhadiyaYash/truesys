# Use official Playwright image (includes Chromium + deps)
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

WORKDIR /app

# Copy manifests and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci --production

# Install Xvfb just in case
RUN apt-get update \
  && apt-get install -y xvfb x11-xserver-utils \
  && rm -rf /var/lib/apt/lists/*

# Copy app code
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
