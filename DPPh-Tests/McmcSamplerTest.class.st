Class {
	#name : 'McmcSamplerTest',
	#superclass : 'TestCase',
	#instVars : [
		'dpp',
		'samples',
		'n',
		'gen',
		'nbIter',
		'tolerance',
		'chi'
	],
	#category : 'DPPh-Tests',
	#package : 'DPPh-Tests'
}

{ #category : 'testing' }
McmcSamplerTest class >> isAbstract [

	^ self = McmcSamplerTest
]

{ #category : 'accessing' }
McmcSamplerTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
McmcSamplerTest >> getCountOf: listOfCollections in: listOfSamples [

	^ listOfCollections collect: [ :col |
		  | listOfBooleans |
		  listOfBooleans := listOfSamples collect: [ :sampl |
			                    self sample: sampl includes: col ].
		  listOfBooleans sum: [ :elem |
			  elem
				  ifTrue: [ 1 ]
				  ifFalse: [ 0 ] ] ]
]

{ #category : 'testing' }
McmcSamplerTest >> sample: sample includes: aCollection [
	"For the moment the collection can only be either a doubleton or a singleton"

	^ aCollection size = 2
		  ifTrue: [
			  (sample includes: aCollection first)
			  & (sample includes: aCollection second) ]
		  ifFalse: [ sample includes: aCollection first ]
]

{ #category : 'running' }
McmcSamplerTest >> setUp [

	| matrixForEigVecs eigvecs eigvals rank |
	super setUp.

	chi := ChisquareEvaluation new.
	rank := 6.
	n := 10.
	nbIter := 1000.
	gen := Random new.
	tolerance := 0.05.

	matrixForEigVecs := PMMatrix
		                    rows: n
		                    columns: rank
		                    random: 1
		                    generator: gen.
	eigvecs := matrixForEigVecs orthogonalize.
	eigvals := PMVector new: rank random: 1 generator: gen.

	dpp := FiniteDPP
		       correlationWithEigenValues: eigvals
		       andVectors: eigvecs.
	dpp sampleMcmc: self classToTest withArgs: {
			nil.
			nil.
			3.
			nbIter.
			nil }.
	samples := dpp listOfSamples
]

{ #category : 'tests' }
McmcSamplerTest >> testDoubletonAdequation [

	| nbDoubleton doubletons doubleton theoricProbabilities observedData observedDistribution criticalValue degreesOfFreedom pvalue |
	nbDoubleton := 10.
	doubletons := OrderedCollection new.
	nbDoubleton timesRepeat: [
		doubleton := gen choice: n size: 2 replace: false.
		doubletons add: doubleton ].

	theoricProbabilities := doubletons collect: [ :d |
		                        dpp kernel
			                        determinantWithRows: d
			                        andColumns: d ].
	observedData := self getCountOf: doubletons in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	"criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData."
	degreesOfFreedom := nbDoubleton - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]

{ #category : 'tests' }
McmcSamplerTest >> testNoDuplicates [

	| list sum |
	list := samples collect: [ :sampl | sampl asSet size = sampl size ].
	sum := list sum: [ :elem |
		       elem
			       ifTrue: [ 1 ]
			       ifFalse: [ 0 ] ].
	self assert: sum equals: list size
]

{ #category : 'tests' }
McmcSamplerTest >> testSingletonAdequation [

	| theoricProbabilities observedData observedDistribution criticalValue degreesOfFreedom pvalue singletons |
	theoricProbabilities := dpp kernel principalDiagonal.
	singletons := (1 to: n) collect: [ :num |
		              { num } asOrderedCollection ].
	observedData := self getCountOf: singletons in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	"criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData."
	degreesOfFreedom := n - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]
