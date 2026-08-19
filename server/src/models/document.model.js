import mongoose from "mongoose";

const documentShema = new mongoose.Schema(
  {
    uid: {
      required: true,
      type: String,
    },

    title: {
      required: true,
      type: String,
      trim: true,
    },

    content: {
      type: Array,
      default: [],
    },
  },
  { timestamps: true },
);

const Document = mongoose.model('Document', documentShema)


export default Document;