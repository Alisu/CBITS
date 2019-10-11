Class {
	#name : #MessageSendThroughSocketTest,
	#superclass : #TestCase,
	#category : #'Expe-comun'
}

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendBlock [

	| server client |
	server := CBITSServer new. 
	client := CBITSClient new.
	client sendBlockToExecute: '[1+1]'.
	self assert: server results equals: 2.
	self assert: client results equals: 2. 
]
