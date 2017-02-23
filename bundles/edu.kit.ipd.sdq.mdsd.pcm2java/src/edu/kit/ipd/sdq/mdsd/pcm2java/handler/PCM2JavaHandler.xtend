package edu.kit.ipd.sdq.mdsd.pcm2java.handler

import edu.kit.ipd.sdq.commons.ecore2txt.handler.AbstractEcoreIFile2TxtHandler
import edu.kit.ipd.sdq.commons.ecore2txt.util.Ecore2TxtUtil
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGenerator
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorModule
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import java.util.List

class PCM2JavaHandler extends AbstractEcoreIFile2TxtHandler {
	
	override getPlugInID() '''edu.kit.idp.sdq.mdsd.pcm2java'''
	
	override executeEcore2TxtGenerator(List<IFile> filteredSelection, ExecutionEvent event, String plugInID) throws ExecutionException {
		Ecore2TxtUtil.generateFromSelectedFilesInFolder(filteredSelection,new PCM2JavaGeneratorModule(),new PCM2JavaGenerator(), false, false)
	}
	
}