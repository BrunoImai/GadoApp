//package br.pucpr.authserver.users
//
//import br.pucpr.authserver.exception.BadRequestException
//import br.pucpr.authserver.security.Jwt
//import br.pucpr.authserver.users.Stubs.userStub
//import io.kotest.assertions.throwables.shouldThrow
//import io.kotest.matchers.shouldBe
//import io.kotest.matchers.throwable.shouldHaveMessage
//import io.mockk.every
//import io.mockk.justRun
//import io.mockk.mockk
//import org.junit.jupiter.api.Test
//import org.springframework.data.repository.findByIdOrNull
//
//internal class UsersServiceTest {
//    private val usersRepositoryMock = mockk<UsersRepository>()
//    private val rolesRepositoryMock = mockk<RolesRepository>()
//    private val jwtMock = mockk<Jwt>()
//
//    private val service = UsersService(usersRepositoryMock, rolesRepositoryMock, jwtMock)
//
//    @Test
//    fun `Delete should return false if the user does not exists`() {
//        every { usersRepositoryMock.findByIdOrNull(1) } returns null
//        service.delete(1) shouldBe false
//    }
//
//    @Test
//    fun `Delete must return true if the user is deleted`() {
//        val user = userStub()
//        every { usersRepositoryMock.findByIdOrNull(1) } returns user
//        justRun { usersRepositoryMock.delete(user) }
//        service.delete(1) shouldBe true
//    }
//
//    @Test
//    fun `Delete should throw a BadRequestException if the user is the last admin`() {
//        every { usersRepositoryMock.findByIdOrNull(1) } returns userStub(roles = listOf("ADMIN"))
//        every {
//            usersRepositoryMock.findAllByRole("ADMIN")
//        } returns listOf(userStub(roles = listOf("ADMIN")))
//
//        shouldThrow<br.pucpr.authserver.exception.BadRequestException> {
//            service.delete(1)
//        } shouldHaveMessage "Cannot delete the last system admin!"
//    }
//}