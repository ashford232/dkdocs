import express from "express";
import authRouter from "./src/routes/auth.routes.js";
import cors from "cors";
import cookieParser from "cookie-parser";
import documentRouter from "./src/routes/document.route.js";
import http from "http";
import { Server } from "socket.io";

const app = express();

app.use(cors());
app.use(cookieParser());
app.use(express.json());

//

//
app.use("/api/v1/auth", authRouter);
app.use("/api/v1/documents", documentRouter);

//
app.get("/", (req, res) => {
  res.json({ message: "DK Docs API is running 🚀" });
});

var server = http.createServer(app);
var io = new Server(server);

io.on("connection", (socket) => {

  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log(documentId + " Joined\n");
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });

  socket.on("typing", (data) => {
    console.log("Typiny " + data);
    socket.broadcast.to(data.room).emit("changes", data);
  });
});

export default server;
