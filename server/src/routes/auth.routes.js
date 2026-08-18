import express, { json } from "express";
import {
  signup,
  login,
  me,
  emailExist,
  github,
  githubCallback,
  google,
  googleCallback,
  googleMobile,
} from "../controllers/auth.controller.js";
import authMiddleware from "../middlewares/auth.middleware.js";

const authRouter = express.Router();

authRouter.get("/test-deeplink", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
      <body>
        <script>
          window.location.href = "dkdocs://password";
        </script>

        <p>Opening DK Docs...</p>
      </body>
    </html>
  `);
});
// ==============================
// Email & Password Routes
// ==============================
authRouter.post("/signup", signup);
authRouter.post("/login", login);

// ==============================
// Utility Routes
// ==============================
authRouter.get("/me", authMiddleware, me);
authRouter.post("/emailExist", emailExist);

// ==============================
// GitHub OAuth Routes
// ==============================
authRouter.get("/github", github);
authRouter.get("/github/callback", githubCallback);

// ==============================
// Google OAuth Routes
// ==============================
authRouter.get("/google", google);
authRouter.get("/google/callback", googleCallback);
authRouter.post("/google/mobile", googleMobile);

export default authRouter;
