import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"

export function middleware(request: NextRequest) {
  // Skip middleware completely for Lua file requests
  if (request.nextUrl.pathname.startsWith("/api/lua/")) {
    return NextResponse.next()
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    // Add matchers for other routes that need middleware
    // But exclude Lua files
    "/((?!api/lua/).*)",
  ],
}
