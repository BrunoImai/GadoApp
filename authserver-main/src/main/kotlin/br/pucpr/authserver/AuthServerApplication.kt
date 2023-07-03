package br.pucpr.authserver

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.runApplication

@SpringBootApplication
@ConfigurationPropertiesScan
class AuthServerApplication

fun main(args: Array<String>) {
    runApplication<br.pucpr.authserver.AuthServerApplication>(*args)
}
