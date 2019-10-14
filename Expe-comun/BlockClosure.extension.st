Extension { #name : #BlockClosure }

{ #category : #'*Expe-comun' }
BlockClosure >> valueInAnotherImage [

	| client |
	client := CBITSClient new.
	client sendBlockToEvaluate: [ Smalltalk globals at: #Object ].
	^client results
]
