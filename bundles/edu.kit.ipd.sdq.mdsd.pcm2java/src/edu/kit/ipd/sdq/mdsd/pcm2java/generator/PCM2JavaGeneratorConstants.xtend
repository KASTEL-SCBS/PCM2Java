package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.io.File

/**
 * A utility class providing String constants for PCM2Java code generation
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class PCM2JavaGeneratorConstants {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns the file extension that is used for all generated files in the target folder.
	 *
	 * @return the target file extension
	 */
	static def String getTargetFileExt() '''.java'''
	
	
	static def String getNewLine() '''«System.lineSeparator»'''
	
	/**
	 * Returns the prefix that should be used for target folder names.
	 * 
	 * @return target folder name prefix
	 */
	static def String getTargetFolderPrefix() '''src-gen«getSeparator(false)»'''
	
	/**
	 * Returns a string containing either a file separator character or a package separator character ('.').
	 * 
	 * @param pkg signals if a package separator (true) or a file separator (false) is needed
	 * @return a string consisting of the separator character
	 */
	static def String getSeparator(boolean pkg) {
		return if (pkg) "." else File.separator
	}
	
	/**
     * Returns a string containing either a file separator character or a package separator character that is used at the end of a path-
     * 
     * @param pkg signals if a package separator (true) or a file separator (false) is needed
     * @return a string consisting of the separator character.
     */
	static def String getSeparatorAtEnd(boolean pkg) {
		return if (pkg) "" else getSeparator(pkg)
	}
	
	/**
	 * Returns the target name for the folder that contains all generated java files reprsenting contracts.
	 * 
	 * @return contract folder target name
	 */
	static def getContractsTargetName() '''contracts'''
	
	/**
     * Returns the target name for the folder that contains all generated java files reprsenting data types.
     * 
     * @return data types folder target name
     */
	static def getDataTypesTargetName() '''datatypes'''
	
	/**
     * Returns the target name for the folder that contains all generated java files reprsenting interfaces.
     * 
     * @return interface folder target name
     */
	static def getInterfacesTargetName() '''interfaces'''
	
    /**
     * Returns the target name for the folder that contains all generated java classes reprsenting components.
     * 
     * @return component folder target name
     */
	static def getComponentsTargetName() '''components'''

}