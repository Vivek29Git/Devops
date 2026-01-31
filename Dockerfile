# Stage 1: Build the application (in this case, just copy the files)
FROM node:18-alpine as builder
WORKDIR /app
COPY package.json .
# In a real app, you would run 'npm install' and 'npm run build'
# For this simple app, we just copy the source.
COPY src/ ./

# Stage 2: Create the final image with Tomcat
FROM tomcat:9-jdk11-corretto
# Remove the default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy the built/static content from the builder stage to the ROOT webapp directory
COPY --from=builder /app/ /usr/local/tomcat/webapps/ROOT/
EXPOSE 8080
