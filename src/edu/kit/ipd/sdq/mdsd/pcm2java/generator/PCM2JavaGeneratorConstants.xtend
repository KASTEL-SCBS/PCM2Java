package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.io.File

/**
 * A utility class providing String constants for PCM2Java code generation
 * 
 */

class PCM2JavaGeneratorConstants {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String getTargetFileExt() '''.java'''
	
	static def String getNewLine() {
		return System.lineSeparator
	}
	
	static def String getTargetFolderPrefix() '''src-gen«getSeparator(false)»'''
	
	static def String getSeparator(boolean pkg) {
		return if (pkg) "." else File.separator
	}
	
	static def String getSeparatorAtEnd(boolean pkg) {
		return if (pkg) "" else getSeparator(pkg)
	}
	
	static def getContractsTargetName() '''contracts'''
	
	static def getDataTypesTargetName() '''datatypes'''
	
	static def getInterfacesTargetName() '''interfaces'''
	
	static def getComponentsTargetName() '''components'''
}