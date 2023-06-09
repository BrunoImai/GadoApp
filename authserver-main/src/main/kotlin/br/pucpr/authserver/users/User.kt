package br.pucpr.authserver.users

import br.pucpr.authserver.users.responses.UserResponse
import br.pucpr.authserver.animalAds.AnimalAd
import br.pucpr.authserver.landAds.LandAd
import br.pucpr.authserver.machineryAds.MachineryAd
import jakarta.persistence.*
import jakarta.validation.constraints.Email

@Entity
@Table(name = "TblUser")
class User(
    @Id @GeneratedValue
    var id: Long? = null,

    @Email
    @Column(unique = true, nullable = false)
    var email: String,

    @Column(length = 50)
    var password: String,

    @Column(nullable = false)
    var name: String = "",

    @ManyToMany
    @JoinTable(
        name = "UserRole",
        joinColumns = [JoinColumn(name = "idUser")],
        inverseJoinColumns = [JoinColumn(name = "idRole")]
    )
    val roles: MutableSet<Role> = mutableSetOf(),


    @OneToMany(mappedBy = "owner", cascade = [CascadeType.ALL], orphanRemoval = true)
    val animalAds : MutableList<AnimalAd>,

    @OneToMany(mappedBy = "owner", cascade = [CascadeType.ALL], orphanRemoval = true)
    val machineryAds : MutableList<MachineryAd>,

    @OneToMany(mappedBy = "owner", cascade = [CascadeType.ALL], orphanRemoval = true)
    val landAds : MutableList<LandAd>,
    ) {
    fun toResponse() = UserResponse(id!!, name, email)
}