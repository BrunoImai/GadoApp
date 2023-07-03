package br.pucpr.authserver.users

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface UsersRepository : JpaRepository<User, Long> {
    @Query(
        value = "select distinct u from User u" +
                " join u.roles r" +
                " where r.name = :role" +
                " order by u.name"
    )
    fun findAllByRole(role: String): List<User>

    fun findByEmail(email: String): User?
}