package br.pucpr.authserver.advertising

import br.pucpr.authserver.advertising.response.AdvertisingAdResponse
import jakarta.persistence.*

@Entity
@Table(name = "advertising")
class AdvertisingAd (
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(nullable = false)
    val name: String = "",

    @Column()
    val description: String ? = "",

    @ElementCollection
    var images: List<String>? = listOf<String>()

) {
    fun toResponse() = AdvertisingAdResponse( name, id!!, description,  images!!)
}