import type { NextApiRequest, NextApiResponse } from "next"
import { createRouter } from "next-connect"
import { promises as fs } from "fs"
import path from "path"

const router = createRouter<NextApiRequest, NextApiResponse>()

// Handle GET requests
router.get(async (req, res) => {
  try {
    const { file } = req.query

    // Validate file parameter
    if (!file || Array.isArray(file)) {
      return res.status(400).send("Invalid file parameter")
    }

    // Ensure the file has a .lua extension
    if (!file.endsWith(".lua")) {
      return res.status(400).send("Only .lua files are allowed")
    }

    // Get the file path
    const filePath = path.join(process.cwd(), "public", "lua", file)

    // Read the file
    const content = await fs.readFile(filePath, "utf8")

    // Set proper content type and cache control
    res.setHeader("Content-Type", "text/plain; charset=utf-8")
    res.setHeader("Cache-Control", "no-store, max-age=0")

    // Send the raw Lua content
    res.send(content)
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      res.status(404).send("File not found")
    } else {
      console.error("Error serving Lua file:", error)
      res.status(500).send("Internal server error")
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
