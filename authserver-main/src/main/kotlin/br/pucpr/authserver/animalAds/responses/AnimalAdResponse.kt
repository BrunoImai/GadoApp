package br.pucpr.authserver.animalAds.responses

import jakarta.validation.constraints.NotBlank

class AnimalAdResponse (

    @NotBlank
    val name : String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String,

    val id: Long,
    val batch : String,
    val weight : String? = null,
    val quantity: Int? = null,
    val priceType: String? = "Unid",
    val description: String? = null,
    var isFavorite: Boolean? = false

)