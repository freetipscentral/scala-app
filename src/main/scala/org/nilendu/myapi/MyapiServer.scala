package org.nilendu.myapi

import cats.effect.Async
import cats.syntax.all.*
import com.comcast.ip4s.*
import fs2.io.net.Network
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.ember.server.EmberServerBuilder
import org.http4s.implicits.*
import org.http4s.server.middleware.{CORS, Logger}

object MyapiServer:

  def run[F[_]: Async: Network]: F[Nothing] = {
    for {
      client <- EmberClientBuilder.default[F].build
      helloWorldAlg = HelloWorld.impl[F]
      jokeAlg = Jokes.impl[F](client)

      httpApp = (
        MyapiRoutes.helloWorldRoutes[F](helloWorldAlg) <+>
          MyapiRoutes.jokeRoutes[F](jokeAlg)
        ).orNotFound

      // Combine Service Routes into an HttpApp.
      // Can also be done via a Router if you
      // want to extract segments not checked
      // in the underlying routes.

      corsService = CORS.policy.withAllowOriginAll(httpApp)

      // With Middlewares in place
      finalHttpApp = Logger.httpApp(true, true)(corsService)

      _ <- 
        EmberServerBuilder.default[F]
          .withHost(ipv4"0.0.0.0")
          .withPort(port"8080")
          .withHttpApp(finalHttpApp)
          .build
    } yield ()
  }.useForever
