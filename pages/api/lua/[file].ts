import type { NextApiRequest, NextApiResponse } from "next"
import { promises as fs } from "fs"
import path from "path"

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") {
    return res.status(405).json({ error: "Method not allowed" })
  }

  try {
    const { file } = req.query
    if (!file || Array.isArray(file)) {
      return res.status(400).json({ error: "Invalid file parameter" })
    }

    // Clean the filename to prevent directory traversal
    const cleanFile = path.basename(file.toString())
    if (!cleanFile.endsWith(".lua")) {
      return res.status(400).json({ error: "Only .lua files are allowed" })
    }

    const filePath = path.join(process.cwd(), "public", "lua", cleanFile)
    const content = await fs.readFile(filePath, "utf8")

    // Force plain text content type and no-cache headers
    res.setHeader("Content-Type", "text/plain; charset=utf-8")
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate")
    res.setHeader("Pragma", "no-cache")
    res.setHeader("Expires", "0")

    // Prevent any automatic middleware or framework interference
    res.setHeader("X-Content-Type-Options", "nosniff")
    res.setHeader("X-Robots-Tag", "noindex, nofollow")

    // Send raw content without any processing
    res.send(content)
  } catch (error) {
    console.error("Error serving Lua file:", error)
    res.status(404).json({ error: "File not found" })
  }
}

// Disable body parsing and response size limits
export const config = {
  api: {
    bodyParser: false,
    externalResolver: false,
    responseLimit: false,
  },
}
