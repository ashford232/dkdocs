import express from "express";
import authRouter from "./src/routes/auth.routes.js";
import cors from "cors";
import cookieParser from "cookie-parser";

const app = express();

app.use(cors());
app.use(cookieParser());
app.use(express.json());
app.use("/api/v1/auth", authRouter);

app.get("/", (req, res) => {
  res.json({ message: "DK Docs API is running 🚀" });
});


export default app;
