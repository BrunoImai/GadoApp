package br.pucpr.authserver.machineryAds.response

import jakarta.validation.constraints.NotBlank
import org.hibernate.engine.jdbc.batch.spi.Batch

data class MachineryAdResponse(

    @NotBlank
    val name: String,

    @NotBlank
    val price: Float,

    @NotBlank
    val localization: String?,

    val id: Long,
    val batch: String?,
    val quantity: Int? = 1,
    val priceType: String? = "Unid",
    val description: String? = null,
    var isFavorite: Boolean = false,
    val images: List<String>? = listOf<String>(),
    var status: String? = "Em Análise",
    val ownerId: Long
)