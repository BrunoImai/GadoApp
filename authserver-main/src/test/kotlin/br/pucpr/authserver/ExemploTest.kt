package br.pucpr.authserver

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows

class BaskharaTest {
    @Test
    fun `Calcula as raizes de maneira correta ao fornecer a b e c`() {
        val resultado = br.pucpr.authserver.baskhara(1.0, 12.0, -13.0)
        assert(resultado.x1 == 1.0)
        assert(resultado.x2 == -13.0)
    }

    @Test
    fun `Calcula as raizes de maneira correta ao fornecer a b e c com delta 0`() {
        val resultado = br.pucpr.authserver.baskhara(1.0, 4.0, 4.0)
        assert(resultado.x1 == -2.0)
        assert(resultado.x2 == -2.0)
    }

    @Test
    fun `Da erro de IllegalArgumentException ao fornecer a b e c com delta negativo`() {
        assertThrows<IllegalArgumentException> {
            br.pucpr.authserver.baskhara(4.0, 1.0, 1.0)
        }
    }

    @Test
    fun `Da erro de illegal argument exception ao fornecer uma função de grau menor`() {
        assertThrows<IllegalArgumentException> {
            br.pucpr.authserver.baskhara(0.0, 1.0, 1.0)
        }
    }
}
