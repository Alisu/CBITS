"
mst := CBITSClient new. 
mst sendBlockToExecute: '[1+1]'.

"
Class {
	#name : #CBITSClient,
	#superclass : #Object,
	#instVars : [
		'clientStream',
		'messages',
		'results'
	],
	#category : #'Expe-comun'
}

{ #category : #'instance creation' }
CBITSClient class >> new: anIPAdress on: aPort [
	
]

{ #category : #initialization }
CBITSClient >> initialize [
	| clientSocket |

	clientSocket := Socket newTCP.
	clientSocket connectTo: #[127 0 0 1] port: 40001.
	clientSocket waitForConnectionFor: 1.
	self assert: clientSocket isConnected.

	clientStream := SocketStream on: clientSocket.

]

{ #category : #tests }
CBITSClient >> messageReceive [
	
	^((clientStream upTo: $\) = 'result')
		ifTrue: [ results := FLMaterializer materializeFromByteArray: (clientStream upTo: $\) asByteArray. ]
		ifFalse: [ self error: 'Not implemented yet' ]
	
]

{ #category : #accessing }
CBITSClient >> messages [
	^ messages
]

{ #category : #accessing }
CBITSClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
CBITSClient >> results [
	^ results
]

{ #category : #accessing }
CBITSClient >> results: anObject [
	results := anObject
]

{ #category : #tests }
CBITSClient >> resultsReceiveds [
	
	^(clientStream next: 100 into: (String new: 100) startingAt: 1) 
	
]

{ #category : #tests }
CBITSClient >> sendBlockToEvaluate: aBlock [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec block str', '\', aBlock asString, '\'; flush.
	"clientStream waitForData."
	self messageReceive.



]

{ #category : #tests }
CBITSClient >> sendMessageToExecute: aSelector from: aReceiver withArgs: aCollection [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream
		nextPutAll: 
		'exec msg',  '\',
		aSelector, String cr, '\',
		(FLSerializer serializeToByteArray:aReceiver), '\',
		(FLSerializer serializeToByteArray: aCollection), '\';
		flush.
		self messageReceive.
]

{ #category : #tests }
CBITSClient >> sendSerializedBlockToEvaluate: aBlock [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:
	'exec block ser',  '\',
	(FLSerializer serializeToByteArray: aBlock asContext), '\';
	flush.	
	"clientStream waitForData."
	self messageReceive.



]
