import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ message: "NO AUTH TOKEN, ACCESS DENIED." });
    }

    const verified = jwt.verify(token, process.env.JWT_SECRET);

    if (!verified) {
      return res
        .status(401)
        .json({ message: "INVALID AUTH TOKEN, AUTHORIZATION DENIED." });
    }

    console.log(verified);
    req.userId = verified.id;
    req.token = token;
    next();
  } catch (e) {
    console.log(e);
    return res
      .status(401)
      .json({ message: "TOKEN VERIFICATION FAILED, AUTHORIZATION DENIED." });
  }
};

export default auth;
