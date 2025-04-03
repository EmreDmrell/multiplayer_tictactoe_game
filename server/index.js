// importing modules
require("dotenv").config();
const express = require("express");
const http = require("http");
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require("socket.io")(server);

// middleware

app.use(express.json());

const MONGODB_URI = process.env.MONGODB_URI;

// socket.io connection
io.on("connection", (socket) => {
  console.log("New client connected");
});

// connect to mongodb
mongoose
  .connect(MONGODB_URI)
  .then(() => {
    console.log("Connection to MongoDB is successful");
  })
  .catch((err) => {
    console.log("Error connecting to MongoDB", err);
  });

server.listen(port, "0.0.0.0", () => {
  console.log(`Server is running on port ${port}`);
});
