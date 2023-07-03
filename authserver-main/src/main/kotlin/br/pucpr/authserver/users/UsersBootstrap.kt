package br.pucpr.authserver.users

import br.pucpr.authserver.animalAds.AnimalAd
import br.pucpr.authserver.landAds.LandAd
import br.pucpr.authserver.machineryAds.MachineryAd
import org.springframework.context.ApplicationListener
import org.springframework.context.event.ContextRefreshedEvent
import org.springframework.stereotype.Component

@Component
class UsersBootstrap(
    val rolesRepository: RolesRepository,
    val userRepository: UsersRepository
) : ApplicationListener<ContextRefreshedEvent> {
    override fun onApplicationEvent(event: ContextRefreshedEvent) {
        val adminRole = Role(name = "ADMIN")
        if (rolesRepository.count() == 0L) {
            rolesRepository.save(adminRole)
            rolesRepository.save(Role(name = "USER"))
        }
        if (userRepository.count() == 0L) {
            val admin = User(
                email = "admin@authserver.com",
                password = "admin",
                name = "Auth Server Administrator",
                animalAds = ArrayList(),
                landAds = ArrayList(),
                machineryAds = ArrayList(),
            )
            admin.roles.add(adminRole)
            userRepository.save(admin)
        }
    }
}