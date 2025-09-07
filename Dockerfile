# Use official Playwright image (includes Chromium + deps)
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

USER root
WORKDIR /app

# Copy manifests and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci --production

# Install Xvfb (for headful mode since you used headless: false)
RUN apt-get update \
  && apt-get install -y xvfb x11-xserver-utils \
  && rm -rf /var/lib/apt/lists/*

# Copy app code
COPY . .

EXPOSE 3000

# Run app inside a virtual display
CMD ["xvfb-run", "-s", "-screen 0 1920x1080x24", "npm", "start"]
