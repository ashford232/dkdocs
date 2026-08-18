import dotenv from "dotenv";
import mongoose from "mongoose";
import app from "./app.js";

dotenv.config();
const PORT = process.env.PORT || 3001;
const DB_URI = process.env.MONGODB_URI;


mongoose
  .connect(DB_URI)
  .then(() => {
    console.log("Database connected.");
    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running at: http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.log(`Database connection failed: ${err}`);
  });
