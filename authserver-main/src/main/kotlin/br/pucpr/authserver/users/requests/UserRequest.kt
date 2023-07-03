package br.pucpr.authserver.users.requests

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class UserRequest(
    @field:NotBlank
    val name: String?,

    @field:Email
    val email: String?,

    @field:Size(min = 8, max = 50)
    val password: String?
)
