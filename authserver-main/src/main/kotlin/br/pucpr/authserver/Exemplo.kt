package br.pucpr.authserver

import kotlin.math.sqrt

data class Resultado(
    val x1: Double,
    val x2: Double
)

fun baskhara(a: Double, b: Double, c: Double): br.pucpr.authserver.Resultado {
    if (a == 0.0) {
        throw IllegalArgumentException("A função deve ser de segundo grau!")
    }

    val delta = b * b - (4 * a * c)
    if (delta < 0.0) {
        throw IllegalArgumentException("A função não dá resultados reais!")
    }

    val x1 = (-b + sqrt(delta)) / (2 * a)
    val x2 = (-b - sqrt(delta)) / (2 * a)
    return br.pucpr.authserver.Resultado(x1, x2)
}
