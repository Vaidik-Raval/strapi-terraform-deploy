FROM node:18

# Set working directory
WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./

# Install build tools required for native modules
RUN apt-get update && \
    apt-get install -y python3 g++ make && \
    npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

# Build admin panel



RUN npm run build

# Expose port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "develop"]