# CBITS

Experiments for communication between (Pharo) images through socket.
The goal is to manage to send messages from an image to another. Then, have the messages got executed on an other image and finally return "the result" to the initial image.

Note: the server and the client can be united in only one entity but it's easier for me and to debug to have both separated.

__Server:__
CBITSServer is the one in charge of receptionning your messages, to execute them, and return "the result".

```
mst := CBITSServer newOnPort: 40001.
```
__Client:__
CBITSClient is the one asling for message to be executed on a server (installed in another image).

```
mst := CBITSClient new. 
mst sendMessageToExecute: #x:y: from: Point withArgs: #(1 1).
```

We can also send blocks to be executed:
```
mst := CBITSClient new. 
mst sendBlock: [Smalltalk globals at: #Object].
```

We rely on Fuel to serialize and materialize arguments, receiver and co...
It means we expect the classes to be present on the other side.

TODO:
-Having an error handling.
-Asking for an AST to be executed.
-Handling arguments in block and non-clean block
-Extension methods on block.

```
[Smalltalk globals at: #Object] computeElsewhere.
```
