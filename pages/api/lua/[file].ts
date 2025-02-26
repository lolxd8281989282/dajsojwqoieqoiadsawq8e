import type { NextApiRequest, NextApiResponse } from "next"
import { promises as fs } from "fs"
import path from "path"

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") {
    res.status(405).send("Method not allowed")
    return
  }

  try {
    const { file } = req.query

    if (!file || Array.isArray(file)) {
      res.status(400).send("Invalid file parameter")
      return
    }

    if (!file.endsWith(".lua")) {
      res.status(400).send("Only .lua files are allowed")
      return
    }

    const filePath = path.join(process.cwd(), "public", "lua", file)
    const content = await fs.readFile(filePath, "utf8")

    // Force plain text content type and disable caching
    res.setHeader("Content-Type", "text/plain; charset=utf-8")
    res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate")
    res.setHeader("Pragma", "no-cache")
    res.setHeader("Expires", "0")

    // Send raw content
    res.status(200).send(content)
  } catch (error) {
    console.error("Error serving Lua file:", error)
    res.status(404).send("File not found")
  }
}

export const config = {
  api: {
    bodyParser: false,
    externalResolver: false,
  },
}

