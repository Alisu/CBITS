Class {
	#name : #MessageSendThroughSocketTest,
	#superclass : #TestCase,
	#instVars : [
		'server',
		'client',
		'handler'
	],
	#category : #'Expe-comun'
}

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> newproxy: target [
	^ AvForwardingProxy target: target handler: handler
]

{ #category : #running }
MessageSendThroughSocketTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	"[server := CBITSServer newOnPort: 40001]".
	"client := CBITSClient new."
	handler := CBITSHandler new.
	"handler client:	 client."
	

]

{ #category : #running }
MessageSendThroughSocketTest >> tearDown [
	"Hooks that subclasses may override to define the fixture of test."
	"server close."
	"client close."

]

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendBlockToEvaluate [

	client sendBlockToEvaluate: [1+1].
	"self assert: server results equals: 2."
	self assert: client results equals: 2. 
]

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendMessageToExecute [

	client sendMessageToExecute: #x:y: from: Point withArgs: #(1 1).
	"self assert: server results equals: 2."
	self assert: client results equals: (Point x:1 y:1). 
]

{ #category : #'as yet unclassified' }
MessageSendThroughSocketTest >> testSendMessageTroughProxyToExecute [

	| toCompare result proxy |
	toCompare:= Point x:1 y:2.
   proxy := (self newproxy: Point).
	result := proxy x:1 y:2.
	
	self assert: result equals: toCompare. 
]
