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
CMD ["serve", "-s", "build", "-l", "80"]

# Expose port 3000 for the app
EXPOSE 80



# name: Deploy React to AWS
# on:
#   push:
#     branches:
#       - main

# jobs:
#   deploy:
#     runs-on: ubuntu-latest
#     steps:
#       - name: Checkout source code
#         uses: actions/checkout@v2

#       - name: Generate deployment package
#         run: zip -r deploy.zip . -x '*.git*'

#       - name: Get current date
#         id: date
#         run: echo "::set-output name=date::$(date +'%Y%m%dT%H%M%S')"

#       - name: Deploy to EB
#         uses: einaregilsson/beanstalk-deploy@v21
#         with:
#           aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
#           aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
#           application_name: docker-react
#           environment_name: Dockerreact-env-1
#           version_label: v${{ steps.date.outputs.date }}
#           existing_bucket_name: elasticbeanstalk-us-east-1-842413253702
#           region: us-east-1
#           deployment_package: deploy.zip