package br.pucpr.authserver.users

import br.pucpr.authserver.animalAds.AnimalAd
import br.pucpr.authserver.animalAds.AnimalAdRepository
import br.pucpr.authserver.animalAds.requests.AnimalAdRequest
import br.pucpr.authserver.landAds.LandAd
import br.pucpr.authserver.landAds.LandAdRepository
import br.pucpr.authserver.landAds.requests.LandAdRequest
import br.pucpr.authserver.machineryAds.MachineryAd
import br.pucpr.authserver.machineryAds.MachineryAdRepository
import br.pucpr.authserver.machineryAds.requests.MachineryAdRequest
import br.pucpr.authserver.security.Jwt
import br.pucpr.authserver.users.requests.LoginRequest
import br.pucpr.authserver.users.requests.UserRequest
import br.pucpr.authserver.users.responses.LoginResponse
import com.sun.org.slf4j.internal.LoggerFactory

import org.slf4j.LoggerFactory
import org.springframework.data.domain.Sort
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class UsersService(
    val userRepository: UsersRepository,
    val rolesRepository: RolesRepository,
    val animalAdRepository: AnimalAdRepository,
    val machineryAdRepository: MachineryAdRepository,
    val landAdRepository: LandAdRepository,
    val jwt: Jwt,
) {
    fun save(req: UserRequest): User {
        val user = User(
            email = req.email!!,
            password = req.password!!,
            name = req.name!!,
            animalAds = ArrayList(),
            landAds = ArrayList(),
            machineryAds = ArrayList(),
        )
        val userRole = rolesRepository.findByName("USER")
            ?: throw IllegalStateException("Role 'USER' not found!")

        user.roles.add(userRole)
        return userRepository.save(user)
    }

    fun createAnimalAd(req: AnimalAdRequest, ownerId: Long): AnimalAd {

        val owner =  userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")


        val animalAd = AnimalAd(
            name = req.name,
            weight = req.weight,
            localization = req.localization,
            quantity = req.quantity,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner

        )

        owner.animalAds.add(animalAd)

        return animalAdRepository.save(animalAd)
    }

    fun createLandAd(req: LandAdRequest, ownerId: Long): LandAd {

        val owner =  userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")


        val landAd = LandAd(
            name = req.name,
            area = req.area,
            localization = req.localization,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            batch = "0000"
        )

        owner.landAds.add(landAd)

        return landAdRepository.save(landAd)
    }

    fun createMachineryAd(req: MachineryAdRequest, ownerId: Long): MachineryAd {

        val owner =  userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")


        val machineryAd = MachineryAd(
            name = req.name,
            quantity = req.quantity,
            localization = req.localization,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner

        )

        owner.machineryAds.add(machineryAd)

        return machineryAdRepository.save(machineryAd)
    }


    fun getById(id: Long) = userRepository.findByIdOrNull(id)

    fun findAll(role: String?): List<User> =
        if (role == null) userRepository.findAll(Sort.by("name"))
        else userRepository.findAllByRole(role)

    fun findAllAnimalAd(): List<AnimalAd> = animalAdRepository.findAll()

    fun login(credentials: LoginRequest): LoginResponse? {
        val user = userRepository.findByEmail(credentials.email!!) ?: return null
        if (user.password != credentials.password) return null
        log.info("User logged in. id={} name={}", user.id, user.name)
        return LoginResponse(
            token = jwt.createToken(user),
            user.toResponse()
        )
    }

    fun delete(id: Long): Boolean {
        val user = userRepository.findByIdOrNull(id) ?: return false
        if (user.roles.any { it.name == "ADMIN" }) {
            val count = userRepository.findAllByRole("ADMIN").size
            if (count == 1)  throw br.pucpr.authserver.exception.BadRequestException("Cannot delete the last system admin!")
        }
        log.warn("User deleted. id={} name={}", user.id, user.name)
        userRepository.delete(user)
        return true
    }

    companion object {
        val log = LoggerFactory.getLogger(UsersService::class.java)
    }
}