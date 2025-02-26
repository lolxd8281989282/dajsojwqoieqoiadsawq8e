import type { NextApiRequest, NextApiResponse } from "next"
import { promises as fs } from "fs"
import path from "path"

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  // Immediately set headers to prevent any middleware from changing them
  res.setHeader("Content-Type", "text/plain; charset=utf-8")
  res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate")
  res.setHeader("Pragma", "no-cache")
  res.setHeader("Expires", "0")

  if (req.method !== "GET") {
    return res.status(405).send("Method not allowed")
  }

  try {
    const { file } = req.query
    if (!file || Array.isArray(file)) {
      return res.status(400).send("Invalid file parameter")
    }

    // Clean the filename to prevent directory traversal
    const cleanFile = path.basename(file.toString())
    if (!cleanFile.endsWith(".lua")) {
      return res.status(400).send("Only .lua files are allowed")
    }

    const filePath = path.join(process.cwd(), "public", "lua", cleanFile)
    const content = await fs.readFile(filePath, "utf8")

    // Send raw content without any processing
    return res.send(content)
  } catch (error) {
    console.error("Error serving Lua file:", error)
    return res.status(404).send("File not found")
  }
}

export const config = {
  api: {
    bodyParser: false,
    externalResolver: false,
  },
}
