class Nave {
    const velocidadMaxima = 100000

    var velocidad

    var direccion

    var combustible

    method prepararViaje()

    method escapar()

    method avisar()

    method acelerar(cuanto) {
        velocidad = (velocidad + cuanto).min(velocidadMaxima)
    }

    method desacelerar(cuanto) {
        velocidad = (velocidad - cuanto).max(0)
    }

    method irHaciaElSol() {
        direccion = 10
    }

    method escaparDelSol() {
        direccion = -10
    }

    method ponerseParaleloAlSol() {
        direccion = 0
    }

    method acercarseUnPocoAlSol() {
        direccion = (direccion + 1).min(10)
    }

    method alejarseUnPocoDelSol() {
        direccion = (direccion - 1).max(-10)
    }

    method cargarCombustible(unaCantidad) {
        combustible += unaCantidad
    }

    method descargarCombustible(unaCantidad) {
        combustible = (combustible - unaCantidad).max(0)
    }

    method accionAdicional() {
        self.acelerar(5000)
        self.cargarCombustible(30000)
    }

    method esTranquila() {
        return combustible == 4000 && velocidad <= 12000
    }

    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }

    method estaDeRelajo() {
        return self.esTranquila()
    }
}

class NaveBaliza inherits Nave {
    const colorInicial

    var color = colorInicial

    method color() = color

    method cambiarColorDeBaliza(colorNuevo) {
        color = colorNuevo
    }

    override method prepararViaje() {
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
        self.accionAdicional()
    }

    override method esTranquila() {
        return super() && !(color == "rojo")
    }

    override method escapar() {
        self.irHaciaElSol()
    }

    override method avisar() {
        self.cambiarColorDeBaliza("rojo")
    }

    method tienePocaActividad() {
        return colorInicial == color
    }

    override method estaDeRelajo() {
        return super() && self.tienePocaActividad()
    }
}

class NaveDePasajeros inherits Nave {
    const cantPasajeros

    var racionesDeComida

    var comidaServida = 0

    var racionesDeBebida

    method cantPasajeros() = cantPasajeros

    method cargarComida(unaCantidad) {
        racionesDeComida = racionesDeComida + unaCantidad
        comidaServida += unaCantidad
    }

    method descargarComida(unaCantidad) {
        racionesDeComida = (racionesDeComida - unaCantidad).max(0)

    }

    method cargarBebida(unaCantidad) {
        racionesDeBebida = racionesDeBebida + unaCantidad
    }

    method descargarBebida(unaCantidad) {
        racionesDeBebida = (racionesDeBebida - unaCantidad).max(0)
    }

    override method prepararViaje() {
        self.cargarComida(cantPasajeros * 4)
        self.cargarBebida(cantPasajeros * 6)
        self.acercarseUnPocoAlSol()
        self.accionAdicional()
    }

    override method escapar() {
        self.acelerar(velocidad * 2)
    }

    override method avisar() {
        self.cargarComida(cantPasajeros)
        self.cargarBebida(cantPasajeros * 2)
    }

    method tienePocaActividad() {
        return comidaServida <= 50
    }
}

class NaveDeCombate inherits Nave {
    var invisible 

    var misilesDesplegados

    const mensajesEmitidos = []

    method ponerseVisible() {
        invisible = false
    }

    method ponerseInvisible() {
        invisible = true
    }

    method estaInvisible() = invisible

    method desplegarMisiles() {
        misilesDesplegados = true
    }

    method replegarMisiles() {
        misilesDesplegados = false
    }

    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(mensaje) {
        mensajesEmitidos.add(mensaje)
    }

    method mensajesEmitidos() = mensajesEmitidos

    method primerMensajeEmitido() = mensajesEmitidos.first()

    method ultimoMensajeEmitido() = mensajesEmitidos.last()

    method esEscueta() = mensajesEmitidos.any({m => !m.length() > 30})

    method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

    override method prepararViaje() {
        self.ponerseVisible()
        self.replegarMisiles()
        self.emitioMensaje("Saliendo en misión")
        self.accionAdicional()
        self.acelerar(15000)
    }

    override method esTranquila() {
        return super() && !misilesDesplegados
    }

    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }

    override method avisar() {
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NaveDePasajeros {
    var tienePreparadoQuirofanos

    method tienePreparadoQuirofanos() = tienePreparadoQuirofanos

    override method esTranquila() {
        return super() && !tienePreparadoQuirofanos
    }

    override method recibirAmenaza() {
        super()
        tienePreparadoQuirofanos = true 
    }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
    override method esTranquila() {
        return super() && !invisible
    }

    override method recibirAmenaza() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}