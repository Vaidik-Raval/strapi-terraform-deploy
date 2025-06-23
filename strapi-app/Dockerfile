FROM node:18

# Set working directory
WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json tsconfig.json ./

# Install build tools required for native modules
RUN npm install 

# Copy the rest of the application
COPY . .

# Build admin panel



RUN npm run build

# Expose port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run","develop"]