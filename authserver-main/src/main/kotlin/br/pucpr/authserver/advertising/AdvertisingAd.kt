package br.pucpr.authserver.advertising

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

)