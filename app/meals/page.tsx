"use client"

import { useState, useEffect } from "react"
import Link from "next/link"
import { Dumbbell, Play, User, UtensilsCrossed, TrendingUp, ChevronDown, Apple, Salad, Drumstick, Cookie, Check } from 'lucide-react'
import { Card } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Button } from "@/components/ui/button"

const mealPlans = {
  "Bajar de peso": [
    {
      meal: "Desayuno",
      time: "7:00 AM",
      calories: 350,
      items: ["2 huevos revueltos", "1 tostada integral", "1/2 aguacate", "Cafe negro"],
      icon: Apple,
      color: "text-primary"
    },
    {
      meal: "Almuerzo",
      time: "1:00 PM",
      calories: 500,
      items: ["150g pechuga de pollo", "Ensalada verde mixta", "1 taza de arroz integral"],
      icon: Salad,
      color: "text-secondary"
    },
    {
      meal: "Cena",
      time: "7:00 PM",
      calories: 400,
      items: ["Salmon al horno 120g", "Vegetales al vapor", "Quinoa 1/2 taza"],
      icon: Drumstick,
      color: "text-accent"
    },
    {
      meal: "Snack",
      time: "4:00 PM",
      calories: 150,
      items: ["Yogurt griego", "Almendras (10 unidades)", "1 manzana"],
      icon: Cookie,
      color: "text-primary"
    }
  ],
  "Ganar musculo": [
    {
      meal: "Desayuno",
      time: "7:00 AM",
      calories: 550,
      items: ["3 huevos enteros", "2 tostadas", "Mantequilla de mani", "Batido de proteina"],
      icon: Apple,
      color: "text-primary"
    },
    {
      meal: "Almuerzo",
      time: "1:00 PM",
      calories: 750,
      items: ["200g carne roja magra", "2 tazas de arroz", "Ensalada con aceite de oliva"],
      icon: Salad,
      color: "text-secondary"
    },
    {
      meal: "Cena",
      time: "7:00 PM",
      calories: 650,
      items: ["Pechuga de pollo 200g", "Pasta integral", "Brocoli y zanahoria"],
      icon: Drumstick,
      color: "text-accent"
    },
    {
      meal: "Snack Pre-entreno",
      time: "5:00 PM",
      calories: 300,
      items: ["Batido de proteina", "Banana", "Avena"],
      icon: Cookie,
      color: "text-primary"
    }
  ]
}

