package br.pucpr.authserver.landAds

import br.pucpr.authserver.animalAds.responses.AnimalAdResponse
import br.pucpr.authserver.landAds.response.LandAdResponse
import br.pucpr.authserver.users.User
import jakarta.persistence.*

@Entity
@Table(name = "land_ad")
class LandAd (
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(nullable = false)
    val name: String = "",

    @Column(nullable = false)
    val batch: String ? = "0000",

    @Column
    val localization: String ? = null,

    @Column
    val area: String ? = null,

    @Column
    val priceType: String ? = "unid",

    @Column(nullable = false)
    val price: Float,

    @Column()
    val description: String ? = "",

    @ManyToOne
    @JoinColumn(name = "owner_id")
    val owner: User,

    @ElementCollection
    val images: List<String>? = listOf<String>()

    ){
    fun toResponse() = LandAdResponse( name, price, localization, id!!, batch!!, area, priceType, description,false ,images!!)

}
