package edu.kit.ipd.sdq.mdsd.pcm2java.handler

class DefaultUserConfiguration implements UserConfiguration{
	
	val boolean publicFields;
	val boolean replaceStringsWithCharArrays;

	new() {
		this(false, false)
	}
	
	new(boolean publicFields, boolean replaceStringsWithCharArrays) {
		this.publicFields = publicFields
		this.replaceStringsWithCharArrays = replaceStringsWithCharArrays
	}
	
	override publicFields() {
		return publicFields
	}
	
	override replaceStringsWithCharArrays() {
		return replaceStringsWithCharArrays
	}
}