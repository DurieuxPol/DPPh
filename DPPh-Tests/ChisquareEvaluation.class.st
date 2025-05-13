Class {
	#name : 'ChisquareEvaluation',
	#superclass : 'Object',
	#category : 'DPPh-Tests',
	#package : 'DPPh-Tests'
}

{ #category : 'accessing' }
ChisquareEvaluation >> criticalValue2For: theoricProbabilities and: observedData [

	| total |
	total := observedData sum.
	^ ((observedData - (theoricProbabilities * total)) squared
	   / (theoricProbabilities * total)) sum
]

{ #category : 'accessing' }
ChisquareEvaluation >> criticalValueFor: theoricProbabilities and: observedDistribution [

	^ ((theoricProbabilities - observedDistribution) squared
	   / theoricProbabilities) sum
]

{ #category : 'accessing' }
ChisquareEvaluation >> pvalueFor: data and: dof [
	"The integrale is calculated from data to data + 1000 (arbitrary) and not to infinity to prevent approximation error from the integrator.
Given that the curve of the function is quickly near 0 for great values of x, going to data + 1000 or to infinity doesn't make a huge difference analytically"

	^ 1 / (2 ** (dof / 2) * (dof / 2) gamma) * (PMRombergIntegrator
		   function: [ :t | t ** (dof / 2 - 1) * (t negated / 2) exp ]
		   from: data
		   to: data + 1000) evaluate
]
