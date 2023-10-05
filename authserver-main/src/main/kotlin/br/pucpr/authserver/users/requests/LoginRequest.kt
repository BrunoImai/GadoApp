package br.pucpr.authserver.users.requests
import jakarta.validation.constraints.NotBlank

data class LoginRequest(
    @NotBlank
    var cellphone: String?,

    @NotBlank
    var password: String?,


)
