"use client"

import { useState } from "react"
import { useRouter } from 'next/navigation'
import { ChevronRight, ChevronLeft, Dumbbell, Eye, TrendingUp, UtensilsCrossed } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"

const onboardingSteps = [
  {
    title: "Tu cuerpo, tu camino",
    description: "Elige tu objetivo: bajar grasa, ganar músculo o definir tu rostro.",
    icon: Dumbbell,
  },
  {
    title: "Aprende visualmente",
    description: "Cada movimiento tiene una guía animada e instrucciones simples.",
    icon: Eye,
  },
  {
    title: "Visualiza tu progreso",
    description: "Compara tu estatura y peso con otros y mira cómo te verías.",
    icon: TrendingUp,
  },
  {
    title: "Come mejor, vive mejor",
    description: "Planes alimenticios adaptados a tus metas — para ganar masa o perder peso.",
    icon: UtensilsCrossed,
  },
]

export default function OnboardingPage() {
  const [currentStep, setCurrentStep] = useState(0)
  const router = useRouter()

  const handleNext = () => {
    if (currentStep < onboardingSteps.length - 1) {
      setCurrentStep(currentStep + 1)
    } else {
      router.push("/profile-setup")
    }
  }

  const handlePrev = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1)
    }
  }

  const step = onboardingSteps[currentStep]
  const Icon = step.icon

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Progress bar */}
      <div className="w-full h-2 bg-muted">
        <div
          className="h-full bg-primary transition-all duration-500 ease-out"
          style={{ width: `${((currentStep + 1) / onboardingSteps.length) * 100}%` }}
        />
      </div>

      {/* Main content */}
      <div className="flex-1 flex items-center justify-center p-4 sm:p-6">
        <Card className="max-w-2xl w-full p-6 sm:p-8 space-y-6 sm:space-y-8 border-2 shadow-xl">
          <div className="flex justify-center">
            <div className="w-24 h-24 sm:w-32 sm:h-32 rounded-3xl bg-gradient-to-br from-primary/20 to-secondary/20 flex items-center justify-center animate-pulse shadow-lg">
              <Icon className="w-12 h-12 sm:w-16 sm:h-16 text-primary" strokeWidth={2.5} />
            </div>
          </div>

          {/* Text */}
          <div className="text-center space-y-3 sm:space-y-4">
            <h2 className="text-2xl sm:text-3xl font-black text-foreground text-balance">{step.title}</h2>
            <p className="text-base sm:text-lg text-muted-foreground leading-relaxed text-pretty">{step.description}</p>
          </div>

          {/* Navigation dots */}
          <div className="flex justify-center gap-2">
            {onboardingSteps.map((_, index) => (
              <button
                key={index}
                onClick={() => setCurrentStep(index)}
                className={`h-2 rounded-full transition-all duration-300 ${
                  index === currentStep ? "w-8 bg-primary" : "w-2 bg-muted-foreground/30"
                }`}
              />
            ))}
          </div>

          {/* Navigation buttons */}
          <div className="flex gap-3 sm:gap-4">
            {currentStep > 0 && (
              <Button
                variant="outline"
                size="lg"
                onClick={handlePrev}
                className="flex-1 font-bold text-sm sm:text-base rounded-xl bg-transparent py-5 sm:py-6"
              >
                <ChevronLeft className="w-4 h-4 sm:w-5 sm:h-5 mr-2" />
                Anterior
              </Button>
            )}
            <Button
              size="lg"
              onClick={handleNext}
              className={`font-bold text-sm sm:text-base rounded-xl ${currentStep === 0 ? "flex-1" : "flex-1"} bg-primary hover:bg-primary/90 py-5 sm:py-6`}
            >
              {currentStep === onboardingSteps.length - 1 ? "Crear mi plan personalizado" : "Siguiente"}
              {currentStep < onboardingSteps.length - 1 && <ChevronRight className="w-4 h-4 sm:w-5 sm:h-5 ml-2" />}
            </Button>
          </div>
        </Card>
      </div>
    </div>
  )
}
