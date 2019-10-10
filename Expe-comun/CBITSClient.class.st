"
mst := CBITSClient new. 
mst sendBlockToExecute: '[1+1]'.
mst messageReceive.
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
	
	^(clientStream next: 100 into: (String new: 100) startingAt: 1) 
	
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
CBITSClient >> sendBlockToExecute: aBlock [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec block', String cr, aBlock asString, String cr; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.


]

{ #category : #tests }
CBITSClient >> sendMessageToExecute: aSelector from: aReceiver withArgs: aCollection [
	"Ensure that #next:into: will function properly when the connection is closed"

	clientStream nextPutAll:'exec', String cr, aSelector; flush.
	[(Delay forMilliseconds: 100) wait.
	clientStream close] fork.

]
