package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.util.ArrayList
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*

import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.CollectionDataTypeUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceRequiringEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository.BasicComponentUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*

class PCM2JavaGeneratorHeadAndImports {
	
	private NamedElement namedElement
	
	def String generateImportsAndClassHead(NamedElement namedElement) {
		this.namedElement = namedElement
		return generateImportsAndClassifierHead("class")
	}
	
	def String generateImportsAndInterfaceHead(NamedElement namedElement) {
		this.namedElement = namedElement
		return generateImportsAndClassifierHead("interface")
	}
	
	private def String generateImportsAndClassifierHead(String classifierType) {
		val packageDeclaration = generatePackageDeclaration()
		val imports = generateImports()
		val classifierName = namedElement.entityName
		val classifierHead = generateClassifierHeader(classifierType, classifierName)
		return packageDeclaration + imports + classifierHead
	}
	
	private def String generatePackageDeclaration() {
		return "package " + getTargetName(namedElement, true) + ''';

'''
	}
	
	private def String generateClassifierHeader(String classifierType, String classifierName) '''
	public «classifierType» «classifierName» '''
	
	private def String generateImports() {
		var imports = ""
		var elementsToImport = getElementsToImport(namedElement)
		for (elementToImport : elementsToImport) {
			imports += generateImport(elementToImport)
		}
		return imports + if (imports.equals("")) "" else '''
		
'''
	}
	
	def dispatch Iterable<? extends EObject> getElementsToImport(NamedElement namedElement) {
		throw new UnsupportedGeneratorInput("generate imports for", namedElement)
	}
	
	def dispatch Iterable<Object> getElementsToImport(CompositeDataType dataType) {
		val elementsToImport = new ArrayList<Object>
		elementsToImport.addAll(dataType.innerDeclaration_CompositeDataType.map[it.datatype_InnerDeclaration].dataTypesToImport)
		return elementsToImport
	}
	
	private def Iterable<Object> getDataTypesToImport(Iterable<DataType> dataTypes) {
		val dataTypesToImport = new HashSet<Object>
		dataTypesToImport.addAll(dataTypes.filter(CompositeDataType))
		if (dataTypes.filter(CollectionDataType).length != 0) {
			dataTypesToImport.add(Iterable)
			dataTypesToImport.add(ArrayList)
		}
		dataTypesToImport.addAll(dataTypes.filter(CollectionDataType).getInnerTypes.filter(CompositeDataType))
		return dataTypesToImport
	}
	
	def dispatch Iterable<Object> getElementsToImport(OperationInterface iface) {
		return getTypesUsedInSignaturesOfProvidedServices(iface)
	}
	
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(OperationInterface iface) {
		val usedTypes =  new HashSet<Object>
		for (providedSignature : iface.signatures__OperationInterface) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		usedTypes.remove(ArrayList) //ArrayList not needed if collection data type is only used in signature
		return usedTypes
	}
	
	def dispatch Iterable<Object> getElementsToImport(BasicComponent bc) {
		val elementsToImport = new HashSet<Object>()
		elementsToImport.addAll(bc.getProvidedInterfaces)
		elementsToImport.addAll(bc.getRequiredInterfaces)
		elementsToImport.addAll(bc.typesUsedInSignaturesOfProvidedServices)
		for (iface : bc.getAllInheritedOperationInterfaces) {
			elementsToImport.addAll(iface.typesUsedInSignaturesOfProvidedServices) // 
		}
		return elementsToImport
	}
	
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<Object>()
		for (providedInterface : ipe.getProvidedInterfaces) {
			usedTypes.addAll(getTypesUsedInSignaturesOfProvidedServices(providedInterface))
		}
		return usedTypes
	}

	private dispatch def String generateImport(EObject eObject) {
		val fullyQualifiedTypeToImport = eObject.getTargetName(true) + getSeparator(true) + eObject.getTargetFileName
		return generateImport(fullyQualifiedTypeToImport)
	}
	
	private dispatch def String generateImport(String fullyQualifiedTypeToImport) '''import «fullyQualifiedTypeToImport»;
	'''
	
	private dispatch def String generateImport(Class<?> c) '''import «c.name»;
	'''
	
}