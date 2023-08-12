package br.pucpr.authserver.advertising.requests

import jakarta.validation.constraints.NotBlank

data class AdvertisingRequest(
    @NotBlank
    val name: String,
    val description: String? = null,
    val images: List<String>? = listOf<String>(),
)
