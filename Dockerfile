# FROM node:17.1-alpine as build-stage
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# FROM nginx:1.22.1-alpine as prod-stage
# COPY --from=build-stage /app/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]


# Use an official Node.js runtime as the base image
FROM node:17.1-alpine as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies in the container
RUN npm install

# Copy the rest of the application to the container
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight Node.js image to serve the built app
FROM node:17.1-alpine as build-stage

# Set the working directory in the container
WORKDIR /app

# Install serve to serve the React app
RUN npm install -g serve

# Copy the built app from the previous stage
COPY --from=0 /app/build ./build

# Specify the command to run when the container starts
CMD ["serve", "-s", "build", "-l", "3000"]

# Expose port 3000 for the app
EXPOSE 3000
