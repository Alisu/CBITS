Extension { #name : #BlockClosure }

{ #category : #'*Expe-comun' }
BlockClosure >> valueInAnotherImage [

	| client |
	client := CBITSClient new.
	client sendBlockToEvaluate: self.
	^client results
]
