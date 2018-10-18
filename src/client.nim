import os, threadpool

echo("Chat application started")
if paramCount() == 0:
  quit("please specify the server address e.g. ./client localhost")

let serverAddress = paramStr(1)
echo("Connecting to ", serverAddress)

while true:
  let message = spawn stdin.readLine()
  echo("sending \"", ^message, "\"")
