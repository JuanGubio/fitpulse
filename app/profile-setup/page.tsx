"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { User, TrendingDown, TrendingUp, Target } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

export default function ProfileSetupPage() {
  const router = useRouter()
  const [formData, setFormData] = useState({
    name: "",
    age: "",
    gender: "",
    height: "",
    currentWeight: "",
    goalWeight: "",
    goal: "",
    activityLevel: "",
    dietPreference: "",
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    // Save profile data (in real app, would save to backend)
    localStorage.setItem("userProfile", JSON.stringify(formData))
    router.push("/dashboard")
  }

  return (
    <div className="min-h-screen bg-background py-6 sm:py-8 px-4">
      <div className="max-w-3xl mx-auto space-y-4 sm:space-y-6">
        {/* Header */}
        <div className="text-center space-y-2 sm:space-y-3">
          <div className="flex justify-center">
            <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-2xl bg-primary/10 flex items-center justify-center">
              <User className="w-7 h-7 sm:w-8 sm:h-8 text-primary" />
            </div>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-foreground">Perfil Inicial</h1>
          <p className="text-muted-foreground text-base sm:text-lg">
            Usamos estos datos para crear tu plan personalizado
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit}>
          <Card className="p-5 sm:p-6 md:p-8 space-y-5 sm:space-y-6 border-2">
            {/* Basic Info */}
            <div className="space-y-4">
              <div>
                <Label htmlFor="name" className="font-bold text-sm sm:text-base">
                  Nombre
                </Label>
                <Input
                  id="name"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="mt-2 h-11 sm:h-12 rounded-xl text-base"
                  required
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="age" className="font-bold text-sm sm:text-base">
                    Edad
                  </Label>
                  <Input
                    id="age"
                    type="number"
                    value={formData.age}
                    onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                    className="mt-2 h-11 sm:h-12 rounded-xl text-base"
                    required
                  />
                </div>
                <div>
                  <Label className="font-bold text-sm sm:text-base">Sexo</Label>
                  <Select
                    value={formData.gender}
                    onValueChange={(value) => setFormData({ ...formData, gender: value })}
                  >
                    <SelectTrigger className="mt-2 h-11 sm:h-12 rounded-xl">
                      <SelectValue placeholder="Selecciona" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="male">Hombre</SelectItem>
                      <SelectItem value="female">Mujer</SelectItem>
                      <SelectItem value="other">Otro</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <Label htmlFor="height" className="font-bold text-sm sm:text-base">
                    Altura (cm)
                  </Label>
                  <Input
                    id="height"
                    type="number"
                    value={formData.height}
                    onChange={(e) => setFormData({ ...formData, height: e.target.value })}
                    className="mt-2 h-11 sm:h-12 rounded-xl text-base"
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="currentWeight" className="font-bold text-sm sm:text-base">
                    Peso actual (kg)
                  </Label>
                  <Input
                    id="currentWeight"
                    type="number"
                    value={formData.currentWeight}
                    onChange={(e) => setFormData({ ...formData, currentWeight: e.target.value })}
                    className="mt-2 h-11 sm:h-12 rounded-xl text-base"
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="goalWeight" className="font-bold text-sm sm:text-base">
                    Meta de peso (kg)
                  </Label>
                  <Input
                    id="goalWeight"
                    type="number"
                    value={formData.goalWeight}
                    onChange={(e) => setFormData({ ...formData, goalWeight: e.target.value })}
                    className="mt-2 h-11 sm:h-12 rounded-xl text-base"
                    required
                  />
                </div>
              </div>
            </div>

            {/* Goal Selection */}
            <div className="space-y-3">
              <Label className="font-bold text-sm sm:text-base">Objetivo</Label>
              <RadioGroup
                value={formData.goal}
                onValueChange={(value) => setFormData({ ...formData, goal: value })}
                className="gap-2 sm:gap-3"
              >
                <Card
                  className="p-3 sm:p-4 cursor-pointer hover:border-primary transition-all"
                  onClick={() => setFormData({ ...formData, goal: "lose" })}
                >
                  <div className="flex items-center space-x-3">
                    <RadioGroupItem value="lose" id="lose" />
                    <Label htmlFor="lose" className="flex items-center gap-2 sm:gap-3 cursor-pointer flex-1">
                      <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-destructive/10 flex items-center justify-center shrink-0">
                        <TrendingDown className="w-4 h-4 sm:w-5 sm:h-5 text-destructive" />
                      </div>
                      <span className="font-semibold text-sm sm:text-base">Bajar de peso</span>
                    </Label>
                  </div>
                </Card>
                <Card
                  className="p-3 sm:p-4 cursor-pointer hover:border-primary transition-all"
                  onClick={() => setFormData({ ...formData, goal: "gain" })}
                >
                  <div className="flex items-center space-x-3">
                    <RadioGroupItem value="gain" id="gain" />
                    <Label htmlFor="gain" className="flex items-center gap-2 sm:gap-3 cursor-pointer flex-1">
                      <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                        <TrendingUp className="w-4 h-4 sm:w-5 sm:h-5 text-primary" />
                      </div>
                      <span className="font-semibold text-sm sm:text-base">Ganar masa muscular</span>
                    </Label>
                  </div>
                </Card>
                <Card
                  className="p-3 sm:p-4 cursor-pointer hover:border-primary transition-all"
                  onClick={() => setFormData({ ...formData, goal: "tone" })}
                >
                  <div className="flex items-center space-x-3">
                    <RadioGroupItem value="tone" id="tone" />
                    <Label htmlFor="tone" className="flex items-center gap-2 sm:gap-3 cursor-pointer flex-1">
                      <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-secondary/10 flex items-center justify-center shrink-0">
                        <Target className="w-4 h-4 sm:w-5 sm:h-5 text-secondary" />
                      </div>
                      <span className="font-semibold text-sm sm:text-base">Definir cara / tonificar</span>
                    </Label>
                  </div>
                </Card>
              </RadioGroup>
            </div>

            {/* Activity Level */}
            <div>
              <Label className="font-bold text-sm sm:text-base">Nivel de actividad</Label>
              <Select
                value={formData.activityLevel}
                onValueChange={(value) => setFormData({ ...formData, activityLevel: value })}
              >
                <SelectTrigger className="mt-2 h-11 sm:h-12 rounded-xl">
                  <SelectValue placeholder="Selecciona" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="sedentary">Sedentario</SelectItem>
                  <SelectItem value="moderate">Moderado</SelectItem>
                  <SelectItem value="active">Activo</SelectItem>
                  <SelectItem value="advanced">Avanzado</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Diet Preference */}
            <div>
              <Label className="font-bold text-sm sm:text-base">Preferencias alimenticias</Label>
              <Select
                value={formData.dietPreference}
                onValueChange={(value) => setFormData({ ...formData, dietPreference: value })}
              >
                <SelectTrigger className="mt-2 h-11 sm:h-12 rounded-xl">
                  <SelectValue placeholder="Selecciona" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="omnivore">Omnívoro</SelectItem>
                  <SelectItem value="vegetarian">Vegetariano</SelectItem>
                  <SelectItem value="vegan">Vegano</SelectItem>
                  <SelectItem value="gluten-free">Sin gluten</SelectItem>
                  <SelectItem value="keto">Keto</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Submit Button */}
            <Button
              type="submit"
              size="lg"
              className="w-full font-bold text-base sm:text-lg py-5 sm:py-6 rounded-xl bg-primary hover:bg-primary/90"
            >
              Guardar perfil
            </Button>
          </Card>
        </form>
      </div>
    </div>
  )
}
