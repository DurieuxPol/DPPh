Class {
	#name : 'BaselineOfDPPh',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDPPh',
	#package : 'BaselineOfDPPh'
}

{ #category : 'baselines' }
BaselineOfDPPh >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'DPPh';
			package: 'DPPh-Tests' with: [ spec requires: #( 'DPPh' ) ].
		spec group: 'default' with: #( 'DPPh' 'DPPh-Tests' ) ]
]
