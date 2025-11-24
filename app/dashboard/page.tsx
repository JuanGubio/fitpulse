"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { Dumbbell, Flame, Play, Users, UtensilsCrossed, TrendingUp, Smile, Sparkles, Activity, User } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"

export default function DashboardPage() {
  const [userName, setUserName] = useState("Usuario")
  const [streakDays, setStreakDays] = useState(6)

  useEffect(() => {
    const profile = localStorage.getItem("userProfile")
    if (profile) {
      const data = JSON.parse(profile)
      setUserName(data.name || "Usuario")
    }
  }, [])

  return (
    <div className="min-h-screen bg-background pb-20 sm:pb-24">
      <div className="bg-gradient-to-r from-primary via-secondary to-accent p-4 sm:p-6 text-white relative overflow-hidden">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute top-0 right-0 w-32 h-32 rounded-full bg-white/10 blur-2xl animate-pulse" />
          <div className="absolute bottom-0 left-0 w-24 h-24 rounded-full bg-white/10 blur-xl animate-pulse delay-300" />
          <div className="absolute top-1/2 left-1/4 w-20 h-20 rounded-full bg-white/5 blur-xl animate-bounce" />
        </div>

        <div className="max-w-6xl mx-auto space-y-3 sm:space-y-4 relative z-10">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <Sparkles className="w-5 h-5 sm:w-6 sm:h-6 text-yellow-300" />
              <h1 className="text-2xl sm:text-3xl md:text-4xl font-black">Hola, {userName}</h1>
            </div>
            <p className="text-white/95 text-base sm:text-lg mt-1 font-semibold">Continua con tu racha increible</p>
          </div>

          <Card className="bg-white/15 backdrop-blur-md border-white/30 p-4 sm:p-5 shadow-xl hover:shadow-2xl transition-all hover:scale-[1.02] duration-300">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3 sm:gap-4">
                <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-accent flex items-center justify-center shadow-lg animate-pulse">
                  <Flame className="w-6 h-6 sm:w-8 sm:h-8 text-white" />
                </div>
                <div>
                  <p className="text-2xl sm:text-3xl font-black text-white">{streakDays} dias</p>
                  <p className="text-white/90 text-xs sm:text-sm font-bold">Racha actual</p>
                </div>
              </div>
              <div className="w-12 h-12 rounded-full bg-accent/20 flex items-center justify-center">
                <Flame className="w-8 h-8 text-yellow-300 animate-bounce" />
              </div>
            </div>
          </Card>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-6xl mx-auto p-4 sm:p-6 space-y-4 sm:space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 sm:gap-4">
          {/* Workout Card */}
          <Link href="/workout">
            <Card className="p-5 sm:p-6 hover:shadow-2xl transition-all duration-300 cursor-pointer border-2 hover:border-primary hover:scale-[1.02] group bg-gradient-to-br from-card to-primary/5 animate-in fade-in slide-in-from-left">
              <div className="space-y-3 sm:space-y-4">
                <div className="flex items-start justify-between">
                  <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-primary/15 flex items-center justify-center group-hover:bg-primary/25 transition-colors shadow-md group-hover:scale-110 duration-300">
                    <Dumbbell className="w-7 h-7 sm:w-8 sm:h-8 text-primary" />
                  </div>
                  <Play className="w-6 h-6 sm:w-7 sm:h-7 text-muted-foreground group-hover:text-primary transition-colors group-hover:scale-110 duration-300" />
                </div>
                <div>
                  <h3 className="text-xl sm:text-2xl font-black text-foreground">Entrenamiento de hoy</h3>
                  <p className="text-muted-foreground mt-2 font-semibold text-sm sm:text-base">
                    45 min — Full Body Strength
                  </p>
                </div>
                <Progress value={0} className="h-2.5" />
                <Button className="w-full bg-accent hover:bg-accent/90 font-black text-sm sm:text-base rounded-2xl py-5 sm:py-6 shadow-lg text-white">
                  Iniciar entrenamiento
                </Button>
              </div>
            </Card>
          </Link>

          {/* Facial Routine Card */}
          <Link href="/facial">
            <Card className="p-5 sm:p-6 hover:shadow-2xl transition-all duration-300 cursor-pointer border-2 hover:border-secondary hover:scale-[1.02] group bg-gradient-to-br from-card to-secondary/5 animate-in fade-in slide-in-from-right">
              <div className="space-y-3 sm:space-y-4">
                <div className="flex items-start justify-between">
                  <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-secondary/15 flex items-center justify-center group-hover:bg-secondary/25 transition-colors shadow-md group-hover:scale-110 duration-300">
                    <Smile className="w-7 h-7 sm:w-8 sm:h-8 text-secondary" />
                  </div>
                  <Play className="w-6 h-6 sm:w-7 sm:h-7 text-muted-foreground group-hover:text-secondary transition-colors group-hover:scale-110 duration-300" />
                </div>
                <div>
                  <h3 className="text-xl sm:text-2xl font-black text-foreground">Rutina facial y tonificacion</h3>
                  <p className="text-muted-foreground mt-2 font-semibold text-sm sm:text-base">
                    10 min — Marcado facial
                  </p>
                </div>
                <Progress value={0} className="h-2.5" />
                <Button className="w-full bg-secondary hover:bg-secondary/90 font-black text-sm sm:text-base rounded-2xl py-5 sm:py-6 shadow-lg">
                  Empezar rutina facial
                </Button>
              </div>
            </Card>
          </Link>
        </div>

        {/* Secondary Actions */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3 sm:gap-4">
          {/* Body Comparator */}
          <Link href="/comparator">
            <Card className="p-5 sm:p-6 hover:shadow-xl transition-all duration-300 cursor-pointer border-2 hover:border-primary h-full hover:scale-[1.02] bg-gradient-to-br from-card to-primary/5 animate-in fade-in slide-in-from-bottom">
              <div className="space-y-3">
                <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-primary/15 flex items-center justify-center shadow-md hover:scale-110 transition-transform duration-300">
                  <Users className="w-6 h-6 sm:w-7 sm:h-7 text-primary" />
                </div>
                <div>
                  <h3 className="text-lg sm:text-xl font-black text-foreground">Comparador corporal</h3>
                  <p className="text-xs sm:text-sm text-muted-foreground mt-2 font-semibold">
                    Visualiza como te verias con tu meta
                  </p>
                </div>
                <Button
                  variant="outline"
                  className="w-full font-bold text-sm rounded-xl bg-transparent border-2 hover:bg-primary/10"
                >
                  Probar comparador
                </Button>
              </div>
            </Card>
          </Link>

          {/* Meal Plan */}
          <Link href="/meals">
            <Card className="p-5 sm:p-6 hover:shadow-xl transition-all duration-300 cursor-pointer border-2 hover:border-accent h-full hover:scale-[1.02] bg-gradient-to-br from-card to-accent/5 animate-in fade-in slide-in-from-bottom delay-150">
              <div className="space-y-3">
                <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-accent/15 flex items-center justify-center shadow-md hover:scale-110 transition-transform duration-300">
                  <UtensilsCrossed className="w-7 h-7 sm:w-8 sm:h-8 text-accent" />
                </div>
                <div>
                  <h3 className="text-lg sm:text-xl font-black text-foreground">Plan de comidas</h3>
                  <p className="text-xs sm:text-sm text-muted-foreground mt-2 sm:mt-3 font-semibold">
                    Calorias del dia: 2,400
                  </p>
                </div>
                <Button
                  variant="outline"
                  className="w-full font-bold text-sm rounded-xl bg-transparent border-2 hover:bg-accent/10"
                >
                  Ver comidas
                </Button>
              </div>
            </Card>
          </Link>

          {/* Progress */}
          <Link href="/progress">
            <Card className="p-5 sm:p-6 hover:shadow-xl transition-all duration-300 cursor-pointer border-2 hover:border-primary h-full hover:scale-[1.02] bg-gradient-to-br from-card to-secondary/5 animate-in fade-in slide-in-from-bottom delay-300">
              <div className="space-y-3">
                <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-secondary/15 flex items-center justify-center shadow-md hover:scale-110 transition-transform duration-300">
                  <TrendingUp className="w-6 h-6 sm:w-7 sm:h-7 text-secondary" />
                </div>
                <div>
                  <h3 className="text-lg sm:text-xl font-black text-foreground">Progreso</h3>
                  <p className="text-xs sm:text-sm text-muted-foreground mt-2 sm:mt-3 font-bold">+1.2 kg esta semana</p>
                </div>
                <Button
                  variant="outline"
                  className="w-full font-bold text-sm rounded-xl bg-transparent border-2 hover:bg-secondary/10"
                >
                  Ver evolucion
                </Button>
              </div>
            </Card>
          </Link>
        </div>

        <Card className="p-5 sm:p-6 bg-gradient-to-r from-primary/10 via-secondary/10 to-accent/10 border-2 border-primary/20 shadow-lg animate-in fade-in zoom-in duration-700">
          <div className="flex items-start gap-3 sm:gap-4">
            <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-primary/20 flex items-center justify-center flex-shrink-0">
              <Activity className="w-8 h-8 sm:w-10 sm:h-10 text-primary" strokeWidth={2.5} />
            </div>
            <div>
              <p className="text-base sm:text-xl font-black text-foreground leading-relaxed">
                "Cada gota de sudor cuenta. Sigue construyendo tu mejor version."
              </p>
              <p className="text-xs sm:text-sm text-muted-foreground mt-2 sm:mt-3 font-bold">Consejo del dia</p>
            </div>
          </div>
        </Card>
      </div>

      <div className="fixed bottom-0 left-0 right-0 bg-card/95 backdrop-blur-xl border-t-2 border-border shadow-2xl safe-area-bottom">
        <div className="max-w-6xl mx-auto grid grid-cols-5 p-2 sm:p-3">
          <Link href="/dashboard" className="flex flex-col items-center gap-1 p-2 rounded-2xl bg-primary/10 text-primary transition-all">
            <div className="w-10 h-10 rounded-xl bg-primary/15 flex items-center justify-center">
              <Dumbbell className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-black">Inicio</span>
          </Link>
          <Link
            href="/workout"
            className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all"
          >
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <Play className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Entrenar</span>
          </Link>
          <Link
            href="/meals"
            className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all"
          >
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <UtensilsCrossed className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Comidas</span>
          </Link>
          <Link
            href="/progress"
            className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all"
          >
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Progreso</span>
          </Link>
          <Link
            href="/profile"
            className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all"
          >
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <User className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Perfil</span>
          </Link>
        </div>
      </div>
    </div>
  )
}
