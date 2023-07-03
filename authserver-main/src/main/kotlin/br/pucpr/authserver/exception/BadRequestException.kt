package br.pucpr.authserver.exception

import org.springframework.http.HttpStatus.BAD_REQUEST
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(BAD_REQUEST)
class BadRequestException(
    message: String = BAD_REQUEST.reasonPhrase,
    cause: Throwable? = null
): IllegalArgumentException(message, cause)