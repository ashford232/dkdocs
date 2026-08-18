import User from "../models/user.model.js";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

dotenv.config();

const ipAddr = process.env.IP_ADDR;
const ipAddr2 = process.env.IP_ADDRII;
// ==========================================
// EMAIL & PASSWORD AUTHENTICATION
// ==========================================

const signup = async (req, res) => {
  try {
    const { email, password, name, photoUrl, dob } = req.body;
    if (!email) {
      return res.status(400).json({
        message: "Email is required.",
      });
    }

    if (!password) {
      return res.status(400).json({
        message: "Password is required.",
      });
    }

    if (!name) {
      return res.status(400).json({
        message: "Name is required.",
      });
    }
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Hash the password before saving
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      email,
      password: hashedPassword,
      name,
      photoUrl,
      dob,
    });
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });
    // Remove password from the returned object
    user.password = undefined;

    return res.status(201).json({
      message: "User created successfully",
      user,
      token,
    });
  } catch (err) {
    console.error(err);
    if (err.name === "ValidationError") {
      return res.status(400).json({
        message: "Validation failed",
        errors: err.errors,
      });
    }
    return res.status(500).json({ message: "Internal server error" });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // If user created account via OAuth, they might not have a password
    if (!user.password) {
      return res
        .status(400)
        .json({ message: "Please log in using your social provider." });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });
    // Remove password from the returned object
    user.password = undefined;

    return res.status(200).json({
      message: "Login successful",
      user,
      token,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Internal server error" });
  }
};

// ==========================================
// UTILITY ENDPOINTS
// ==========================================

const me = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    return res.status(200).json({ user });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const emailExist = async (req, res) => {
  try {
    const email = req.query.email || req.body.email;

    if (!email) {
      return res.status(400).json({ message: "Email is required" });
    }

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(200).json({ exists: false });
    }

    // Check if the user has a password set
    const hasPassword = !!user.password;

    return res.status(200).json({
      exists: true,
      hasPassword: hasPassword, // false if they used social login (Google/GitHub)
      provider: hasPassword ? "email" : "social",
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const github = async (req, res) => {
  const { platform } = req.query;
  const params = new URLSearchParams({
    client_id: process.env.GITHUB_CLIENT_ID,
    redirect_uri: process.env.GITHUB_REDIRECT_URI,
    scope: "read:user user:email",
  });

  res.redirect(`https://github.com/login/oauth/authorize?${params}`);
};

const githubCallback = async (req, res) => {
  const { code } = req.query;

  try {
    const response = await fetch(
      "https://github.com/login/oauth/access_token",
      {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          client_id: process.env.GITHUB_CLIENT_ID,
          client_secret: process.env.GITHUB_CLIENT_SECRET,
          code,
        }),
      },
    );

    const data = await response.json();

    const profileResponse = await fetch("https://api.github.com/user", {
      headers: {
        Authorization: `Bearer ${data.access_token}`,
        Accept: "application/vnd.github+json",
      },
    });
    const profile = await profileResponse.json();

    const emailResponse = await fetch("https://api.github.com/user/emails", {
      headers: {
        Authorization: `Bearer ${data.access_token}`,
        Accept: "application/vnd.github+json",
      },
    });
    const emails = await emailResponse.json();
    const email = emails.find((item) => item.primary && item.verified)?.email;

    if (!email) {
      return res.redirect(
        `http://${ipAddr}:3000/auth/callback?success=false&error=${encodeURIComponent("No verified GitHub email found")}`,
      );
    }

    if (profile) {
      let user = await User.findOne({ email });
      let exists = true;
      // Create if user doesn't exist
      if (!user) {
        exists = false;
        user = await User.create({
          email,
          name: profile.name ?? profile.login,
          photoUrl: profile.avatar_url,
        });
      }
      const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
        expiresIn: "7d",
      });
      return res.redirect(
        `http://${ipAddr}:3000/auth/callback?success=true&exists=${exists}&email=${encodeURIComponent(email)}&token=${token}`,
      );
    }

    return res.redirect(
      `http://${ipAddr}:3000/auth/callback?success=false&error=${encodeURIComponent("Could not retrieve GitHub profile")}`,
    );
  } catch (err) {
    console.error(err);
    return res.redirect(
      `http://${ipAddr}:3000/auth/callback?success=false&error=${encodeURIComponent("GitHub authentication failed")}`,
    );
  }
};

const google = async (req, res) => {
  const params = new URLSearchParams({
    client_id: process.env.GOOGLE_CLIENT_ID,
    redirect_uri: process.env.GOOGLE_REDIRECT_URI,
    response_type: "code",
    scope: "openid email profile",
  });

  res.redirect(`https://accounts.google.com/o/oauth2/v2/auth?${params}`);
};

const googleCallback = async (req, res) => {
  const { code } = req.query;

  try {
    const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        client_id: process.env.GOOGLE_CLIENT_ID,
        client_secret: process.env.GOOGLE_CLIENT_SECRET,
        redirect_uri: process.env.GOOGLE_REDIRECT_URI,
        grant_type: "authorization_code",
        code,
      }),
    });

    const tokenData = await tokenResponse.json();

    const profileResponse = await fetch(
      "https://www.googleapis.com/oauth2/v2/userinfo",
      {
        headers: { Authorization: `Bearer ${tokenData.access_token}` },
      },
    );

    const profile = await profileResponse.json();
    const email = profile.email;

    if (!email) {
      return res.redirect(
        `http://${ipAddr2}:3000/auth/callback?success=false&error=${encodeURIComponent("No Google email found")}`,
      );
    }

    let user = await User.findOne({ email });
    let exists = true;

    if (!user) {
      exists = false;
      user = await User.create({
        email,
        name: profile.name,
        photoUrl: profile.picture,
      });
    }
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    return res.redirect(
      `http://${ipAddr2}:3000/auth/callback?success=true&exists=${exists}&email=${encodeURIComponent(email)}&token=${token}`,
    );
  } catch (err) {
    console.error(err);
    return res.redirect(
      `http://${ipAddr2}:3000/auth/callback?success=false&error=${encodeURIComponent("Google authentication failed")}`,
    );
  }
};

const googleMobile = async (req, res) => {
  const { idToken } = req.body;

  try {
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const profile = ticket.getPayload();
    const email = profile.email;

    if (!email) {
      return res.status(400).json({
        success: false,
        message: "No Google email found",
      });
    }

    let user = await User.findOne({ email });
    let exists = true;

    if (!user) {
      exists = false;
      user = await User.create({
        email,
        name: profile.name,
        photoUrl: profile.picture,
      });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    return res.status(200).json({
      user,
      token,
    });
  } catch (err) {
    console.error(err);

    return res.status(401).json({
      message: "Google authentication failed",
    });
  }
};
export {
  signup,
  login,
  me,
  emailExist,
  github,
  githubCallback,
  google,
  googleCallback,
  googleMobile,
};
