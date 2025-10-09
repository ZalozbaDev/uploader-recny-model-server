import multer from 'multer'
import * as fs from 'fs'
import { SERVER_MODE } from '../types/common.ts'

// setup multer for file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Get token from query parameters since body is not parsed yet
    let token = req.query.token as string
    let path = `./uploads/${token}`

    if (!fs.existsSync(path)) {
      fs.mkdirSync(path, { recursive: true })
    }

    if (process.env.SERVER_MODE !== SERVER_MODE.TRANSCRIPT) {
      path = `./uploads/${token}/${file.fieldname}`
      if (!fs.existsSync(path)) {
        fs.mkdirSync(path, { recursive: true })
      }
    }

    cb(null, path)
  },
  filename: function (req, file, cb) {
    cb(null, `/${file.originalname}`)
  }
})

export const upload = multer({ storage })
