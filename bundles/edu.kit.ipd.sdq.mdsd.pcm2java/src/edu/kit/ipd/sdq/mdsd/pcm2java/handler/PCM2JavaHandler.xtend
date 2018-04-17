package edu.kit.ipd.sdq.mdsd.pcm2java.handler

import edu.kit.ipd.sdq.mdsd.ecore2txt.handler.AbstractEcoreIFile2TxtHandler
import edu.kit.ipd.sdq.mdsd.ecore2txt.util.Ecore2TxtUtil
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGenerator
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorModule
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import java.util.List

/**
 * Handler class for the PCM2Java plug-in. 
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class PCM2JavaHandler extends AbstractEcoreIFile2TxtHandler {
	
	/**
	 * Returns the ID of this plug-in.
	 * 
	 * @return ID of this plug-in
	 */
	override getPlugInID() '''edu.kit.idp.sdq.mdsd.pcm2java'''
	
	/**
	 * Executes a PCM to java code generation.
	 */
	override executeEcore2TxtGenerator(List<IFile> filteredSelection, ExecutionEvent event, String plugInID) throws ExecutionException {
		Ecore2TxtUtil.generateFromSelectedFilesInFolder(filteredSelection,new PCM2JavaGeneratorModule(),new PCM2JavaGenerator(), false, false)
	}
	
}