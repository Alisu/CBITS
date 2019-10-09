Class {
	#name : #MessageSendThroughSocketTest,
	#superclass : #TestCase,
	#category : #'Expe-comun'
}

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendBlock [

	| mst |
	mst := MessageSendThroughSocket new. 
	mst sendBlockToExecute: '[1+1]'.
	mst executeBlockInServer.
	self assert: mst results equals: 2.
]
