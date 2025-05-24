package org.nilendu.myapi

import cats.effect.{IO, IOApp}

object Main extends IOApp.Simple:
  val run = MyapiServer.run[IO]
