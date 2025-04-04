// importing modules
require("dotenv").config();
const express = require("express");
const http = require("http");
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const Room = require("./models/room");
const { SocketAddress } = require("net");
var io = require("socket.io")(server);

// middleware

app.use(express.json());

const MONGODB_URI = process.env.MONGODB_URI;

// socket.io connection
io.on("connection", (socket) => {
  console.log("New client connected");
  socket.on("createRoom", async ({ nickname }) => {
    console.log(nickname);
    try {
      let room = new Room();
      let player = {
        nickname: nickname,
        socketID: socket.id,
        playerType: "X",
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      console.log("Room created", room);
      const roomId = room._id.toString();

      socket.join(roomId);
      // io -> send data to everyone
      // socket -> sending data to yourself
      io.to(roomId).emit("createRoomSuccess", room);
    } catch (error) {
      console.log("Error creating room", error);
    }
  });

  socket.on("joinRoom", async ({ roomId, nickname }) => {
    console.log("Joining room", roomId);
    try {
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("errorOccured", "Please enter a valid room ID");
        return;
      }
      let room = await Room.findById(roomId);
      if (room.isJoin) {
        let player = {
          nickname: nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        room.isJoin = false;
        room = await room.save();
        console.log("Room joined", room);
        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room);
      } else {
        socket.emit(
          "errorOccured",
          "This game is in progress. Try again later."
        );
      }
    } catch (error) {
      console.log("Error joining room", error);
    }
  });

  socket.on("tap", async ({ roomId, index }) => {
    try {
      let room = await Room.findById(roomId);

      let choice = room.turn.playerType; // X or O
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }

      room = await room.save();

      io.to(roomId).emit("tapped", { index, choice, room });
    } catch (error) {
      console.log("Error tapping", error);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      if (socket.id != winnerSocketId) return;
      let room = await Room.findById(roomId);
      let player = room.players.find(
        (w_player) => w_player.socketID == winnerSocketId
      );
      player.points += 1;
      room = await room.save();

      if (player.points >= maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointIncrease", player);
      }
    } catch (error) {
      console.log("Error finding winner", error);
    }
  });
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
