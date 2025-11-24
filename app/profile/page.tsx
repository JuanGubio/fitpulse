"use client"

import { useEffect, useState } from "react"
import { useRouter } from 'next/navigation'
import Link from "next/link"
import { User, Mail, Calendar, Flame, Target, Trophy, Award, LogOut, Activity, Dumbbell, UtensilsCrossed, TrendingUp, Play, Edit2, Save, Camera, Upload } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export default function ProfilePage() {
  const router = useRouter()
  const [isEditing, setIsEditing] = useState(false)
  const [avatarImage, setAvatarImage] = useState<string | null>(null)
  const [userData, setUserData] = useState({
    name: "Usuario",
    email: "usuario@ejemplo.com",
    joinDate: "Enero 2025",
    currentWeight: 75,
    goalWeight: 70,
    height: 175,
    streakDays: 6,
    totalWorkouts: 42,
    totalCalories: 15680
  })

  useEffect(() => {
    const profile = localStorage.getItem("userProfile")
    if (profile) {
      const data = JSON.parse(profile)
      setUserData(prev => ({ 
        ...prev, 
        name: data.name || prev.name,
        email: data.email || prev.email,
        currentWeight: data.currentWeight || prev.currentWeight,
        goalWeight: data.goalWeight || prev.goalWeight,
        height: data.height || prev.height
      }))
      if (data.avatar) {
        setAvatarImage(data.avatar)
      }
    }
  }, [])

  const handleSaveChanges = () => {
    const profile = { ...userData, avatar: avatarImage }
    localStorage.setItem("userProfile", JSON.stringify(profile))
    setIsEditing(false)
  }

  const handleLogout = () => {
    localStorage.removeItem("isAuthenticated")
    localStorage.removeItem("userProfile")
    localStorage.removeItem("isNewUser")
    router.push("/login")
  }

  const handleAvatarUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      const reader = new FileReader()
      reader.onloadend = () => {
        const result = reader.result as string
        setAvatarImage(result)
        const profile = JSON.parse(localStorage.getItem("userProfile") || "{}")
        profile.avatar = result
        localStorage.setItem("userProfile", JSON.stringify(profile))
      }
      reader.readAsDataURL(file)
    }
  }

  const achievements = [
    { icon: Flame, title: "Racha de 7 dias", color: "text-accent" },
    { icon: Trophy, title: "50 entrenamientos", color: "text-primary" },
    { icon: Target, title: "Meta cumplida", color: "text-secondary" },
    { icon: Award, title: "Principiante", color: "text-accent" }
  ]

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary via-secondary to-accent p-6 text-white relative overflow-hidden">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute top-0 right-0 w-32 h-32 rounded-full bg-white/10 blur-2xl animate-pulse" />
          <div className="absolute bottom-0 left-0 w-24 h-24 rounded-full bg-white/10 blur-xl animate-pulse delay-300" />
        </div>

        <div className="max-w-6xl mx-auto relative z-10">
          <div className="flex flex-col items-center space-y-4">
            <div className="relative">
              <Avatar className="w-24 h-24 border-4 border-white shadow-2xl">
                {avatarImage ? (
                  <img src={avatarImage || "/placeholder.svg"} alt="Avatar" className="w-full h-full object-cover" />
                ) : (
                  <AvatarFallback className="bg-white text-primary text-3xl font-black">
                    {userData.name.charAt(0).toUpperCase()}
                  </AvatarFallback>
                )}
              </Avatar>
              <label htmlFor="avatar-upload" className="absolute bottom-0 right-0 w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center cursor-pointer hover:bg-primary/90 shadow-lg border-2 border-white">
                <Camera className="w-4 h-4" />
              </label>
              <input
                id="avatar-upload"
                type="file"
                accept="image/*"
                className="hidden"
                onChange={handleAvatarUpload}
              />
            </div>
            <div className="text-center">
              <h1 className="text-3xl font-black">{userData.name}</h1>
              <p className="text-white/90 font-semibold mt-1">{userData.email}</p>
              <Badge className="mt-2 bg-white/20 text-white border-white/30 font-bold">
                <Calendar className="w-4 h-4 mr-1" />
                Miembro desde {userData.joinDate}
              </Badge>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="max-w-6xl mx-auto p-4 -mt-8 relative z-10">
        <div className="grid grid-cols-3 gap-3">
          <Card className="p-4 text-center shadow-lg border-2 hover:scale-105 transition-transform">
            <div className="w-12 h-12 rounded-2xl bg-accent/15 flex items-center justify-center mx-auto mb-2">
              <Flame className="w-6 h-6 text-accent" />
            </div>
            <p className="text-2xl font-black text-foreground">{userData.streakDays}</p>
            <p className="text-xs text-muted-foreground font-bold">Dias racha</p>
          </Card>

          <Card className="p-4 text-center shadow-lg border-2 hover:scale-105 transition-transform">
            <div className="w-12 h-12 rounded-2xl bg-primary/15 flex items-center justify-center mx-auto mb-2">
              <Dumbbell className="w-6 h-6 text-primary" />
            </div>
            <p className="text-2xl font-black text-foreground">{userData.totalWorkouts}</p>
            <p className="text-xs text-muted-foreground font-bold">Entrenamientos</p>
          </Card>

          <Card className="p-4 text-center shadow-lg border-2 hover:scale-105 transition-transform">
            <div className="w-12 h-12 rounded-2xl bg-secondary/15 flex items-center justify-center mx-auto mb-2">
              <Activity className="w-6 h-6 text-secondary" />
            </div>
            <p className="text-2xl font-black text-foreground">{userData.totalCalories}</p>
            <p className="text-xs text-muted-foreground font-bold">Calorias</p>
          </Card>
        </div>
      </div>

      {/* Body Info */}
      <div className="max-w-6xl mx-auto p-4 space-y-4">
        <Card className="p-6 border-2">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-black text-foreground">Informacion corporal</h2>
            {!isEditing ? (
              <Button
                onClick={() => setIsEditing(true)}
                variant="outline"
                size="sm"
                className="font-bold"
              >
                <Edit2 className="w-4 h-4 mr-2" />
                Editar
              </Button>
            ) : (
              <Button
                onClick={handleSaveChanges}
                size="sm"
                className="font-bold bg-primary"
              >
                <Save className="w-4 h-4 mr-2" />
                Guardar
              </Button>
            )}
          </div>
          
          {!isEditing ? (
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-muted-foreground font-semibold">Peso actual</span>
                <span className="text-lg font-black text-foreground">{userData.currentWeight} kg</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-muted-foreground font-semibold">Peso meta</span>
                <span className="text-lg font-black text-primary">{userData.goalWeight} kg</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-muted-foreground font-semibold">Altura</span>
                <span className="text-lg font-black text-foreground">{userData.height} cm</span>
              </div>
            </div>
          ) : (
            <div className="space-y-4">
              <div className="space-y-2">
                <Label className="font-semibold">Nombre</Label>
                <Input
                  value={userData.name}
                  onChange={(e) => setUserData({ ...userData, name: e.target.value })}
                  className="font-semibold"
                />
              </div>
              <div className="space-y-2">
                <Label className="font-semibold">Peso actual (kg)</Label>
                <Input
                  type="number"
                  value={userData.currentWeight}
                  onChange={(e) => setUserData({ ...userData, currentWeight: Number(e.target.value) })}
                  className="font-semibold"
                />
              </div>
              <div className="space-y-2">
                <Label className="font-semibold">Peso meta (kg)</Label>
                <Input
                  type="number"
                  value={userData.goalWeight}
                  onChange={(e) => setUserData({ ...userData, goalWeight: Number(e.target.value) })}
                  className="font-semibold"
                />
              </div>
              <div className="space-y-2">
                <Label className="font-semibold">Altura (cm)</Label>
                <Input
                  type="number"
                  value={userData.height}
                  onChange={(e) => setUserData({ ...userData, height: Number(e.target.value) })}
                  className="font-semibold"
                />
              </div>
            </div>
          )}
        </Card>

        {/* Achievements */}
        <Card className="p-6 border-2">
          <h2 className="text-xl font-black text-foreground mb-4">Logros desbloqueados</h2>
          <div className="grid grid-cols-2 gap-3">
            {achievements.map((achievement, index) => (
              <div
                key={index}
                className="flex items-center gap-3 p-3 rounded-xl bg-muted/50 border-2 hover:scale-105 transition-transform"
              >
                <div className={`w-10 h-10 rounded-xl bg-white flex items-center justify-center shadow-md ${achievement.color}`}>
                  <achievement.icon className="w-6 h-6" />
                </div>
                <p className="text-sm font-bold text-foreground">{achievement.title}</p>
              </div>
            ))}
          </div>
        </Card>

        {/* Logout Button */}
        <Button
          onClick={handleLogout}
          variant="outline"
          className="w-full h-12 rounded-xl font-black text-base border-2 hover:bg-destructive hover:text-white hover:border-destructive"
        >
          <LogOut className="w-5 h-5 mr-2" />
          Cerrar sesion
        </Button>
      </div>

      <div className="fixed bottom-0 left-0 right-0 bg-card/95 backdrop-blur-xl border-t-2 border-border shadow-2xl safe-area-bottom">
        <div className="max-w-6xl mx-auto grid grid-cols-5 p-2 sm:p-3">
          <Link href="/dashboard" className="flex flex-col items-center gap-1 p-2 rounded-2xl hover:bg-muted/50 text-muted-foreground hover:text-foreground transition-all">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <Dumbbell className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-bold">Inicio</span>
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
            className="flex flex-col items-center gap-1 p-2 rounded-2xl bg-primary/10 text-primary transition-all"
          >
            <div className="w-10 h-10 rounded-xl bg-primary/15 flex items-center justify-center">
              <User className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={2.5} />
            </div>
            <span className="text-[10px] sm:text-xs font-black">Perfil</span>
          </Link>
        </div>
      </div>
    </div>
  )
}
