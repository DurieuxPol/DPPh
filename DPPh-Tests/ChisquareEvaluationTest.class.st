Class {
	#name : 'ChisquareEvaluationTest',
	#superclass : 'TestCase',
	#category : 'DPPh-Tests',
	#package : 'DPPh-Tests'
}

{ #category : 'tests' }
ChisquareEvaluationTest >> testNullHypothesisAcceptedWith5Percent [

	| theoricProba observedData chi criticalValue pval |
	theoricProba := #( 0.25 0.25 0.25 0.25 ) asOrderedCollection.
	observedData := #( 421 404 402 373 ) asOrderedCollection.
	chi := ChisquareEvaluation new.

	criticalValue := chi
		                 criticalValue2For: theoricProba
		                 and: observedData.
	pval := chi pvalueFor: criticalValue and: 3.

	self assert: pval > 0.05
]

{ #category : 'tests' }
ChisquareEvaluationTest >> testNullHypothesisRejectedWith5Percent [

	| theoricProba observedData chi criticalValue pval |
	theoricProba := #( 0.25 0.25 0.25 0.25 ) asOrderedCollection.
	observedData := #( 441 404 402 353 ) asOrderedCollection.
	chi := ChisquareEvaluation new.

	criticalValue := chi
		                 criticalValue2For: theoricProba
		                 and: observedData.
	pval := chi pvalueFor: criticalValue and: 3.

	self assert: pval < 0.05
]

{ #category : 'tests' }
ChisquareEvaluationTest >> testNullHypothesisWithDifferentCriticalValueFormulaIsAcceptedWith5Percent [

	| theoricProba observedData chi criticalValue pval observedDistrib |
	theoricProba := #( 0.25 0.25 0.25 0.25 ) asOrderedCollection.
	observedData := #( 441 404 402 353 ) asOrderedCollection.
	observedDistrib := observedData / 1600 asFloat.
	chi := ChisquareEvaluation new.

	criticalValue := chi
		                 criticalValueFor: theoricProba
		                 and: observedDistrib.
	pval := chi pvalueFor: criticalValue and: 3.

	self assert: pval > 0.05
]
