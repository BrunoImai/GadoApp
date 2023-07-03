package br.pucpr.authserver.users

import jakarta.persistence.*

@Entity
class Role(
    @Id @GeneratedValue
    val id: Long? = null,

    @Column(unique = true, nullable = false)
    val name: String = "",

    @ManyToMany(mappedBy = "roles")
    val users: MutableSet<User> = mutableSetOf()
)