package br.pucpr.authserver.landAds.requests

import jakarta.validation.constraints.NotBlank

data class LandAdRequest(
    @NotBlank
    val name : String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String,

    val area : String? = null,
    val priceType: String? = "Unid",
    val description: String? = null,
)
