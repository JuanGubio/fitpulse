"use client"

import { useState } from "react"
import { useRouter } from 'next/navigation'
import Link from "next/link"
import { Mail, Lock, Activity, ArrowRight } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [isLoading, setIsLoading] = useState(false)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    
    setTimeout(() => {
      localStorage.setItem("isAuthenticated", "true")
      localStorage.setItem("isNewUser", "false")
      router.push("/welcome")
    }, 1000)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary via-secondary to-accent flex items-center justify-center p-4 relative overflow-hidden">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-10 right-10 w-64 h-64 rounded-full bg-white/10 blur-3xl animate-pulse" />
        <div className="absolute bottom-20 left-10 w-48 h-48 rounded-full bg-white/10 blur-2xl animate-pulse delay-300" />
        <div className="absolute top-1/2 left-1/3 w-32 h-32 rounded-full bg-white/5 blur-xl animate-bounce" />
      </div>

      <Card className="w-full max-w-md p-8 space-y-6 animate-in fade-in zoom-in duration-700 shadow-2xl relative z-10">
        <div className="text-center space-y-2">
          <div className="w-16 h-16 rounded-3xl bg-gradient-to-br from-primary to-secondary flex items-center justify-center mx-auto shadow-xl">
            <Activity className="w-10 h-10 text-white" strokeWidth={2.5} />
          </div>
          <h1 className="text-3xl font-black text-foreground">Bienvenido a FitPulse</h1>
          <p className="text-muted-foreground font-semibold">Inicia sesion para continuar tu racha</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email" className="font-bold">Correo electronico</Label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                id="email"
                type="email"
                placeholder="tu@ejemplo.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="pl-10 h-12 rounded-xl border-2 font-semibold"
                required
              />
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="password" className="font-bold">Contrasena</Label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="pl-10 h-12 rounded-xl border-2 font-semibold"
                required
              />
            </div>
          </div>

          <Button
            type="submit"
            className="w-full h-12 rounded-xl font-black text-base bg-gradient-to-r from-primary to-secondary hover:opacity-90 shadow-lg"
            disabled={isLoading}
          >
            {isLoading ? "Iniciando sesion..." : "Iniciar sesion"}
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </form>

        <div className="text-center space-y-2">
          <Link href="/forgot-password" className="text-sm text-muted-foreground hover:text-primary font-bold">
            Olvidaste tu contrasena?
          </Link>
          <div className="text-sm text-muted-foreground font-semibold">
            No tienes cuenta?{" "}
            <Link href="/register" className="text-primary hover:underline font-black">
              Registrate aqui
            </Link>
          </div>
        </div>
      </Card>
    </div>
  )
}
