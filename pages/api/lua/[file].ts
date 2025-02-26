import { NextApiRequest, NextApiResponse } from 'next'
import fs from 'fs'
import path from 'path'
import rateLimit from 'express-rate-limit'

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
})

const API_KEY = process.env.API_KEY // Set this in your environment variables

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  try {
    await limiter(req, res)
  } catch {
    res.status(429).json({ error: 'Too many requests' })
    return
  }

  // Basic auth check
  const authHeader = req.headers.authorization
  if (!authHeader || authHeader !== `Bearer ${API_KEY}`) {
    res.status(401).json({ error: 'Unauthorized' })
    return
  }

  const { file } = req.query
  
  if (typeof file !== 'string') {
    res.status(400).json({ error: 'Invalid file name' })
    return
  }

  const filePath = path.join(process.cwd(), 'public', 'lua', `${file}.lua`)

  try {
    const fileContent = fs.readFileSync(filePath, 'utf8')
    res.setHeader('Content-Type', 'text/plain')
    res.setHeader('Cache-Control', 'public, max-age=3600')
    console.log(`[${new Date().toISOString()}] Served ${file}.lua to ${req.headers['x-real-ip']}`)
    res.status(200).send(fileContent)
  } catch (error) {
    res.status(404).json({ error: 'File not found' })
  }
}
