"use client"

import { useEffect, useState } from "react"
import { useRouter } from 'next/navigation'
import { Activity, Sparkles, Heart, Trophy, Flame } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"

export default function WelcomePage() {
  const router = useRouter()
  const [userName, setUserName] = useState("Usuario")
  const [isNewUser, setIsNewUser] = useState(true)

  useEffect(() => {
    const profile = localStorage.getItem("userProfile")
    const newUser = localStorage.getItem("isNewUser")
    
    if (profile) {
      const data = JSON.parse(profile)
      setUserName(data.name || "Usuario")
    }
    
    setIsNewUser(newUser === "true")
    
    if (newUser === "true") {
      localStorage.removeItem("isNewUser")
    }

    const timer = setTimeout(() => {
      router.push("/onboarding")
    }, 4000)

    return () => clearTimeout(timer)
  }, [router])

  const tips = [
    { icon: Heart, text: "Bebe 8 vasos de agua al dia", color: "text-accent" },
    { icon: Trophy, text: "El descanso es tan importante como el ejercicio", color: "text-primary" },
    { icon: Flame, text: "La constancia es clave para el exito", color: "text-secondary" }
  ]

  const randomTip = tips[Math.floor(Math.random() * tips.length)]
  const TipIcon = randomTip.icon

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary via-secondary to-accent flex flex-col items-center justify-center p-4 sm:p-6 relative overflow-hidden">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-10 w-32 h-32 rounded-full bg-white/10 blur-2xl animate-pulse" />
        <div className="absolute bottom-20 right-10 w-40 h-40 rounded-full bg-white/10 blur-3xl animate-pulse delay-500" />
        <div className="absolute top-1/2 left-1/4 w-24 h-24 rounded-full bg-accent/20 blur-2xl animate-pulse delay-1000" />
      </div>

      <div className="text-center space-y-8 animate-fade-in relative z-10 max-w-2xl mx-auto">
        <div className="flex justify-center">
          <div className="w-28 h-28 sm:w-32 sm:h-32 rounded-3xl bg-white/20 backdrop-blur-md flex items-center justify-center shadow-2xl border-4 border-white/30 animate-bounce">
            <Activity className="w-16 h-16 sm:w-20 sm:h-20 text-white" strokeWidth={2.5} />
          </div>
        </div>

        <div className="space-y-4 px-4">
          <div className="flex items-center justify-center gap-2 animate-in slide-in-from-top duration-700">
            <Sparkles className="w-8 h-8 text-yellow-300 animate-pulse" />
            <h1 className="text-4xl sm:text-5xl md:text-6xl font-black text-white tracking-tight drop-shadow-lg">
              {isNewUser ? "Bienvenido" : "Bienvenido de nuevo"}
            </h1>
            <Sparkles className="w-8 h-8 text-yellow-300 animate-pulse" />
          </div>
          
          <p className="text-2xl sm:text-3xl text-white font-bold drop-shadow-md animate-in slide-in-from-bottom duration-700 delay-150">
            {userName}!
          </p>
          
          {isNewUser ? (
            <p className="text-lg sm:text-xl text-white/95 font-semibold max-w-lg mx-auto leading-relaxed animate-in slide-in-from-bottom duration-700 delay-300">
              Gracias por registrarte en FitPulse. Estas a punto de comenzar una transformacion increible.
            </p>
          ) : (
            <p className="text-lg sm:text-xl text-white/95 font-semibold max-w-lg mx-auto leading-relaxed animate-in slide-in-from-bottom duration-700 delay-300">
              Es genial verte de nuevo. Continuemos con tu increible progreso.
            </p>
          )}
        </div>

        <Card className="bg-white/15 backdrop-blur-md border-white/30 p-6 shadow-2xl mx-4 animate-in zoom-in duration-700 delay-500">
          <div className="flex items-start gap-4">
            <div className={`w-14 h-14 rounded-2xl bg-white/20 flex items-center justify-center flex-shrink-0 ${randomTip.color}`}>
              <TipIcon className="w-8 h-8" strokeWidth={2.5} />
            </div>
            <div className="text-left">
              <p className="text-sm text-white/80 font-bold mb-2">Consejo de fitness</p>
              <p className="text-lg font-black text-white leading-relaxed">
                {randomTip.text}
              </p>
            </div>
          </div>
        </Card>

        <div className="flex gap-2 mt-8">
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse" />
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse delay-150" />
          <div className="w-2 h-2 rounded-full bg-white/60 animate-pulse delay-300" />
        </div>
      </div>
    </div>
  )
}
