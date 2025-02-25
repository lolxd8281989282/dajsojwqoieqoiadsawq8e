import { Button } from "@/components/ui/button"
import { CheckIcon } from "@/components/ui/icons"
import Link from "next/link"

export default function Home() {
  return (
    <div className="min-h-screen bg-black text-white p-4 sm:p-6 flex flex-col">
      <header className="flex flex-col sm:flex-row justify-between items-center mb-10 sm:mb-20">
        <h1 className="text-xl font-bold mb-4 sm:mb-0">Dracula</h1>
        <div className="flex space-x-2">
          <Button
            variant="outline"
            className="text-white border-white hover:bg-white hover:text-black text-sm sm:text-base"
            asChild
          >
            <Link href="https://dracula.sellhub.cx" target="_blank" rel="noopener noreferrer">
              Purchase
            </Link>
          </Button>
          <Button
            variant="outline"
            className="text-white border-white hover:bg-white hover:text-black text-sm sm:text-base"
            asChild
          >
            <Link href="https://discord.com/invite/kYsVs8rqXJ" target="_blank" rel="noopener noreferrer">
              Discord
            </Link>
          </Button>
        </div>
      </header>

      <main className="flex-grow flex flex-col items-center justify-center max-w-xl mx-auto text-center px-4">
        <h2 className="text-4xl sm:text-5xl md:text-7xl font-bold mb-2">Dracula</h2>
        <p className="text-base sm:text-lg mb-6">The best Roblox external on the market.</p>
        <Button
          variant="outline"
          className="text-white border-white hover:bg-white hover:text-black px-6 sm:px-8 py-2 rounded-full text-base sm:text-lg mb-10 sm:mb-16 w-full sm:w-auto"
          asChild
        >
          <Link href="https://dracula.sellhub.cx" target="_blank" rel="noopener noreferrer">
            Purchase
          </Link>
        </Button>

        <div className="w-full text-left bg-zinc-900 p-4 rounded-lg mb-6">
          <h3 className="text-lg font-semibold mb-2 text-white">Changelog</h3>
          <ul className="space-y-1 text-xs font-mono text-blue-300">
            <li>
              <span className="text-white">[+]</span> Added Visuals
            </li>
            <li>
              <span className="text-white">[+]</span> Added Aimbot
            </li>
            <li>
              <span className="text-white">[+]</span> Added Player List
            </li>
            <li>
              <span className="text-white">[+]</span> New GUI
            </li>
            <li>
              <span className="text-white">[+]</span> New pred system (division) (multiplication)
            </li>
            <li>
              <span className="text-white">[+]</span> Updated for latest roblox update (version:2d6639b3364b47cd)
            </li>
          </ul>
        </div>

        <div className="flex flex-col sm:flex-row justify-center space-y-2 sm:space-y-0 sm:space-x-4 w-full">
          <div className="flex items-center justify-center space-x-2 bg-zinc-950 px-4 py-2 rounded-lg">
            <CheckIcon className="w-4 h-4 text-white" />
            <span>Windows 10</span>
          </div>
          <div className="flex items-center justify-center space-x-2 bg-zinc-950 px-4 py-2 rounded-lg">
            <CheckIcon className="w-4 h-4 text-white" />
            <span>Windows 11</span>
          </div>
        </div>
      </main>
    </div>
  )
}

