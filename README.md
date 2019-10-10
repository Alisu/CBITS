# CBITS

Experiments for communication between (Pharo) images through socket.
The goal is to manage to send messages from an image got it executed on an other iamge and return to the initial image.

For now we execute this from a playground with the script:

```
mst := MessageSendThroughSocket new. 
mst sendBlockToExecute: '[1+1]'.
mst executeBlockInServer.

```
