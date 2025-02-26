import type { NextApiRequest, NextApiResponse } from "next"
import { promises as fs } from "fs"
import path from "path"

// Disable default body parsing
export const config = {
  api: {
    bodyParser: false,
    externalResolver: false,
  },
}

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  // Force text/plain content type immediately
  res.setHeader("Content-Type", "text/plain; charset=utf-8")

  // Only allow GET requests
  if (req.method !== "GET") {
    res.status(405).send("Method not allowed")
    return
  }

  try {
    const { file } = req.query

    // Basic validation
    if (!file || Array.isArray(file)) {
      res.status(400).send("Invalid file parameter")
      return
    }

    // Security: Only allow .lua files from the lua directory
    const cleanFile = path.basename(file.toString())
    if (!cleanFile.endsWith(".lua")) {
      res.status(400).send("Only .lua files are allowed")
      return
    }

    // Get the absolute path to the lua file
    const filePath = path.join(process.cwd(), "public", "lua", cleanFile)

    try {
      // Read the file content
      const content = await fs.readFile(filePath, "utf8")

      // Set additional headers to prevent caching
      res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate")
      res.setHeader("Pragma", "no-cache")
      res.setHeader("Expires", "0")

      // Send the raw content
      res.send(content)
    } catch (error) {
      res.status(404).send("File not found")
    }
  } catch (error) {
    res.status(500).send("Internal server error")
  }
}
