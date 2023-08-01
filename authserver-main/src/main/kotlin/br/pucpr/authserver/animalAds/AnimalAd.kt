package br.pucpr.authserver.animalAds

import br.pucpr.authserver.animalAds.responses.AnimalAdResponse
import br.pucpr.authserver.users.User
import br.pucpr.authserver.users.responses.UserResponse
import jakarta.persistence.*

@Entity
class AnimalAd (
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(nullable = false)
    val name: String = "",

    @Column( nullable = false)
    val batch: String ? = "0000",

    @Column
    val weight: String ? = null,

    @Column(nullable = false)
    val localization: String ,

    @Column
    val quantity: Int ? = null,

    @Column(nullable = false)
    val price: Float,

    @Column
    val priceType: String ? = "unid",

    @Column()
    val description: String ? = "",

    @Column()
    val status: String ? = "Analysis",

    @ManyToOne
    @JoinColumn(name = "owner_id")
    val owner: User,

    @ElementCollection
    val images: List<String>? = listOf<String>()

    )
{
    fun toResponse() = AnimalAdResponse( name, price, localization, id!!, batch!!, weight, quantity, priceType, description, false, images!!)
}