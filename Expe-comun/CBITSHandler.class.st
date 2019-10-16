"
I am a handler.

I am supposed to work with a proxy intercepting the message for an object and i am redirecting the messages to a remote object.

I am also logging the messages for debbugging right now.
"
Class {
	#name : #CBITSHandler,
	#superclass : #Object,
	#instVars : [
		'messages'
	],
	#category : #'Expe-comun'
}

{ #category : #handling }
CBITSHandler >> handleInstanceMessage: aMessage toTarget: instance [

	| aSelector aReceiver arguments client |
	messages add: aMessage.
	
	aSelector := aMessage selector.
	aReceiver := aMessage receiver.
	arguments := aMessage arguments.
	client := CBITSClient new.
	client sendMessageToExecute: aSelector from: aReceiver withArgs: arguments
]

{ #category : #handling }
CBITSHandler >> handleMessage: aMessage toTarget: anObject [ 
	
	| aReceiver arguments client aSelector |
	messages add: aMessage.
	
	aSelector := aMessage selector.
	aReceiver := aMessage receiver.
	arguments := aMessage arguments.
	client := CBITSClient new.
	client sendMessageToExecute: aSelector from: aReceiver withArgs: arguments
]

{ #category : #handling }
CBITSHandler >> initialize [
	super initialize.
	
	messages := OrderedCollection new.
]
