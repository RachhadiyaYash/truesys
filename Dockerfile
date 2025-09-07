FROM mcr.microsoft.com/playwright:v1.48.0-jammy

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy the rest of your app
COPY . .

# Install Xvfb
RUN apt-get update && apt-get install -y xvfb && rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 3000

# Start Xvfb in background, set DISPLAY, then start the server
CMD Xvfb :99 -screen 0 1280x1024x24 & \
    export DISPLAY=:99 && \
    npm start