Class {
	#name : #CBITSServer,
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
CBITSServer >> executeBlockInServer [

	((serverStream upTo: Character cr) = 'exec block')
		ifTrue: [ results := OpalCompiler new
				evaluate: (serverStream upTo: Character cr), ' value'.
			clientStream
				nextPutAll: 'result' , String cr , results asString , String cr;
				flush ]
		ifFalse: [ self error: 'Not done yet' ]
]

{ #category : #initialization }
CBITSServer >> initialize [
	| listener serverSocket |
	listener := Socket newTCP.
	
	[listener listenOn: 40001 backlogSize: 4.

	serverSocket := listener waitForAcceptFor: 1.
	self assert: serverSocket isConnected.
	] ensure:[listener destroy].

	serverStream := SocketStream on: serverSocket.
]

{ #category : #tests }
CBITSServer >> messageReceive [
	
	^(serverStream next: 100 into: (String new: 100) startingAt: 1) 
	
]

{ #category : #accessing }
CBITSServer >> messages [
	^ messages
]

{ #category : #accessing }
CBITSServer >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
CBITSServer >> results [
	^ results
]

{ #category : #accessing }
CBITSServer >> results: anObject [
	results := anObject
]

{ #category : #tests }
CBITSServer >> sendBlockToExecute: aBlock [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec block', String cr, aBlock asString, String cr; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.


]

{ #category : #tests }
CBITSServer >> sendMessageToExecute: aSelector from: aReceiver withArgs: aCollection [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec', String cr, aSelector; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.

]
