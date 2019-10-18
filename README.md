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
In order to send messages in a seamless way we use proxies.
This way you can install your proxy that will intercept your message and send it to the other image thank to CBITShandler.

We can also send blocks to be executed:
```
mst := CBITSClient new. 
mst sendBlock: [Smalltalk globals at: #Object].
```
or:
```
[Smalltalk globals at: #Object] valueInAnotherImage.
```

# Serialization

We rely on Fuel/STON to serialize and materialize arguments, receiver and co...
It means we expect the classes to be present on the other side.

FUEL => Allows to serialize about anything (Context, non indexable etc...) but no compatibility between images versions
STON => Compatible between version (at least 6/7/8) but cannot serialize non-indexable objects, context etc...

TODO:

- Having an error handling.
- Asking for an AST to be executed.
- Handling arguments in block and non-clean block


