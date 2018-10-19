import os, threadpool, asyncdispatch, asyncnet, protocol

echo("Chat application started")
if paramCount() == 0:
  quit("please specify the server address e.g. ./client localhost")

proc connect(socket: AsyncSocket, serverAddress: string) {.async.} =
  echo("Connecting to ", serverAddress)
  await socket.connect(serverAddress, 7687.Port)
  echo("Connected")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said ", parsed.message)

let serverAddress = paramStr(1)
let socket = newAsyncSocket()

asyncCheck connect(socket, serverAddress)

var messageFlowVar = spawn stdin.readLine()
while true:
  if messageFlowVar.isReady():
    let message = createMessage("Anonymous", ^messageFlowVar)
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()

  asyncdispatch.poll()
