"
mst := CBITSServer new.
"
Class {
	#name : #CBITSServer,
	#superclass : #Object,
	#instVars : [
		'serverStream',
		'messages',
		'results'
	],
	#category : #'Expe-comun'
}

{ #category : #'instance creation' }
CBITSServer class >> newOnPort: aPortNumber [

	^ self new initializeOnPort: aPortNumber.
]

{ #category : #tests }
CBITSServer >> executeBlock [

	((serverStream upTo: Character cr) = 'exec block')
		ifTrue: [ results := OpalCompiler new
				evaluate: (serverStream upTo: Character cr), ' value'. ]
		ifFalse: [ self error: 'Not implemented yet' ]
]

{ #category : #initialization }
CBITSServer >> initialize [
	"| listener serverSocket |
	listener := Socket newTCP.
	
	listener listenOn: 40001 backlogSize: 4.

	serverSocket := listener waitForAcceptFor: 90.
	self assert: serverSocket isConnected.
	] ensure:[listener destroy].

	serverStream := SocketStream on: serverSocket.
	self 	executeBlock.
	self sendResults."
]

{ #category : #initialization }
CBITSServer >> initializeOnPort: aPort [
	| listener serverSocket |
	listener := Socket newTCP.
	
	listener listenOn: aPort backlogSize: 4.

	serverSocket := listener waitForAcceptFor: 90.
	self assert: serverSocket isConnected.
	"] ensure:[listener destroy]."

	serverStream := SocketStream on: serverSocket.
	self 	executeBlock.
	self sendResults.
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
CBITSServer >> sendResults [

			serverStream
				nextPutAll: 'result' , String cr , results asString , String cr;
				flush.

]
