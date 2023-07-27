package br.pucpr.authserver.machineryAds.requests

import jakarta.validation.constraints.NotBlank

data class MachineryAdRequest (
    @NotBlank
    val name : String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String,

    val quantity: Int? = 1,
    val priceType: String? = "Unid",
    val description: String? = null,
    val images: List<String>? = listOf<String>()
)