"use client"

import { useState, useEffect } from "react"
import { useParams, useRouter } from 'next/navigation'
import { ArrowLeft, Play, Pause, RotateCcw, SkipForward, CheckCircle2, Camera } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"

export default function ExercisePage() {
  const params = useParams()
  const router = useRouter()
  const [timeLeft, setTimeLeft] = useState(30)
  const [isRunning, setIsRunning] = useState(false)
  const [exerciseIndex, setExerciseIndex] = useState(0)
  const [workoutComplete, setWorkoutComplete] = useState(false)
  const [workoutPhoto, setWorkoutPhoto] = useState<string | null>(null)

  const exercises = [
    { name: "Sentadillas", duration: 30 },
    { name: "Zancadas", duration: 30 },
    { name: "Puente de glúteos", duration: 30 },
  ]

  const currentExercise = exercises[exerciseIndex]

  useEffect(() => {
    let interval: NodeJS.Timeout | null = null
    if (isRunning && timeLeft > 0) {
      interval = setInterval(() => {
        setTimeLeft((time) => time - 1)
      }, 1000)
    } else if (timeLeft === 0) {
      setIsRunning(false)
      if (exerciseIndex < exercises.length - 1) {
        setTimeout(() => {
          setExerciseIndex(exerciseIndex + 1)
          setTimeLeft(exercises[exerciseIndex + 1].duration)
        }, 1000)
      } else {
        setWorkoutComplete(true)
      }
    }
    return () => {
      if (interval) clearInterval(interval)
    }
  }, [isRunning, timeLeft, exerciseIndex])

  const saveWorkoutToCalendar = () => {
    const today = new Date().toISOString().split('T')[0]
    const calendarData = JSON.parse(localStorage.getItem('calendarData') || '{}')
    calendarData[today] = { 
      ...calendarData[today], 
      workout: true,
      photo: workoutPhoto || undefined
    }
    localStorage.setItem('calendarData', JSON.stringify(calendarData))
  }

  const toggleTimer = () => setIsRunning(!isRunning)
  const resetTimer = () => {
    setIsRunning(false)
    setTimeLeft(currentExercise.duration)
  }
  const nextExercise = () => {
    if (exerciseIndex < exercises.length - 1) {
      setIsRunning(false)
      setExerciseIndex(exerciseIndex + 1)
      setTimeLeft(exercises[exerciseIndex + 1].duration)
    }
  }

  const progress = ((currentExercise.duration - timeLeft) / currentExercise.duration) * 100

  const handlePhotoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      const reader = new FileReader()
      reader.onloadend = () => {
        setWorkoutPhoto(reader.result as string)
      }
      reader.readAsDataURL(file)
    }
  }

  if (workoutComplete) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center p-6">
        <Card className="max-w-md w-full p-8 text-center space-y-6 border-2">
          <div className="flex justify-center">
            <div className="w-24 h-24 rounded-full bg-primary/20 flex items-center justify-center">
              <CheckCircle2 className="w-16 h-16 text-primary" />
            </div>
          </div>
          <div>
            <h2 className="text-3xl font-black text-foreground mb-2">Entrenamiento completado</h2>
            <p className="text-muted-foreground">Has terminado todos los ejercicios. Buen trabajo</p>
          </div>
          {!workoutPhoto ? (
            <div>
              <p className="text-sm text-muted-foreground mb-3 font-semibold">Toma una foto de tu progreso</p>
              <label htmlFor="workout-photo" className="inline-flex items-center gap-2 px-6 py-3 bg-secondary text-white rounded-xl font-bold cursor-pointer hover:bg-secondary/90">
                <Camera className="w-5 h-5" />
                Subir foto
              </label>
              <input
                id="workout-photo"
                type="file"
                accept="image/*"
                capture="environment"
                className="hidden"
                onChange={handlePhotoUpload}
              />
            </div>
          ) : (
            <div className="space-y-3">
              <div className="relative aspect-video rounded-xl overflow-hidden">
                <img src={workoutPhoto || "/placeholder.svg"} alt="Workout" className="w-full h-full object-cover" />
              </div>
              <p className="text-sm text-primary font-bold">Foto guardada con tu entrenamiento</p>
            </div>
          )}
          <Button
            size="lg"
            onClick={() => {
              saveWorkoutToCalendar()
              router.push('/dashboard')
            }}
            className="w-full bg-primary hover:bg-primary/90 font-black rounded-xl"
          >
            Volver al inicio
          </Button>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Header */}
      <div className="bg-primary p-4 sm:p-6 text-white">
        <div className="max-w-4xl mx-auto flex items-center gap-3 sm:gap-4">
          <Button variant="ghost" size="icon" className="text-white hover:bg-white/20" onClick={() => router.back()}>
            <ArrowLeft className="w-5 h-5 sm:w-6 sm:h-6" />
          </Button>
          <div>
            <h1 className="text-xl sm:text-2xl font-black">Temporizador de ejercicio</h1>
            <p className="text-white/90 text-xs sm:text-sm mt-1">
              Ejercicio {exerciseIndex + 1} de {exercises.length}
            </p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex items-center justify-center p-4 sm:p-6">
        <Card className="max-w-2xl w-full p-6 sm:p-8 space-y-6 sm:space-y-8 border-2">
          {/* Exercise Name */}
          <div className="text-center">
            <h2 className="text-2xl sm:text-3xl font-black text-foreground">{currentExercise.name}</h2>
          </div>

          {/* Timer Circle */}
          <div className="flex justify-center">
            <div className="relative w-56 h-56 sm:w-64 sm:h-64">
              {/* Background circle */}
              <svg className="w-full h-full transform -rotate-90">
                <circle
                  cx="50%"
                  cy="50%"
                  r="45%"
                  stroke="currentColor"
                  strokeWidth="12"
                  fill="none"
                  className="text-muted"
                />
                {/* Progress circle */}
                <circle
                  cx="50%"
                  cy="50%"
                  r="45%"
                  stroke="currentColor"
                  strokeWidth="12"
                  fill="none"
                  strokeDasharray="283"
                  strokeDashoffset={`${283 * (1 - progress / 100)}`}
                  className="text-primary transition-all duration-1000"
                  strokeLinecap="round"
                />
              </svg>
              {/* Time text */}
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="text-center">
                  <div className="text-5xl sm:text-6xl font-black text-foreground">{timeLeft}</div>
                  <div className="text-base sm:text-lg text-muted-foreground font-semibold">segundos</div>
                </div>
              </div>
            </div>
          </div>

          {/* Controls */}
          <div className="flex gap-3 justify-center">
            <Button size="lg" variant="outline" onClick={resetTimer} className="w-14 h-14 sm:w-16 sm:h-16 rounded-full">
              <RotateCcw className="w-5 h-5 sm:w-6 sm:h-6" />
            </Button>

            <Button size="lg" onClick={toggleTimer} className="w-16 h-16 sm:w-20 sm:h-20 rounded-full bg-primary hover:bg-primary/90">
              {isRunning ? <Pause className="w-6 h-6 sm:w-8 sm:h-8" /> : <Play className="w-6 h-6 sm:w-8 sm:h-8 ml-1" />}
            </Button>

            <Button
              size="lg"
              variant="outline"
              onClick={nextExercise}
              disabled={exerciseIndex >= exercises.length - 1}
              className="w-14 h-14 sm:w-16 sm:h-16 rounded-full"
            >
              <SkipForward className="w-5 h-5 sm:w-6 sm:h-6" />
            </Button>
          </div>

          {/* Duration Options */}
          <div className="flex gap-2 justify-center flex-wrap">
            <p className="w-full text-center text-sm text-muted-foreground font-semibold mb-2">Cambiar duración:</p>
            {[15, 30, 45, 60].map((duration) => (
              <Button
                key={duration}
                variant={timeLeft === duration ? "default" : "outline"}
                size="sm"
                onClick={() => {
                  setTimeLeft(duration)
                  setIsRunning(false)
                }}
                className="rounded-xl font-bold"
              >
                {duration}s
              </Button>
            ))}
          </div>
        </Card>
      </div>
    </div>
  )
}
