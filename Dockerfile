# Use official Playwright image (includes Chromium + deps)
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

WORKDIR /app

# Copy manifests and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci --production

# Copy app code
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
