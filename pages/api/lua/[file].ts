import type { NextApiRequest, NextApiResponse } from "next"
import { promises as fs } from "fs"
import path from "path"

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
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

    // Send raw content
    return res.send(content)
  } catch {
    return res.status(404).send("File not found")
  }
}

export const config = {
  api: {
    bodyParser: false,
    externalResolver: false,
    responseLimit: false,
  },
}
