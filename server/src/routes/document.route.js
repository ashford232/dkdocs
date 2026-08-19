import express from "express"
import auth from "../middlewares/auth.middleware.js"
import {create, getDocument, getMyDocuments, updateDocument} from "../controllers/document.controller.js"


const documentRouter = express.Router()



documentRouter.post("/create", auth, create)
documentRouter.get("/", auth, getDocument)
documentRouter.get("/me", auth, getMyDocuments)
documentRouter.put("/", auth, updateDocument)




export default documentRouter