export default function MealsPage() {
  const [selectedGoal, setSelectedGoal] = useState<"Bajar de peso" | "Ganar musculo">("Bajar de peso")
  const [eatenMeals, setEatenMeals] = useState<Record<string, boolean>>({})
  
  useEffect(() => {
    const stored = localStorage.getItem('eatenMeals')
    if (stored) {
      setEatenMeals(JSON.parse(stored))
    }
  }, [])

  const meals = mealPlans[selectedGoal]
  const totalCalories = meals.reduce((sum, meal) => sum + meal.calories, 0)
  const targetCalories = selectedGoal === "Bajar de peso" ? 1800 : 2800
  const caloriesProgress = (totalCalories / targetCalories) * 100

  const handleMealEaten = (mealName: string) => {
    const today = new Date().toISOString().split('T')[0]
    const key = `${today}-${mealName}`
    const newEatenMeals = { ...eatenMeals, [key]: !eatenMeals[key] }
    setEatenMeals(newEatenMeals)
    localStorage.setItem('eatenMeals', JSON.stringify(newEatenMeals))

    const calendarData = JSON.parse(localStorage.getItem('calendarData') || '{}')
    calendarData[today] = { ...calendarData[today], meal: true }
    localStorage.setItem('calendarData', JSON.stringify(calendarData))
  }

  const getMealKey = (mealName: string) => {
    const today = new Date().toISOString().split('T')[0]
    return `${today}-${mealName}`
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <div className="bg-gradient-to-r from-accent via-secondary to-primary p-6 text-white">
        <div className="max-w-6xl mx-auto space-y-4">
          <h1 className="text-3xl font-black">Plan de comidas</h1>
          <p className="text-white/90">Nutricion personalizada para tu objetivo</p>
        </div>
      </div>

      {/* Goal Selector */}
      <div className="max-w-6xl mx-auto p-4 -mt-4 relative z-10">
        <Card className="p-4 border-2 shadow-xl">
          <div className="grid grid-cols-2 gap-2">
            <Button
              onClick={() => setSelectedGoal("Bajar de peso")}
              variant={selectedGoal === "Bajar de peso" ? "default" : "outline"}
              className={`font-bold rounded-xl py-6 ${selectedGoal === "Bajar de peso" ? "bg-primary" : ""}`}
            >
              Bajar de peso
            </Button>
            <Button
              onClick={() => setSelectedGoal("Ganar musculo")}
              variant={selectedGoal === "Ganar musculo" ? "default" : "outline"}
              className={`font-bold rounded-xl py-6 ${selectedGoal === "Ganar musculo" ? "bg-primary" : ""}`}
            >
              Ganar musculo
            </Button>
          </div>
        </Card>
      </div>

      {/* Calories Progress */}
      <div className="max-w-6xl mx-auto p-4">
        <Card className="p-6 border-2">
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-black">Calorias del dia</h3>
              <Badge className="font-bold">{totalCalories} / {targetCalories} kcal</Badge>
            </div>
            <Progress value={caloriesProgress} className="h-3" />
            <p className="text-sm text-muted-foreground font-semibold">
              {targetCalories - totalCalories > 0 
                ? `Te quedan ${targetCalories - totalCalories} kcal` 
                : "Meta alcanzada"}
            </p>
          </div>
        </Card>
      </div>

      {/* Meals List */}
      <div className="max-w-6xl mx-auto p-4 space-y-4">
        {meals.map((meal, index) => {
          const Icon = meal.icon
          const mealKey = getMealKey(meal.meal)
          const isEaten = eatenMeals[mealKey] || false
          return (
            <Card key={index} className="p-5 border-2 hover:shadow-lg transition-all">
              <div className="flex items-start gap-4">
                <div className={`w-14 h-14 rounded-2xl bg-muted flex items-center justify-center flex-shrink-0 ${meal.color}`}>
                  <Icon className="w-7 h-7" />
                </div>
                <div className="flex-1 space-y-2">
                  <div className="flex justify-between items-start">
                    <div>
                      <h3 className="text-xl font-black">{meal.meal}</h3>
                      <p className="text-sm text-muted-foreground font-semibold">{meal.time}</p>
                    </div>
                    <Badge variant="outline" className="font-bold">{meal.calories} kcal</Badge>
                  </div>
                  <ul className="space-y-1">
                    {meal.items.map((item, i) => (
                      <li key={i} className="text-sm text-muted-foreground flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-primary" />
                        {item}
                      </li>
                    ))}
                  </ul>
                  <Button
                    onClick={() => handleMealEaten(meal.meal)}
                    variant={isEaten ? "default" : "outline"}
                    size="sm"
                    className="mt-2 font-bold"
                  >
                    <Check className="w-4 h-4 mr-2" />
                    {isEaten ? "Comido" : "Marcar como comido"}
                  </Button>
                </div>
              </div>
            </Card>
          )
        })}
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-card/95 backdrop-blur-xl border-t-2 border-border shadow-2xl">
        <div className="max-w-6xl mx-auto grid grid-cols-5 p-2 sm:p-3">
          <Link href="/dashboard" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <Dumbbell className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Inicio</span>
          </Link>
          <Link href="/workout" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <Play className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Entrenar</span>
          </Link>
          <Link href="/meals" className="flex flex-col items-center gap-1 p-2 rounded-2xl bg-accent/10 text-accent transition-all">
            <div className="w-10 h-10 rounded-xl bg-accent/15 flex items-center justify-center">
              <UtensilsCrossed className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-black">Comidas</span>
          </Link>
          <Link href="/progress" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Progreso</span>
          </Link>
          <Link href="/profile" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
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
