
package com.fn.example

fun hello(input: String) = when {
    input.isEmpty() -> ("Hello, world!")
        else -> ("Hello, ${input}")
}