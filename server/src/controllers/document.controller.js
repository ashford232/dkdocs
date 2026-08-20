import Document from "../models/document.model.js";
import mongoose from "mongoose";
const create = async (req, res) => {
  try {
    const uid = req.userId;
    const document = await Document.create({
      uid: uid,
      title: "Untitled Document",
    });

    return res.status(201).json(document);
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: e.message });
  }
};

const getDocument = async (req, res) => {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({
        message: "Document ID is required",
      });
    }
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        message: "Invalid document ID",
      });
    }
    const document = await Document.findOne({
      _id: id,
      uid: req.userId,
    });

    if (!document) {
      return res.status(404).json({
        message: "Document not Found",
      });
    }

    return res.status(200).json(document);
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const getMyDocuments = async (req, res) => {
  try {
    const uid = req.userId;
    if (!uid) {
      return res.status(400).json({ message: "User ID is required" });
    }

    const documents = await Document.find({ uid }).sort({ updatedAt: -1 });

    return res.status(200).json(documents);
  } catch (e) {
    console.log(e);

    return res.status(500).json({ message: "Internal server error" });
  }
};

const updateDocument = async (req, res) => {
  try {
    console.log(req.headers["content-type"]);
    console.log(req.body);
    const { id, title, content } = req.body;
    const uid = req.userId;

    if (!id || !title) {
      return res.status(400).json({ message: "Invalid Document ID" });
    }
    const document = await Document.findByIdAndUpdate(
      id,
      {
        $set: {
          title,
          content,
        },
      },
      {
        returnDocument: "after",
        runValidators: true,
      },
    );
    if (!document) {
      return res.status(400).json({ message: "Document not found" });
    }

    return res.status(200).json(document);
  } catch (e) {
    console.log(e);

    return res.status(500).json({ message: "Internal Server error" });
  }
};
export { create, getDocument, getMyDocuments, updateDocument };
