"use client"

import { useState, useEffect } from "react"
import Link from "next/link"
import { Dumbbell, Play, User, UtensilsCrossed, TrendingUp, CalendarIcon, Activity, Flame, Check, Camera, X } from 'lucide-react'
import { Card } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"

export default function ProgressPage() {
  const [weightData] = useState([
    { week: "Sem 1", weight: 78 },
    { week: "Sem 2", weight: 77.5 },
    { week: "Sem 3", weight: 76.8 },
    { week: "Sem 4", weight: 75.2 },
  ])

  const [calendarData, setCalendarData] = useState<Record<string, { workout?: boolean, meal?: boolean, faceExercise?: boolean, photo?: string }>>({})
  const [selectedDay, setSelectedDay] = useState<string | null>(null)
  const [selectedDayData, setSelectedDayData] = useState<any>(null)
  const [showDayDetail, setShowDayDetail] = useState(false)

  useEffect(() => {
    const stored = localStorage.getItem('calendarData')
    if (stored) {
      setCalendarData(JSON.parse(stored))
    }
  }, [])

  const generateCalendar = () => {
    const today = new Date()
    const year = today.getFullYear()
    const month = today.getMonth()
    const daysInMonth = new Date(year, month + 1, 0).getDate()
    
    const calendar = []
    for (let day = 1; day <= daysInMonth; day++) {
      const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
      const data = calendarData[dateStr] || {}
      calendar.push({
        day,
        workout: data.workout || false,
        meal: data.meal || false,
        faceExercise: data.faceExercise || false,
      })
    }
    return calendar
  }

  const openDayDetail = (day: number) => {
    const today = new Date()
    const year = today.getFullYear()
    const month = today.getMonth()
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
    const data = calendarData[dateStr]
    
    if (data && (data.workout || data.meal || data.faceExercise)) {
      setSelectedDay(dateStr)
      setSelectedDayData(data)
      setShowDayDetail(true)
    }
  }

  const monthData = generateCalendar()

  // Calculate stats from calendar data
  const totalWorkouts = Object.values(calendarData).filter(d => d.workout).length
  const currentStreak = 3 // This could be calculated from consecutive days

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <div className="bg-gradient-to-r from-secondary via-primary to-accent p-4 sm:p-6 text-white">
        <div className="max-w-6xl mx-auto space-y-2 sm:space-y-4">
          <h1 className="text-2xl sm:text-3xl font-black">Tu progreso</h1>
          <p className="text-white/90 text-sm sm:text-base">Visualiza tu evolución</p>
        </div>
      </div>

      {/* Stats Summary */}
      <div className="max-w-6xl mx-auto p-3 sm:p-4 -mt-4 relative z-10">
        <div className="grid grid-cols-3 gap-2 sm:gap-3">
          <Card className="p-3 sm:p-4 text-center border-2 shadow-lg">
            <Activity className="w-6 h-6 sm:w-8 sm:h-8 mx-auto mb-2 text-primary" />
            <p className="text-xl sm:text-2xl font-black">{totalWorkouts}</p>
            <p className="text-[10px] sm:text-xs text-muted-foreground font-bold">Entrenamientos</p>
          </Card>
          <Card className="p-3 sm:p-4 text-center border-2 shadow-lg">
            <Flame className="w-6 h-6 sm:w-8 sm:h-8 mx-auto mb-2 text-accent" />
            <p className="text-xl sm:text-2xl font-black">{currentStreak}</p>
            <p className="text-[10px] sm:text-xs text-muted-foreground font-bold">Dias racha</p>
          </Card>
          <Card className="p-3 sm:p-4 text-center border-2 shadow-lg">
            <TrendingUp className="w-6 h-6 sm:w-8 sm:h-8 mx-auto mb-2 text-secondary" />
            <p className="text-xl sm:text-2xl font-black">-2.8</p>
            <p className="text-[10px] sm:text-xs text-muted-foreground font-bold">kg perdidos</p>
          </Card>
        </div>
      </div>

      {/* Weight Progress Chart */}
      <div className="max-w-6xl mx-auto p-3 sm:p-4 space-y-3 sm:space-y-4">
        <Card className="p-4 sm:p-6 border-2">
          <h2 className="text-lg sm:text-xl font-black mb-3 sm:mb-4">Evolución de peso</h2>
          <div className="space-y-2 sm:space-y-3">
            {weightData.map((data, index) => (
              <div key={index} className="flex items-center gap-3 sm:gap-4">
                <span className="text-xs sm:text-sm font-bold text-muted-foreground w-12 sm:w-16">{data.week}</span>
                <div className="flex-1 h-8 sm:h-10 bg-muted rounded-xl relative overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-primary to-secondary rounded-xl flex items-center justify-end pr-2 sm:pr-3"
                    style={{ width: `${(data.weight / 78) * 100}%` }}
                  >
                    <span className="text-white font-black text-xs sm:text-sm">{data.weight} kg</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Card>

        {/* Activity Calendar */}
        <Card className="p-4 sm:p-6 border-2">
          <div className="flex items-center justify-between mb-3 sm:mb-4">
            <h2 className="text-lg sm:text-xl font-black">Calendario de actividad</h2>
            <CalendarIcon className="w-5 h-5 sm:w-6 sm:h-6 text-primary" />
          </div>
          
          <div className="space-y-3 sm:space-y-4">
            {/* Legend */}
            <div className="flex gap-3 sm:gap-4 text-[10px] sm:text-xs flex-wrap">
              <div className="flex items-center gap-1.5 sm:gap-2">
                <div className="w-3 h-3 sm:w-4 sm:h-4 rounded bg-primary" />
                <span className="font-semibold">Entrenamiento</span>
              </div>
              <div className="flex items-center gap-1.5 sm:gap-2">
                <div className="w-3 h-3 sm:w-4 sm:h-4 rounded bg-accent" />
                <span className="font-semibold">Alimentación</span>
              </div>
              <div className="flex items-center gap-1.5 sm:gap-2">
                <div className="w-3 h-3 sm:w-4 sm:h-4 rounded bg-secondary" />
                <span className="font-semibold">Ejercicios faciales</span>
              </div>
              <div className="flex items-center gap-1.5 sm:gap-2">
                <div className="w-3 h-3 sm:w-4 sm:h-4 rounded bg-muted" />
                <span className="font-semibold">Sin actividad</span>
              </div>
            </div>

            {/* Calendar Grid */}
            <div className="grid grid-cols-7 gap-1.5 sm:gap-2">
              {monthData.map((data, index) => {
                const bothComplete = data.workout && data.meal
                const bgColor = bothComplete 
                  ? "bg-secondary" 
                  : data.workout 
                  ? "bg-primary" 
                  : data.faceExercise 
                  ? "bg-accent" 
                  : "bg-muted"
                
                return (
                  <div
                    key={index}
                    onClick={() => openDayDetail(data.day)}
                    className={`aspect-square rounded-lg sm:rounded-xl ${bgColor} flex flex-col items-center justify-center p-1 sm:p-2 relative hover:scale-105 transition-transform ${(data.workout || data.meal || data.faceExercise) ? 'cursor-pointer' : 'cursor-default'}`}
                  >
                    <span className={`text-[10px] sm:text-xs font-black ${(data.workout || data.meal || data.faceExercise) ? "text-white" : "text-muted-foreground"}`}>
                      {data.day}
                    </span>
                    {bothComplete && (
                      <Check className="w-2.5 h-2.5 sm:w-3 sm:h-3 text-white absolute bottom-0.5 sm:bottom-1" />
                    )}
                  </div>
                )
              })}
            </div>
          </div>
        </Card>

        {/* Achievements */}
        <Card className="p-4 sm:p-6 border-2 bg-gradient-to-br from-primary/5 to-secondary/5">
          <h2 className="text-lg sm:text-xl font-black mb-3 sm:mb-4">Logros recientes</h2>
          <div className="space-y-2 sm:space-y-3">
            <div className="flex items-center gap-2 sm:gap-3 p-2.5 sm:p-3 bg-card rounded-xl border-2">
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-accent/20 flex items-center justify-center flex-shrink-0">
                <Flame className="w-5 h-5 sm:w-6 sm:h-6 text-accent" />
              </div>
              <div>
                <p className="text-sm sm:text-base font-black">Racha de {currentStreak} días</p>
                <p className="text-xs sm:text-sm text-muted-foreground">Continúa así</p>
              </div>
            </div>
            <div className="flex items-center gap-2 sm:gap-3 p-2.5 sm:p-3 bg-card rounded-xl border-2">
              <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-primary/20 flex items-center justify-center flex-shrink-0">
                <Activity className="w-5 h-5 sm:w-6 sm:h-6 text-primary" />
              </div>
              <div>
                <p className="text-sm sm:text-base font-black">{totalWorkouts} entrenamientos completados</p>
                <p className="text-xs sm:text-sm text-muted-foreground">Vas por buen camino</p>
              </div>
            </div>
          </div>
        </Card>
      </div>

      <Dialog open={showDayDetail} onOpenChange={setShowDayDetail}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle className="text-2xl font-black">Detalles del día</DialogTitle>
          </DialogHeader>
          {selectedDayData && (
            <div className="space-y-4">
              <p className="text-sm text-muted-foreground font-semibold">
                {new Date(selectedDay + 'T00:00:00').toLocaleDateString('es-ES', { 
                  weekday: 'long', 
                  year: 'numeric', 
                  month: 'long', 
                  day: 'numeric' 
                })}
              </p>
              
              {/* Photo */}
              {selectedDayData.photo && (
                <div className="relative aspect-video rounded-xl overflow-hidden bg-muted">
                  <img src={selectedDayData.photo || "/placeholder.svg"} alt="Foto del día" className="w-full h-full object-cover" />
                </div>
              )}

              {/* Activities */}
              <div className="space-y-3">
                {selectedDayData.workout && (
                  <Card className="p-4 border-2 bg-primary/5">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 rounded-xl bg-primary/20 flex items-center justify-center">
                        <Dumbbell className="w-6 h-6 text-primary" />
                      </div>
                      <div>
                        <p className="font-black">Entrenamiento completado</p>
                        <p className="text-sm text-muted-foreground">Realizaste ejercicios este día</p>
                      </div>
                    </div>
                  </Card>
                )}

                {selectedDayData.meal && (
                  <Card className="p-4 border-2 bg-accent/5">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 rounded-xl bg-accent/20 flex items-center justify-center">
                        <UtensilsCrossed className="w-6 h-6 text-accent" />
                      </div>
                      <div>
                        <p className="font-black">Plan alimenticio seguido</p>
                        <p className="text-sm text-muted-foreground">Cumpliste tu plan de comidas</p>
                      </div>
                    </div>
                  </Card>
                )}

                {selectedDayData.faceExercise && (
                  <Card className="p-4 border-2 bg-secondary/5">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 rounded-xl bg-secondary/20 flex items-center justify-center">
                        <Activity className="w-6 h-6 text-secondary" />
                      </div>
                      <div>
                        <p className="font-black">Ejercicios faciales</p>
                        <p className="text-sm text-muted-foreground">Completaste tu rutina facial</p>
                      </div>
                    </div>
                  </Card>
                )}
              </div>

              <Button onClick={() => setShowDayDetail(false)} className="w-full font-bold">
                Cerrar
              </Button>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-card/95 backdrop-blur-xl border-t-2 border-border shadow-2xl">
        <div className="max-w-6xl mx-auto grid grid-cols-5 p-2 sm:p-3">
          <Link href="/dashboard" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center">
              <Dumbbell className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Inicio</span>
          </Link>
          <Link href="/workout" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center">
              <Play className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Entrenar</span>
          </Link>
          <Link href="/meals" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center">
              <UtensilsCrossed className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Comidas</span>
          </Link>
          <Link href="/progress" className="flex flex-col items-center gap-1 p-2 rounded-2xl bg-secondary/10 text-secondary transition-all">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-secondary/15 flex items-center justify-center">
              <TrendingUp className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-black">Progreso</span>
          </Link>
          <Link href="/profile" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center">
              <User className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Perfil</span>
          </Link>
        </div>
      </div>
    </div>
  )
}
