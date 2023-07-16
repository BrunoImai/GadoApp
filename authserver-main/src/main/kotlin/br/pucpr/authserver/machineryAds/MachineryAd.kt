package br.pucpr.authserver.machineryAds

import br.pucpr.authserver.machineryAds.response.MachineryAdResponse
import br.pucpr.authserver.users.User
import jakarta.persistence.*

@Entity
class MachineryAd (
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(nullable = false)
    val name: String = "",

    @Column( nullable = false)
    val batch: String ? = "1000",

    @Column
    val localization: String ? = null,

    @Column
    val quantity: Int ? = 1,

    @Column
    val priceType: String ? = "unid",

    @Column(nullable = false)
    val price: Float,

    @Column()
    val description: String ? = "",

    @Column()
    val status: String ? = "",

    @Column()
    val isFavorite: Boolean ? = false,

    @ManyToOne
    @JoinColumn(name = "owner_id")
    val owner: User,

    @ElementCollection
    val images: Set<String> ? = setOf(),

    ) {
    fun toResponse() = MachineryAdResponse( name, price, localization, id!! ,batch!! ,quantity, priceType, description, isFavorite!!)

}