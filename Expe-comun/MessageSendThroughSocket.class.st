Class {
	#name : #MessageSendThroughSocket,
	#superclass : #Object,
	#instVars : [
		'clientStream',
		'serverStream',
		'messages',
		'results'
	],
	#category : #'Expe-comun'
}

{ #category : #tests }
MessageSendThroughSocket >> executeBlockInServer [

	((serverStream upTo: Character cr) = 'exec block')
		ifTrue: [ results := OpalCompiler new
				evaluate: (serverStream upTo: Character cr), ' value'.
			clientStream
				nextPutAll: 'result' , String cr , results asString , String cr;
				flush ]
		ifFalse: [ self error: 'Not done yet' ]
]

{ #category : #initialization }
MessageSendThroughSocket >> initialize [
	| listener clientSocket serverSocket |
	listener := Socket newTCP.
	[listener listenOn: 0 backlogSize: 4.

	clientSocket := Socket newTCP.
	clientSocket connectTo: #[127 0 0 1] port: listener localPort.
	clientSocket waitForConnectionFor: 1.
	self assert: clientSocket isConnected.

	serverSocket := listener waitForAcceptFor: 1.
	self assert: serverSocket isConnected.
	] ensure:[listener destroy].

	clientStream := SocketStream on: clientSocket.
	serverStream := SocketStream on: serverSocket.
]

{ #category : #tests }
MessageSendThroughSocket >> messageReceive [
	
	^(serverStream next: 100 into: (String new: 100) startingAt: 1) 
	
]

{ #category : #accessing }
MessageSendThroughSocket >> messages [
	^ messages
]

{ #category : #accessing }
MessageSendThroughSocket >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
MessageSendThroughSocket >> results [
	^ results
]

{ #category : #accessing }
MessageSendThroughSocket >> results: anObject [
	results := anObject
]

{ #category : #tests }
MessageSendThroughSocket >> sendBlockToExecute: aBlock [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec block', String cr, aBlock asString, String cr; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.


]

{ #category : #tests }
MessageSendThroughSocket >> sendMessageToExecute: aSelector from: aReceiver withArgs: aCollection [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec', String cr, aSelector; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.

]
