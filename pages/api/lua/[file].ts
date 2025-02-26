import type { NextApiRequest, NextApiResponse } from "next"
import rateLimit from "express-rate-limit"
import { createRouter } from "next-connect"
import { promises as fs } from "fs"
import path from "path"

// Configure rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
})

const router = createRouter<NextApiRequest, NextApiResponse>()

// Apply rate limiting
router.use(async (req, res, next) => {
  await new Promise((resolve) => {
    limiter(req, res, () => {
      resolve(null)
    })
  })
  await next()
})

// Handle GET requests
router.get(async (req, res) => {
  try {
    const { file } = req.query

    // Validate file parameter
    if (!file || Array.isArray(file)) {
      return res.status(400).json({ error: "Invalid file parameter" })
    }

    // Ensure the file has a .lua extension
    if (!file.endsWith(".lua")) {
      return res.status(400).json({ error: "Only .lua files are allowed" })
    }

    // Get the file path
    const filePath = path.join(process.cwd(), "public", "lua", file)

    // Read the file
    const content = await fs.readFile(filePath, "utf8")

    // Set proper content type
    res.setHeader("Content-Type", "text/plain")
    res.send(content)
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      res.status(404).json({ error: "File not found" })
    } else {
      res.status(500).json({ error: "Internal server error" })
    }
  }
})

// Export the handler
export default router.handler()

// Disable body parsing, as we don't need it for serving Lua files
export const config = {
  api: {
    bodyParser: false,
  },
}
