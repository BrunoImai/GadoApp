package br.pucpr.authserver.landAds.response

import jakarta.validation.constraints.NotBlank

data class LandAdResponse (
    @NotBlank
    val name : String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String?,
    val batch: String ? = "0000",
    val area : String? = null,
    val priceType: String? = "Unid",
    val description: String? = null,

    )