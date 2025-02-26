import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"

export function middleware(request: NextRequest) {
  // Check if the request is for a Lua file
  if (request.nextUrl.pathname.startsWith("/api/lua/")) {
    const response = NextResponse.next()

    // Force content type for Lua files
    response.headers.set("Content-Type", "text/plain; charset=utf-8")
    response.headers.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate")
    response.headers.set("Pragma", "no-cache")
    response.headers.set("Expires", "0")

    return response
  }

  return NextResponse.next()
}

export const config = {
  matcher: "/api/lua/:path*",
}
