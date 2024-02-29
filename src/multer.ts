import multer from 'multer'
import * as fs from 'fs'

// setup multer for file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    let token = req.body.token
    let path = `./uploads/${token}`
    if (!fs.existsSync(path)) {
      fs.mkdirSync(path)
      cb(null, path)
    }
  },
  filename: function (req, file, cb) {
    cb(null, `/${file.originalname}`)
  }
})

export const upload = multer({ storage })
