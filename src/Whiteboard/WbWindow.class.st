Class {
	#name : #WbWindow,
	#superclass : #SystemWindow,
	#instVars : [
		'whiteboard'
	],
	#category : #Whiteboard
}

{ #category : #'initialize-release' }
WbWindow >> close [
	Transcript show: 'Window closed.'; cr.
	whiteboard destroy.
   super close.
]

{ #category : #initialization }
WbWindow >> initialize [
	super initialize.
	self isResizeable: false.
	self extent: (850@650).
]

{ #category : #initialization }
WbWindow >> setWb: aWhiteboard [
	whiteboard := aWhiteboard .
]
