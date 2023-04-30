Class {
	#name : #Whiteboard,
	#superclass : #Form,
	#instVars : [
		'morph',
		'shouldDraw',
		'ourColor',
		'client'
	],
	#category : #Whiteboard
}

{ #category : #deleting }
Whiteboard >> destroy [
	client getSocket closeAndDestroy.
	Transcript show:'jebote';cr.
]

{ #category : #drawing }
Whiteboard >> drawLine: env [

	shouldDraw ifFalse:[^self].
	self getCanvas
		line: env trail first - morph position
		to: env trail second - morph position
		width: 5
		color: ourColor.
		[ client ifNotNil: [client sendData: (
			(STON toString: (Dictionary with: #point1 -> (env trail first - morph position)
											   with: #point2 -> (env trail second - morph position)
												with: #color -> (ourColor))),' '
			).]. ] fork.
	morph changed
]

{ #category : #initialization }
Whiteboard >> eraser: evt [
	ourColor := (Color white).
]

{ #category : #accessing }
Whiteboard >> getClient [
	^client
]

{ #category : #initialization }
Whiteboard >> initClient [
	client := WbClient new.
	
	
]

{ #category : #initialization }
Whiteboard >> initialize [
	super initialize.
	shouldDraw := false.
	ourColor := Color black.
]

{ #category : #accessing }
Whiteboard >> morph: aMorph [
	morph := aMorph
]

{ #category : #initialization }
Whiteboard >> pencil: evt [
	ourColor := (Color black).
]

{ #category : #initialization }
Whiteboard >> readData: aClient [ 
	| receivedData parsedData parts|
	[ aClient isConnected ] whileTrue: [ 
		aClient dataAvailable ifTrue: [ 
				receivedData := aClient receiveDataTimeout: 5.
				receivedData ifNotEmpty: [ 
					parts := receivedData substrings: ' '.
					parts do: [ :data |
						[ parsedData := STON fromString: data .
						self getCanvas
						line: (parsedData at: #point1)
						to: (parsedData at: #point2)
						width: 5
						color: (parsedData at: #color).
						] on: Error do: [ ].
						morph changed.
						 ].

			 ].		
		 ].

	 ].
		aClient closeAndDestroy .
]

{ #category : #accessing }
Whiteboard >> setColor: aColor [
	ourColor := aColor
]

{ #category : #accessing }
Whiteboard >> shouldDraw [ 
	shouldDraw := false.
]

{ #category : #initialization }
Whiteboard >> startClient [
	client start.
	[ self readData: client getSocket ] fork.
	
	
]

{ #category : #drawing }
Whiteboard >> startDrawing: env [
	shouldDraw := true.
]

{ #category : #drawing }
Whiteboard >> stopDrawing: env [
	shouldDraw := false.

]
