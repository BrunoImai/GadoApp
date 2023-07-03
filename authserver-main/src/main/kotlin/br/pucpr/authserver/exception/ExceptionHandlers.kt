package br.pucpr.authserver.exception

import org.springframework.http.ResponseEntity
import org.springframework.validation.FieldError
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler

@ControllerAdvice
class ExceptionHandlers {
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationException(ex: MethodArgumentNotValidException) =
        ex.bindingResult.allErrors
            .joinToString("\n") { "'${(it as FieldError).field}': ${it.defaultMessage}"}
            .let { ResponseEntity.badRequest().body(it) }
}