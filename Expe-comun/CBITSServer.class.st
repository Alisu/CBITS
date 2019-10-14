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
CBITSServer >> executeBlockSer [
	
	|materializedBlock|
	materializedBlock := FLMaterializer materializeFromByteArray: (serverStream upTo: Character cr) asByteArray.
	
	results := materializedBlock value.
]

{ #category : #tests }
CBITSServer >> executeBlockStr [
	
	results := OpalCompiler new
		evaluate: (serverStream upTo: Character cr) , ' value'
]

{ #category : #'as yet unclassified' }
CBITSServer >> executeMessage [
	
	| selector receiver arguments |
	selector := (serverStream upTo: Character cr) asSymbol.
	receiver := FLMaterializer materializeFromByteArray: (serverStream upTo: Character cr) asByteArray.
	arguments := FLMaterializer materializeFromByteArray: (serverStream upTo: Character cr) asByteArray.
 
	results := receiver perform: selector withArguments: arguments.
]

{ #category : #'as yet unclassified' }
CBITSServer >> handleIncomingInstruction [
	|instruction|
	instruction := serverStream upTo: Character cr.
	(instruction = 'exec block str') ifTrue: [ ^self executeBlockStr ].
	(instruction = 'exec block ser') ifTrue: [ ^self executeBlockSer ].
	(instruction = 'exec msg') ifTrue: [ ^self executeMessage ].
	^self error: 'Instruction: ', instruction, ' not understood'
	
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
	[self handleIncomingInstruction.] on: Error do: [:error| results := (FLSerializer serializeToByteArray: error) ].
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

			serverStream nextPutAll: 'result' , String cr ;
			nextPutAll: (FLSerializer serializeToByteArray:  results);
			nextPutAll: String cr;
			flush.
		

]
