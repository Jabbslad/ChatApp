import asyncdispatch, asyncnet

type
  Client = ref object
    socket: AsyncSocket
    netAddress: string
    id: int
    connected: bool

  Server = ref object
    socket: AsyncSocket
    clients: seq[Client]

proc newServer(): Server =
  Server(socket: newAsyncSocket(), clients: @[])

proc loop(server: Server, port = 7687) {.async.} =
  server.socket.bindAddr(port.Port)
  server.socket.listen()
  while true:
    let (netAddr, clientSocket) = await server.socket.acceptAddr()
    echo("Accepted connection from ", netAddr)
    let client = Client(
      socket: clientSocket,
      netAddress: netAddr,
      id: server.clients.len,
      connected: true
    )
    server.clients.add(client) 

var server = newServer()

waitFor loop(server)