"use client"

import { useState, useEffect } from "react"
import Link from "next/link"
import { ArrowLeft, Users, Ruler, Weight, Target, Sparkles, User } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Slider } from "@/components/ui/slider"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function ComparatorPage() {
  const [height, setHeight] = useState(170)
  const [currentWeight, setCurrentWeight] = useState(75)
  const [targetWeight, setTargetWeight] = useState(68)
  const [currentBodyImage, setCurrentBodyImage] = useState("")
  const [targetBodyImage, setTargetBodyImage] = useState("")
  
  useEffect(() => {
    const currentBMI = calculateBMI(currentWeight, height)
    const targetBMI = calculateBMI(targetWeight, height)
    
    setCurrentBodyImage(`/placeholder.svg?height=400&width=200&query=human body silhouette side view ${getBMICategory(parseFloat(currentBMI))} build transparent background`)
    setTargetBodyImage(`/placeholder.svg?height=400&width=200&query=human body silhouette side view ${getBMICategory(parseFloat(targetBMI))} athletic build transparent background`)
  }, [height, currentWeight, targetWeight])

  const calculateBMI = (weight: number, height: number) => {
    const heightInMeters = height / 100
    return (weight / (heightInMeters * heightInMeters)).toFixed(1)
  }

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5) return "slim thin"
    if (bmi < 25) return "normal healthy"
    if (bmi < 30) return "overweight stocky"
    return "obese heavy"
  }

  const currentBMI = calculateBMI(currentWeight, height)
  const targetBMI = calculateBMI(targetWeight, height)

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary via-secondary to-accent p-4 sm:p-6 text-white sticky top-0 z-10 shadow-lg">
        <div className="max-w-6xl mx-auto">
          <div className="flex items-center gap-3 sm:gap-4">
            <Link href="/dashboard">
              <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                <ArrowLeft className="w-5 h-5 sm:w-6 sm:h-6" />
              </Button>
            </Link>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <Users className="w-5 h-5 sm:w-6 sm:h-6" />
                <h1 className="text-xl sm:text-2xl md:text-3xl font-black">Comparador corporal</h1>
              </div>
              <p className="text-white/95 text-xs sm:text-sm font-semibold">Visualiza tu transformación</p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-6xl mx-auto p-4 sm:p-6">
        <Tabs defaultValue="individual" className="space-y-6">
          <TabsList className="grid w-full grid-cols-2 h-auto p-1">
            <TabsTrigger value="individual" className="text-xs sm:text-sm font-bold py-2 sm:py-3">
              Comparación individual
            </TabsTrigger>
            <TabsTrigger value="group" className="text-xs sm:text-sm font-bold py-2 sm:py-3">
              Comparar con otros
            </TabsTrigger>
          </TabsList>

          {/* Individual Comparison */}
          <TabsContent value="individual" className="space-y-6">
            {/* Input Controls */}
            <Card className="p-5 sm:p-6 border-2 shadow-lg">
              <h2 className="text-lg sm:text-xl font-black text-foreground mb-5 sm:mb-6 flex items-center gap-2">
                <Target className="w-5 h-5 sm:w-6 sm:h-6 text-primary" />
                Configuración
              </h2>
              <div className="space-y-6">
                {/* Height Slider */}
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <label className="text-sm sm:text-base font-bold text-foreground flex items-center gap-2">
                      <Ruler className="w-4 h-4 sm:w-5 sm:h-5 text-primary" />
                      Altura
                    </label>
                    <Badge variant="secondary" className="text-base sm:text-lg font-black px-3 py-1">
                      {height} cm
                    </Badge>
                  </div>
                  <Slider
                    value={[height]}
                    onValueChange={(value) => setHeight(value[0])}
                    min={140}
                    max={220}
                    step={1}
                    className="w-full"
                  />
                </div>

                {/* Current Weight Slider */}
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <label className="text-sm sm:text-base font-bold text-foreground flex items-center gap-2">
                      <Weight className="w-4 h-4 sm:w-5 sm:h-5 text-secondary" />
                      Peso actual
                    </label>
                    <Badge variant="secondary" className="text-base sm:text-lg font-black px-3 py-1">
                      {currentWeight} kg
                    </Badge>
                  </div>
                  <Slider
                    value={[currentWeight]}
                    onValueChange={(value) => setCurrentWeight(value[0])}
                    min={40}
                    max={150}
                    step={1}
                    className="w-full"
                  />
                </div>

                {/* Target Weight Slider */}
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <label className="text-sm sm:text-base font-bold text-foreground flex items-center gap-2">
                      <Target className="w-4 h-4 sm:w-5 sm:h-5 text-accent" />
                      Peso objetivo
                    </label>
                    <Badge variant="secondary" className="text-base sm:text-lg font-black px-3 py-1">
                      {targetWeight} kg
                    </Badge>
                  </div>
                  <Slider
                    value={[targetWeight]}
                    onValueChange={(value) => setTargetWeight(value[0])}
                    min={40}
                    max={150}
                    step={1}
                    className="w-full"
                  />
                </div>
              </div>
            </Card>

            {/* Comparison View */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
              {/* Current Body */}
              <Card className="p-5 sm:p-6 border-2 border-secondary hover:shadow-2xl transition-all group animate-in fade-in slide-in-from-left duration-500">
                <div className="space-y-4">
                  <div className="text-center">
                    <Badge className="bg-secondary text-white font-black text-xs sm:text-sm px-3 py-1 mb-3">
                      Tu actual
                    </Badge>
                    <h3 className="text-xl sm:text-2xl font-black text-foreground">Estado actual</h3>
                  </div>

                  <div className="relative h-72 sm:h-96 flex items-end justify-center bg-gradient-to-t from-secondary/5 to-transparent rounded-2xl overflow-hidden">
                    <img
                      src={currentBodyImage || "/placeholder.svg"}
                      alt="Current body"
                      className="h-full object-contain transition-transform group-hover:scale-105 duration-500"
                      style={{
                        filter: "drop-shadow(0 0 20px rgba(99, 102, 241, 0.3))",
                      }}
                    />
                    <div className="absolute top-2 right-2">
                      <Sparkles className="w-5 h-5 text-secondary" />
                    </div>
                  </div>

                  {/* Stats */}
                  <div className="space-y-2 bg-secondary/5 rounded-xl p-4">
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">Peso:</span>
                      <span className="text-lg font-black text-foreground">{currentWeight} kg</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">IMC:</span>
                      <span className="text-lg font-black text-foreground">{currentBMI}</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">Altura:</span>
                      <span className="text-lg font-black text-foreground">{height} cm</span>
                    </div>
                  </div>
                </div>
              </Card>

              {/* Target Body */}
              <Card className="p-5 sm:p-6 border-2 border-accent hover:shadow-2xl transition-all group animate-in fade-in slide-in-from-right duration-500">
                <div className="space-y-4">
                  <div className="text-center">
                    <Badge className="bg-accent text-white font-black text-xs sm:text-sm px-3 py-1 mb-3">Tu meta</Badge>
                    <h3 className="text-xl sm:text-2xl font-black text-foreground">Cómo te verás</h3>
                  </div>

                  <div className="relative h-72 sm:h-96 flex items-end justify-center bg-gradient-to-t from-accent/5 to-transparent rounded-2xl overflow-hidden">
                    <img
                      src={targetBodyImage || "/placeholder.svg"}
                      alt="Target body"
                      className="h-full object-contain transition-transform group-hover:scale-105 duration-500"
                      style={{
                        filter: "drop-shadow(0 0 20px rgba(251, 146, 60, 0.3))",
                      }}
                    />
                    <div className="absolute top-2 right-2">
                      <Sparkles className="w-5 h-5 text-accent" />
                    </div>
                  </div>

                  {/* Stats */}
                  <div className="space-y-2 bg-accent/5 rounded-xl p-4">
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">Peso:</span>
                      <span className="text-lg font-black text-foreground">{targetWeight} kg</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">IMC:</span>
                      <span className="text-lg font-black text-foreground">{targetBMI}</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-muted-foreground">Diferencia:</span>
                      <span className="text-lg font-black text-accent">
                        {currentWeight > targetWeight ? "-" : "+"}
                        {Math.abs(currentWeight - targetWeight)} kg
                      </span>
                    </div>
                  </div>
                </div>
              </Card>
            </div>

            {/* Motivation Card */}
            <Card className="p-5 sm:p-6 bg-gradient-to-r from-primary/10 via-secondary/10 to-accent/10 border-2 border-primary/20 shadow-lg animate-in fade-in zoom-in duration-700">
              <div className="flex items-start gap-3 sm:gap-4">
                <div className="w-12 h-12 sm:w-14 sm:h-14 rounded-2xl bg-primary/20 flex items-center justify-center flex-shrink-0">
                  <Target className="w-6 h-6 sm:w-7 sm:h-7 text-primary" />
                </div>
                <div className="flex-1">
                  <h3 className="text-base sm:text-lg font-black text-foreground mb-2">Tu plan personalizado</h3>
                  <p className="text-sm sm:text-base text-muted-foreground leading-relaxed">
                    {currentWeight > targetWeight ? (
                      <>
                        Para perder <span className="font-black text-foreground">{currentWeight - targetWeight} kg</span>,
                        necesitarás aproximadamente{" "}
                        <span className="font-black text-foreground">
                          {Math.ceil((currentWeight - targetWeight) / 0.5)} semanas
                        </span>{" "}
                        con una pérdida saludable de 0.5 kg por semana.
                      </>
                    ) : (
                      <>
                        Para ganar <span className="font-black text-foreground">{targetWeight - currentWeight} kg</span> de
                        masa muscular, necesitarás aproximadamente{" "}
                        <span className="font-black text-foreground">
                          {Math.ceil((targetWeight - currentWeight) / 0.5)} semanas
                        </span>{" "}
                        con un incremento saludable de 0.5 kg por semana.
                      </>
                    )}
                  </p>
                  <Button className="mt-4 bg-primary hover:bg-primary/90 font-black rounded-xl w-full sm:w-auto">
                    Iniciar mi plan
                  </Button>
                </div>
              </div>
            </Card>
          </TabsContent>

          <TabsContent value="group" className="space-y-6">
            <Card className="p-6 border-2">
              <h2 className="text-xl font-black mb-4">Compara con otros usuarios</h2>
              <p className="text-muted-foreground mb-6">
                Ve cómo tu progreso se compara con otros usuarios con objetivos similares.
              </p>
              
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                {[
                  { name: "Usuario 1", height: 175, weight: 70, goal: "Perder peso" },
                  { name: "Usuario 2", height: 168, weight: 65, goal: "Ganar músculo" },
                  { name: "Usuario 3", height: 180, weight: 82, goal: "Perder peso" },
                ].map((user, idx) => (
                  <Card key={idx} className="p-4 border hover:shadow-lg transition-all">
                    <div className="text-center space-y-3">
                      <div className="w-16 h-16 mx-auto rounded-full bg-primary/10 flex items-center justify-center">
                        <User className="w-8 h-8 text-primary" />
                      </div>
                      <div>
                        <h3 className="font-black">{user.name}</h3>
                        <p className="text-sm text-muted-foreground">{user.goal}</p>
                      </div>
                      <div className="space-y-1 text-xs">
                        <p><span className="font-bold">Altura:</span> {user.height} cm</p>
                        <p><span className="font-bold">Peso:</span> {user.weight} kg</p>
                        <p><span className="font-bold">IMC:</span> {calculateBMI(user.weight, user.height)}</p>
                      </div>
                      <Button size="sm" variant="outline" className="w-full">
                        Comparar
                      </Button>
                    </div>
                  </Card>
                ))}
              </div>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}
