"use client"

import Link from "next/link"
import { useEffect } from "react"
import { useRouter } from 'next/navigation'
import { Activity } from 'lucide-react'
import { Button } from "@/components/ui/button"

export default function SplashPage() {
  const router = useRouter()

  useEffect(() => {
    const timer = setTimeout(() => {
      router.push("/register")
    }, 2500)

    return () => clearTimeout(timer)
  }, [router])

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary via-secondary to-accent flex flex-col items-center justify-center p-4 sm:p-6 md:p-8 relative overflow-hidden">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-10 w-32 h-32 rounded-full bg-white/10 blur-2xl animate-pulse" />
        <div className="absolute bottom-20 right-10 w-40 h-40 rounded-full bg-white/10 blur-3xl animate-pulse delay-500" />
        <div className="absolute top-1/2 left-1/4 w-24 h-24 rounded-full bg-accent/20 blur-2xl animate-pulse delay-1000" />
        <div className="absolute top-20 right-20 w-64 h-64 rounded-full bg-white/10 blur-3xl animate-pulse" />
        <div className="absolute bottom-20 left-20 w-48 h-48 rounded-full bg-white/10 blur-2xl animate-pulse delay-300" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-full bg-white/5 blur-3xl animate-pulse delay-500" />
      </div>

      <div className="text-center space-y-6 sm:space-y-8 animate-fade-in relative z-10 max-w-2xl mx-auto flex flex-col items-center">
        <div className="flex justify-center">
          <div className="relative">
            <div className="w-28 h-28 sm:w-32 sm:h-32 md:w-36 md:h-36 rounded-3xl bg-white/20 backdrop-blur-md flex items-center justify-center shadow-2xl border-2 border-white/30 animate-bounce border-4 border-white/30">
              <Activity className="w-16 h-16 sm:w-20 sm:h-20 md:w-24 md:h-24 text-white" strokeWidth={2.5} />
            </div>
          </div>
        </div>

        <div className="space-y-3 sm:space-y-4 px-4">
          <h1 className="text-5xl sm:text-6xl md:text-7xl font-black text-white tracking-tight drop-shadow-lg animate-in slide-in-from-bottom duration-700">
            FitPulse
          </h1>
          <p className="text-xl sm:text-2xl text-white font-bold max-w-md mx-auto leading-relaxed drop-shadow-md animate-in slide-in-from-bottom duration-700 delay-150">
            Transforma tu cuerpo.
          </p>
          <p className="text-base sm:text-lg text-white/90 font-semibold max-w-lg mx-auto">
            Observa tu progreso y visualízate mejor cada día
          </p>
        </div>

        <div className="flex gap-2 mt-8">
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse" />
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse delay-150" />
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse delay-300" />
        </div>
      </div>

      <style jsx>{`
        @keyframes loading-bar {
          0% { width: 0%; }
          100% { width: 100%; }
        }
        .animate-loading-bar {
          animation: loading-bar 3s ease-in-out forwards;
        }
        .delay-500 {
          animation-delay: 500ms;
        }
        .delay-1000 {
          animation-delay: 1000ms;
        }
        .animate-in {
          animation-duration: 1s;
          animation-fill-mode: both;
        }
        @keyframes slide-in-from-bottom {
          0% {
            transform: translateY(100%);
            opacity: 0;
          }
          100% {
            transform: translateY(0);
            opacity: 1;
          }
        }
        .slide-in-from-bottom {
          animation-name: slide-in-from-bottom;
        }
        @keyframes zoom-in {
          0% {
            transform: scale(0.5);
            opacity: 0;
          }
          100% {
            transform: scale(1);
            opacity: 1;
          }
        }
        .zoom-in {
          animation-name: zoom-in;
        }
      `}</style>
    </div>
  )
}
