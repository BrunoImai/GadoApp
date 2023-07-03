package br.pucpr.authserver.users

import kotlin.random.Random

fun randomString(
    length: Int = 10, allowedChars: List<Char> =
        ('A'..'Z') + ('a'..'z') + ('0'..'9')
) = (1..length)
    .map { allowedChars.random() }
    .joinToString()

object Stubs {
    fun userStub(
        id: Long? = Random.nextLong(1, 1000),
        roles: List<String> = listOf("USER")
    ): User {
        val name = "user-${id ?: "new"}"
        return User(
            id = id,
            name = name,
            email = "$name@email.com",
            password = randomString(),
            roles = roles
                .mapIndexed { i, it -> Role(i.toLong(), it) }
                .toMutableSet()
        )
    }
}