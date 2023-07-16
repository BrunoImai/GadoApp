package br.pucpr.authserver.app

import br.pucpr.authserver.animalAds.AnimalAdRepository
import br.pucpr.authserver.landAds.LandAdRepository
import br.pucpr.authserver.machineryAds.MachineryAdRepository
import br.pucpr.authserver.security.Jwt
import br.pucpr.authserver.users.RolesRepository
import br.pucpr.authserver.users.UsersRepository
import org.springframework.stereotype.Service

@Service
class AppService(
    val userRepository: UsersRepository,
    val rolesRepository: RolesRepository,
    val animalAdRepository: AnimalAdRepository,
    val machineryAdRepository: MachineryAdRepository,
    val landAdRepository: LandAdRepository,
    val jwt: Jwt,
) {
}