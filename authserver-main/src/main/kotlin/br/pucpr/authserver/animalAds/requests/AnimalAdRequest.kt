package br.pucpr.authserver.animalAds.requests

import jakarta.validation.constraints.NotBlank

data class AnimalAdRequest (
    @NotBlank
    val name : String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String,

    val weight : String? = null,
    val quantity: Int? = null,
    val priceType: String? = "Unid",
    val description: String? = null,
    val images: List<String>? = listOf<String>()
)