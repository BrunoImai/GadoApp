package br.pucpr.authserver.advertising.response

import jakarta.validation.constraints.NotBlank

data class AdvertisingAdResponse(
    @NotBlank
    val name : String,
    val id: Long,
    val description: String? = null,
    val images: List<String>? = listOf<String>(),
)
