"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, Play, CheckCircle2, Circle, Timer } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

const workoutBlocks = [
  {
    title: "Calentamiento",
    duration: "5 min",
    exercises: ["Marcha en el sitio", "Círculos de brazos", "Flexiones ligeras"],
    color: "accent",
  },
  {
    title: "Bloque 1 — Tren inferior",
    duration: "10 min",
    exercises: ["Sentadillas (Squats)", "Zancadas (Lunges)", "Puente de glúteos"],
    color: "primary",
  },
  {
    title: "Bloque 2 — Tren superior",
    duration: "10 min",
    exercises: ["Flexiones (Push-ups)", "Press con botellas", "Planchas dinámicas"],
    color: "secondary",
  },
  {
    title: "Bloque 3 — Core + Facial",
    duration: "10 min",
    exercises: ["Abdominales bicicleta", "Plancha frontal", "Ejercicio facial"],
    color: "primary",
  },
  {
    title: "Enfriamiento",
    duration: "5 min",
    exercises: ["Estiramientos", "Respiración guiada"],
    color: "accent",
  },
]

export default function WorkoutPage() {
  const [completedBlocks, setCompletedBlocks] = useState<number[]>([])

  const toggleBlock = (index: number) => {
    if (completedBlocks.includes(index)) {
      setCompletedBlocks(completedBlocks.filter((i) => i !== index))
    } else {
      setCompletedBlocks([...completedBlocks, index])
    }
  }

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header */}
      <div className="bg-primary p-6 text-white sticky top-0 z-10">
        <div className="max-w-4xl mx-auto">
          <div className="flex items-center gap-4 mb-4">
            <Link href="/dashboard">
              <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                <ArrowLeft className="w-6 h-6" />
              </Button>
            </Link>
            <div className="flex-1">
              <h1 className="text-2xl font-black">Entrenamiento de fuerza</h1>
              <p className="text-white/90 mt-1">Duración: 40 min • Nivel: Intermedio</p>
            </div>
          </div>

          {/* Progress */}
          <div className="flex items-center gap-3 bg-white/10 backdrop-blur-sm rounded-xl p-3">
            <div className="flex-1">
              <div className="flex justify-between text-sm font-bold mb-2">
                <span>
                  {completedBlocks.length} / {workoutBlocks.length} bloques
                </span>
                <span>{Math.round((completedBlocks.length / workoutBlocks.length) * 100)}%</span>
              </div>
              <div className="h-2 bg-white/20 rounded-full overflow-hidden">
                <div
                  className="h-full bg-white transition-all duration-500"
                  style={{ width: `${(completedBlocks.length / workoutBlocks.length) * 100}%` }}
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Workout Blocks */}
      <div className="max-w-4xl mx-auto p-6 space-y-4">
        {workoutBlocks.map((block, index) => {
          const isCompleted = completedBlocks.includes(index)
          const colorClass =
            block.color === "primary"
              ? "border-primary"
              : block.color === "secondary"
                ? "border-secondary"
                : "border-accent"
          const bgClass =
            block.color === "primary"
              ? "bg-primary/10"
              : block.color === "secondary"
                ? "bg-secondary/10"
                : "bg-accent/10"
          const iconColorClass =
            block.color === "primary" ? "text-primary" : block.color === "secondary" ? "text-secondary" : "text-accent"

          return (
            <Card
              key={index}
              className={`p-6 border-2 transition-all ${isCompleted ? "opacity-60" : "hover:shadow-lg"}`}
            >
              <div className="space-y-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-start gap-4 flex-1">
                    <div className={`w-12 h-12 rounded-xl ${bgClass} flex items-center justify-center flex-shrink-0`}>
                      {isCompleted ? (
                        <CheckCircle2 className={`w-6 h-6 ${iconColorClass}`} />
                      ) : (
                        <Circle className={`w-6 h-6 ${iconColorClass}`} />
                      )}
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-2 flex-wrap">
                        <h3 className="text-xl font-black text-foreground">{block.title}</h3>
                        <Badge variant="secondary" className="font-semibold">
                          <Timer className="w-3 h-3 mr-1" />
                          {block.duration}
                        </Badge>
                      </div>
                      <ul className="mt-3 space-y-2">
                        {block.exercises.map((exercise, i) => (
                          <li key={i} className="text-muted-foreground flex items-start gap-2">
                            <span className="text-primary mt-1">•</span>
                            <span>{exercise}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>

                <div className="flex gap-3">
                  <Link href={`/exercise/${index}`} className="flex-1">
                    <Button
                      className={`w-full font-bold rounded-xl ${
                        block.color === "primary"
                          ? "bg-primary hover:bg-primary/90"
                          : block.color === "secondary"
                            ? "bg-secondary hover:bg-secondary/90"
                            : "bg-accent hover:bg-accent/90"
                      }`}
                      disabled={isCompleted}
                    >
                      <Play className="w-4 h-4 mr-2" />
                      {isCompleted ? "Completado" : "Iniciar bloque"}
                    </Button>
                  </Link>
                  {!isCompleted && (
                    <Button
                      variant="outline"
                      className="px-6 font-bold rounded-xl bg-transparent"
                      onClick={() => toggleBlock(index)}
                    >
                      Marcar como hecho
                    </Button>
                  )}
                </div>
              </div>
            </Card>
          )
        })}
      </div>

      {/* Complete Workout Button */}
      {completedBlocks.length === workoutBlocks.length && (
        <div className="fixed bottom-20 left-0 right-0 p-6 bg-gradient-to-t from-background to-transparent">
          <div className="max-w-4xl mx-auto">
            <Button
              size="lg"
              className="w-full font-bold text-lg py-6 rounded-xl bg-primary hover:bg-primary/90"
              onClick={() => alert("🎯 ¡Entrenamiento completado! +35 XP y +1 día en tu racha.")}
            >
              Finalizar entrenamiento
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}
