Class {
	#name : #Menu,
	#superclass : #Object,
	#instVars : [
		'start',
		'new',
		'join',
		'menu',
		'server',
		'whiteboard'
	],
	#category : #Whiteboard
}

{ #category : #initialization }
Menu >> initialize [ 
	new := New new.
	join := Join new.
	menu := Morph new.
	start := Start new.
	server := WbServer new.
	
	menu addMorph: start.
	menu addMorph: new.
	menu addMorph: join.
	
	new color: Color white.
	join color: Color white.
	start color: Color red.
	
	join extent: 300@100.
	new extent: 300@100.
	start extent: 300@100.
	new position: 0@100.
	join position: 0@200.
	
	new borderStyle: (BorderStyle simple 
			width: 1;
			color: Color black).
	join borderStyle: (BorderStyle simple 
			width: 1;
			color: Color black).
	start borderStyle: (BorderStyle simple 
			width: 1;
			color: Color black).
	new addMorph: (TextMorph new
	contents: 'New local canvas';
	color: Color black;
	center: new center).
	
	start addMorph: (TextMorph new
	contents: 'start/stop server';
	color: Color black;
	center: start center).
	
	join addMorph: (TextMorph new
	contents: 'New remote canvas';
	color: Color black;
	center: join center).
	
	join on: #mouseDown send: #join to: self.
	new on: #mouseDown send: #new to: self.
	start on: #mouseDown send: #start to: self.

]

{ #category : #initialization }
Menu >> join [
	| userInput1 userInput2 |
	Transcript show: 'join';cr.
	
userInput1 := UIManager default request: 'ip:'.
userInput2 := UIManager default request: 'port:'.

whiteboard := Main new.
whiteboard setIp: (userInput1).
whiteboard setPort: (userInput2 asNumber).
whiteboard start.


]

{ #category : #initialization }
Menu >> new [
	whiteboard := Main new.
	whiteboard start.
	Transcript show: 'new';cr.
]

{ #category : #initialization }
Menu >> show [
	menu openInWorld
]

{ #category : #accessing }
Menu >> start [
	server isRunning ifTrue: [ server stop. start color: Color red. ] 
						  ifFalse: [ server start. start color: Color green. ].
	Transcript show: 'start';cr.
]
