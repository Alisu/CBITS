Extension { #name : #BlockClosure }

{ #category : #'*Expe-comun' }
BlockClosure >> valueInAnotherImage [

	| client |
	client := CBITSClient new.
	client sendBlockToExecute: [ Smalltalk globals at: #Object ].
	^client result
]
