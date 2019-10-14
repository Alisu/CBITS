Class {
	#name : #MessageSendThroughSocketTest,
	#superclass : #TestCase,
	#instVars : [
		'server',
		'client'
	],
	#category : #'Expe-comun'
}

{ #category : #running }
MessageSendThroughSocketTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	[server := CBITSServer newOnPort: 40001].
	[client := CBITSClient new]. 

]

{ #category : #running }
MessageSendThroughSocketTest >> tearDown [
	"Hooks that subclasses may override to define the fixture of test."
	server close.
	client close.

]

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendBlockToEvaluate [

	client sendBlockToEvaluate: [1+1].
	self assert: server results equals: 2.
	self assert: client results equals: 2. 
]

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendMessageToExecute [

	client sendMessageToExecute: #x:y: from: Point withArgs: #(1 1).
	self assert: server results equals: 2.
	self assert: client results equals: 2. 
]
